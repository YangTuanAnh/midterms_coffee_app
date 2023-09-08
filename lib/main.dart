import 'package:flutter/material.dart';
import 'package:midterms_coffee_app/screens/home.dart';
import 'package:midterms_coffee_app/config.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'Poppins'),
        home: EasySplashScreen(
          logo: Image.asset('./assets/images/logo.png'),
          title: const Text(
            "Ordinary Coffee House",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'),
          ),
          backgroundImage: const AssetImage('assets/images/coffeebg.png'),
          showLoader: true,
          loaderColor: Colors.white,
          loadingText:
              const Text("Loading...", style: TextStyle(color: Colors.white)),
          navigator: const Home(),
          durationInSeconds: 5,
        ));
  }
}
