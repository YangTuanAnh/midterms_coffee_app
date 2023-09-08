import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/config.dart';
import 'package:midterms_coffee_app/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Orders extends StatefulWidget {
  const Orders({super.key});
  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order> ongoingOrders = [];
  List<Order> finishedOrders = [];
  @override
  void initState() {
    super.initState();
    loadOrdersFromSharedPreferences();
  }

  void moveToHistory(Order order) {
    setState(() {
      order.isOnGoing = false;
      ongoingOrders.remove(order);
      finishedOrders.add(order);
    });
    updateOrdersInSharedPreferences();
  }

  void loadOrdersFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ordersJson = prefs.getStringList('orders') ?? [];
    setState(() {
      ongoingOrders = ordersJson
          .map((jsonString) {
            Map<String, dynamic> json = jsonDecode(jsonString);
            return Order(json['time'], json['address'], json['coffee'],
                json['price'] as double, json['isOnGoing'] as bool);
          })
          .where((order) => order.isOnGoing)
          .toList();
      finishedOrders = ordersJson
          .map((jsonString) {
            Map<String, dynamic> json = jsonDecode(jsonString);
            return Order(json['time'], json['address'], json['coffee'],
                json['price'], json['isOnGoing']);
          })
          .where((order) => !order.isOnGoing)
          .toList();
    });
  }

  void updateOrdersInSharedPreferences() async {
    List<Order> allOrders = [...ongoingOrders, ...finishedOrders];
    final prefs = await SharedPreferences.getInstance();
    List<String> ordersJson = allOrders.map((order) {
      Map<String, dynamic> orderItem = {
        'time': order.time,
        'coffee': order.coffee,
        'address': order.address,
        'price': order.price,
        'isOnGoing': order.isOnGoing
      };
      return jsonEncode(orderItem);
    }).toList();
    await prefs.setStringList('orders', ordersJson);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("My orders",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryColor)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.primaryColor),
              bottom: const TabBar(
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Ongoing'),
                  Tab(text: 'History'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                    child: TabBarView(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemCount: ongoingOrders.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: Key("Order$index"),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              moveToHistory(ongoingOrders[index]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Item moved to History")),
                              );
                            },
                            child: ListTile(
                              isThreeLine: true,
                              title: Text(ongoingOrders[index].time,
                                  style:
                                      const TextStyle(color: Colors.black26)),
                              subtitle: Wrap(
                                children: [
                                  Wrap(children: [
                                    const Icon(Icons.coffee),
                                    Text(ongoingOrders[index].coffee)
                                  ]),
                                  const Wrap(children: [
                                    Icon(Icons.place),
                                    Text("3 Addersion Court Chino Hills")
                                  ])
                                ],
                              ),
                              trailing: Text(
                                "\$${ongoingOrders[index].price.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ));
                      },
                    )),
                    Expanded(
                        child: ListView.builder(
                      itemCount: finishedOrders.length,
                      itemBuilder: (context, index) {
                        if (index >= finishedOrders.length) {
                          return Container();
                        }
                        return ListTile(
                          isThreeLine: true,
                          title: Text(finishedOrders[index].time,
                              style: const TextStyle(color: Colors.black26)),
                          subtitle: Wrap(
                            children: [
                              Wrap(children: [
                                const Icon(Icons.coffee),
                                Text(finishedOrders[index].coffee)
                              ]),
                              const Wrap(children: [
                                Icon(Icons.place),
                                Text("3 Addersion Court Chino Hills")
                              ])
                            ],
                          ),
                          trailing: Text(
                            "\$${finishedOrders[index].price.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    ))
                  ],
                )),
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: bottomNav(context, 2))
              ],
            )));

    //     DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       bottom: TabBar(
    //         tabs: [
    //           Tab(icon: Icon(Icons.directions_car)),
    //           Tab(icon: Icon(Icons.directions_transit)),
    //           Tab(icon: Icon(Icons.directions_bike)),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
