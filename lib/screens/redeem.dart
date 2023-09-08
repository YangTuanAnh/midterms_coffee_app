import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/config.dart';

class Redeem extends StatefulWidget {
  const Redeem({super.key});
  @override
  State<Redeem> createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  final List<String> coffeeList = [
    "Americano",
    "Cappuchino",
    "Mocha",
    "Flat White"
  ];
  int loyaltyPoints = 0;

  @override
  void initState() {
    super.initState();
    _loadLoyaltyPoints();
  }

  Future<void> _loadLoyaltyPoints() async {
    int count = await Loyalty.getLoyaltyPoints();
    setState(() {
      loyaltyPoints = count;
    });
  }

  Future<void> _saveLoyaltyPoints() async {
    await Loyalty.updateLoyaltyPoints(loyaltyPoints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Redeem",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primaryColor)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.primaryColor),
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context, loyaltyPoints);
              _saveLoyaltyPoints();
            },
          ),
        ),
        body: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) {
              return ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading:
                      Image.asset('assets/images/${coffeeList[index]}.png'),
                  title: Text(coffeeList[index]),
                  subtitle: const Text("Valid until 06.08.2023"),
                  trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () {
                        if (loyaltyPoints < 1340) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Not enough points!')),
                          );
                        } else {
                          loyaltyPoints -= 1340;
                          _saveLoyaltyPoints();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Redeemed')));
                        }
                      },
                      child: const Text("1340 pt")));
            }));
  }
}
