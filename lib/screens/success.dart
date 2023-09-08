import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/screens/orders.dart';
import 'package:midterms_coffee_app/config.dart';

class Success extends StatefulWidget {
  const Success({super.key});
  @override
  State<Success> createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
      child: Column(children: [
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/success.png"),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Order Success",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ))),
            const Text("Your order has been placed successfully.",
                style: TextStyle(color: Color.fromARGB(50, 0, 0, 0))),
            const Text("For more details, go to my orders.",
                style: TextStyle(color: Color.fromARGB(50, 0, 0, 0)))
          ],
        )),
        Row(children: [
          Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.all(20)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Orders(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text("Track my order")))
        ])
      ]),
    ));
  }
}
