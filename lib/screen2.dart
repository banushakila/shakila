import 'package:flutter/material.dart';

import 'package:login_auth/authprovider.dart';
import 'package:login_auth/dashboard_screen.dart';
import 'package:login_auth/login_screen.dart';

import 'package:provider/provider.dart';

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfileData = authProvider.userProfileData;

    final isLoggedIn = authProvider.isLoggedIn;

    if (!isLoggedIn) {
      // If not logged in, navigate to the login screen or any other desired screen
      return LoginScreen();
    }

    // If logged in, display the Screen2 content
    // You can use the user profile data here if needed
    return Scaffold(
      appBar: AppBar(title: Text('Screen 2')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("images/gar2.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                ' ${userProfileData?['name'] ?? 'N/A'}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Screen3 when the "Next" button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                },
                child: Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
