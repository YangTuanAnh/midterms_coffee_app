import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/config.dart';
import 'package:midterms_coffee_app/screens/success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Cart extends StatefulWidget {
  const Cart({super.key});
  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Coffee> cartItems = [];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  ProfileInfo _profile = ProfileInfo("", "", "", "");
  Future<void> _loadProfile() async {
    ProfileInfo profile = await ProfileManager.getProfile();
    setState(() {
      _profile = profile;
    });
  }

  double getPrice() {
    double totalPrice = 0;
    for (Coffee coffee in cartItems) {
      totalPrice += coffee.price;
    }
    return totalPrice;
  }

  @override
  void initState() {
    super.initState();
    _getCartItems();
    _loadProfile();
  }

  void _getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson = prefs.getStringList('cart') ?? [];

    setState(() => cartItems = cartItemsJson.map((jsonString) {
          Map<String, dynamic> json = jsonDecode(jsonString);
          return jsonToCoffee(json);
        }).toList());

    DateTime now = DateTime.now();
    List<String> historyItemsJson = prefs.getStringList('history') ?? [];
    List<String> ordersItemsJson = prefs.getStringList('orders') ?? [];
    int loyaltyPoints = prefs.getInt('loyaltyPoints') ?? 0;
    for (Coffee coffee in cartItems) {
      loyaltyPoints += coffee.amount * 100;
      Map<String, dynamic> historyItem = {
        'name': coffee.name,
        'time':
            '${now.day} ${months[now.month - 1]} | ${now.hour}:${now.minute >= 10 ? '' : '0'}${now.minute}',
        'points': coffee.amount * 100
      };
      Map<String, dynamic> orderItem = {
        'time':
            '${now.day} ${months[now.month - 1]} | ${now.hour}:${now.minute >= 10 ? '' : '0'}${now.minute}',
        'coffee': coffee.name,
        'address': _profile.address,
        'price': coffee.price,
        'isOnGoing': true
      };
      ordersItemsJson.add(jsonEncode(orderItem));
      historyItemsJson.add(jsonEncode(historyItem));
    }

    await prefs.setInt('loyaltyPoints', loyaltyPoints);
    await prefs.setStringList('history', historyItemsJson);
    await prefs.setStringList('orders', ordersItemsJson);
  }

  void _updateSharedPreferences(List<Coffee> cartItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> cartItemsJson =
        cartItems.map((coffee) => jsonEncode(coffeeToJson(coffee))).toList();

    await prefs.setStringList('cart', cartItemsJson);
  }

  String coffeeToJson(Coffee coffee) {
    return '{"name": "${coffee.name}", "image": "${coffee.image}", "amount": ${coffee.amount}, "isSingle": ${coffee.isSingle}, "isCup": ${coffee.isCup}, "size": ${coffee.size}, "iceAmount": ${coffee.iceAmount}, "price": ${coffee.price}}';
  }

  Coffee jsonToCoffee(Map<String, dynamic> json) {
    Coffee coffee = Coffee(json['name'] as String, json['image'] as String);
    coffee.amount = json['amount'] as int;
    coffee.isSingle = json['isSingle'] as bool;
    coffee.isCup = json['isCup'] as bool;
    coffee.size = json['size'] as int;
    coffee.iceAmount = json['iceAmount'] as int;
    coffee.price = json['price'] as double;
    return coffee;
  }

  void clearCart() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryColor),
        ),
        body: Column(
          children: [
            const Text("My Cart"),
            Expanded(
                child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(index.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      cartItems.removeAt(index);
                      getPrice();
                      _updateSharedPreferences(cartItems);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item removed from cart")),
                    );
                  },
                  child: ListTile(
                      tileColor: Colors.white70,
                      selectedColor: Colors.black26,
                      leading: Image.asset(cartItems[index].image),
                      title: Text(cartItems[index].name),
                      subtitle: Text(
                          "${cartItems[index].isSingle ? 'single' : 'double'} | ${cartItems[index].isCup ? 'hot' : 'iced'} | ${cartItems[index].size == 0 ? 'small' : (cartItems[index].size == 1 ? 'medium' : 'large')} | ${cartItems[index].iceAmount == 0 ? 'less ice' : (cartItems[index].iceAmount == 1 ? 'medium ice' : 'full ice')} | x ${cartItems[index].amount}"),
                      trailing: Text(
                          '\$${cartItems[index].price.toStringAsFixed(2)}')),
                );
              },
            )),
            Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total price"),
                        Text("\$${getPrice().toStringAsFixed(2)}")
                      ],
                    )),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.all(20)),
                          onPressed: () async {
                            if (getPrice() == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Cart is empty")),
                              );
                              return;
                            }
                            int currentLoyaltyCount =
                                await Loyalty.getLoyaltyCount();
                            currentLoyaltyCount = currentLoyaltyCount % 8 + 1;

                            await Loyalty.updateLoyaltyCount(
                                currentLoyaltyCount);
                            clearCart();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Success(),
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart),
                              Text("Checkout")
                            ],
                          )),
                    )
                  ],
                ))
          ],
        ));
  }
}
