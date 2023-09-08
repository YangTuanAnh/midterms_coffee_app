import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/config.dart';
import 'package:midterms_coffee_app/screens/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  final Coffee coffee;

  const Details({required this.coffee, super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  void _updatePrice() {
    setState(() {
      widget.coffee.price = 3 *
              widget.coffee.amount *
              (1 + (widget.coffee.isSingle ? 1 : 0) * 0.5) +
          widget.coffee.size * 2;
    });
  }

  void _addToCart(Coffee coffee) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cart') ?? [];
    String coffeeJson = coffeeToJson(coffee);
    cartItems.add(coffeeJson);
    await prefs.setStringList('cart', cartItems);
  }

  String coffeeToJson(Coffee coffee) {
    return '{"name": "${coffee.name}", "image": "${coffee.image}", "amount": ${coffee.amount}, "isSingle": ${coffee.isSingle}, "isCup": ${coffee.isCup}, "size": ${coffee.size}, "iceAmount": ${coffee.iceAmount}, "price": ${coffee.price}}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Details",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryColor)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.primaryColor),
            actions: [
              IconButton(
                onPressed: () {
                  // Handle shopping cart button press here
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const Cart()));
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ]),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Expanded(
                child: Card(
                    color: Colors.white70,
                    child: Image.asset(widget.coffee.image))),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: Text(widget.coffee.name,
                          style:
                              const TextStyle(color: AppColors.primaryColor))),
                  TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      onPressed: () => setState(() {
                            widget.coffee.amount--;
                            _updatePrice();
                          }),
                      child: const Text("-")),
                  Text("${widget.coffee.amount}"),
                  TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      onPressed: () => setState(() {
                            widget.coffee.amount++;
                            _updatePrice();
                          }),
                      child: const Text("+")),
                ],
              ),
            ),
            const Divider(
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    child: Text("Shot",
                        style: TextStyle(color: AppColors.primaryColor))),
                for (int i = 0; i < 2; i++)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  widget.coffee.isSingle == (i == 0)
                                      ? Colors.green
                                      : Colors.transparent,
                              foregroundColor:
                                  widget.coffee.isSingle == (i == 0)
                                      ? Colors.white
                                      : Colors.black),
                          onPressed: () => setState(() {
                                widget.coffee.isSingle = (i == 0);
                                _updatePrice();
                              }),
                          child: Text(i == 0 ? "Single" : "Double"))),
              ],
            ),
            const Divider(
              color: Colors.black12,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              const Expanded(
                  child: Text("Select",
                      style: TextStyle(color: AppColors.primaryColor))),
              for (int i = 1; i <= 2; i++)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                        onTap: () =>
                            setState(() => widget.coffee.isCup = i == 1),
                        child: Image.asset(
                          'assets/images/${i == 1 ? "cup" : "togo"}.png',
                          color: widget.coffee.isCup == (i == 1)
                              ? Colors.black
                              : Colors.grey,
                        )))
            ]),
            const Divider(
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    child: Text("Size",
                        style: TextStyle(color: AppColors.primaryColor))),
                for (int i = 1; i <= 3; i++)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                          onTap: () => setState(() {
                                widget.coffee.size = i;
                                _updatePrice();
                              }),
                          child: Image.asset(
                            'assets/images/size$i.png',
                            color: widget.coffee.size == i
                                ? Colors.black
                                : Colors.grey,
                          )))
              ],
            ),
            const Divider(
              color: Colors.black12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Expanded(
                    child: Text("Ice",
                        style: TextStyle(color: AppColors.primaryColor))),
                for (int i = 1; i <= 3; i++)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                          onTap: () => setState(() {
                                widget.coffee.iceAmount = i;
                                _updatePrice();
                              }),
                          child: Image.asset(
                            'assets/images/ice$i.png',
                            color: widget.coffee.iceAmount == i
                                ? Colors.black
                                : Colors.grey,
                          )))
              ],
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Total Amount", style: TextStyle(fontSize: 16)),
                Text("\$${widget.coffee.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))
              ],
            )),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      _addToCart(widget.coffee);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const Cart()));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.all(20)),
                    child: const Text("Add to cart"),
                  ))
                ]))
          ]),
        ));
  }
}
