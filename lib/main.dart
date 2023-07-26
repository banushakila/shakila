import 'package:flutter/material.dart';
import 'package:login_auth/authprovider.dart';
import 'package:login_auth/dashboard_screen.dart';
import 'package:login_auth/login_screen.dart';
import 'package:login_auth/screen2.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final authProvider = AuthProvider();
  // await authProvider.checkLoginStatus(); // Check login status when the app starts

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Login App',
                debugShowCheckedModeBanner: false,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          '/login': (_) => LoginScreen(),
          '/dashboard': (_) => DashboardScreen(),
          '/screen2': (_) => Screen2(),
 // Add Screen2 route
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        Provider.of<AuthProvider>(context, listen: false).checkLoginStatus();


    final authProvider = Provider.of<AuthProvider>(context);
    final isLoggedIn = authProvider.isLoggedIn;
    if (isLoggedIn) {
      Future.delayed(Duration(seconds: 2), () {
        authProvider.fetchUserProfileData();
      });
    }
    //final userProfileData = authProvider.userProfileData;
    

    if (isLoggedIn) {
      // If logged in, navigate to the appropriate screen based on the current route
      // This ensures that you stay on the current screen after a refresh
      final currentRoute = ModalRoute.of(context)!.settings.name;
      if (currentRoute == '/dashboard') {
        return DashboardScreen();
      } else if (currentRoute == '/screen2') {
        return Screen2();
      } 
      
      else {
        // Default fallback
        return DashboardScreen();
      }
    } else {
      // If not logged in, navigate to the login screen
      return LoginScreen();
    }
  }
} 

