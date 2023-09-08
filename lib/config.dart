import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppColors {
  static const Color primaryColor = Color(0xff324A59),
      secondaryColor = Color(0xC04F748B);
}

class Loyalty {
  static int loyaltyTot = 8;

  static Future<int> getLoyaltyCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loyaltyCount') ?? 0;
  }

  static Future<void> updateLoyaltyCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('loyaltyCount', count);
  }

  static Future<int> getLoyaltyPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loyaltyPoints') ?? 0;
  }

  static Future<void> updateLoyaltyPoints(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('loyaltyPoints', count);
  }
}

class Coffee {
  final String name;
  final String image;
  int amount = 1;
  bool isSingle = true;
  bool isCup = true;
  int size = 1;
  int iceAmount = 1;
  double price = 3.00;

  Coffee(this.name, this.image);
}

class ProfileInfo {
  String name;
  String phoneNumber;
  String email;
  String address;

  ProfileInfo(
    this.name,
    this.phoneNumber,
    this.email,
    this.address,
  );

  // Convert the ProfileInfo object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }

  // Create a ProfileInfo object from a JSON map
  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      json['name'],
      json['phoneNumber'],
      json['email'],
      json['address'],
    );
  }
}

class ProfileManager {
  static const String _keyProfile = 'profile_key';

  static Future<ProfileInfo> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileJson = prefs.getString(_keyProfile) ??
        '{"name": "Anderson", "phoneNumber": "+60134589525", "email": "Anderson@email.com", "address": "3 Addersion Court Chino Hills, HO56824, United State"}';
    Map<String, dynamic> profileMap = jsonDecode(profileJson);
    return ProfileInfo(
      profileMap['name'],
      profileMap['phoneNumber'],
      profileMap['email'],
      profileMap['address'],
    );
  }

  static Future<void> saveProfile(ProfileInfo profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileJson = jsonEncode(profile.toJson());
    prefs.setString(_keyProfile, profileJson);
  }
}

class Order {
  String time;
  String address;
  String coffee;
  double price;
  bool isOnGoing;

  Order(
    this.time,
    this.address,
    this.coffee,
    this.price,
    this.isOnGoing,
  );
}

class History {
  String name;
  String time;
  int points;

  History(this.name, this.time, this.points);
}
