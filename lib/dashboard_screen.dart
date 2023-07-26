import 'package:flutter/material.dart';

import 'package:login_auth/authprovider.dart';
import 'package:login_auth/screen2.dart';
import 'package:provider/provider.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
if (authProvider.userProfileData == null) {
      authProvider.fetchUserProfileData();
    }
    final userProfileData = authProvider.userProfileData;



    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Stack(
        children:[
      
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/garbage.png"), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                    onTap: () {
                      _showProfilePictureOptions(context); // Show bottom sheet on tap
                    },

              child:CircleAvatar(
                    // Display the profile picture in a CircleAvatar
                    radius: 80,
                    backgroundImage: AssetImage("images/img_avatar.png"), // Replace with your image path
                  ),
              ),
                  SizedBox(height: 20),
              Text(
                '${userProfileData?['name'] ?? 'N/A'}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'ID: ${userProfileData?['id'] ?? 'N/A'}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

Text(
  'Name: ${userProfileData?['name'] ?? 'N/A'}',
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),

Text(
  'Email: ${userProfileData?['email'] ?? 'N/A'}',
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
),
              if (userProfileData?['roles'] != null)
                ...List.generate(
                  userProfileData['roles'].length,
                  (index) {
                    var role = userProfileData['roles'][index];
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role ID: ${role['id']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Role Name: ${role['name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Guard Name: ${role['guard_name']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Created At: ${role['created_at']}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Updated At: ${role['updated_at']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    );
                  },
                ),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Logout'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Screen2 when the "Next" button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Screen2()),
                  );
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
        ]
    ),


    );
    
  }
  void _showProfilePictureOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose image from Gallery'),
              onTap: () {
                // TODO: Implement image selection from gallery
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                // TODO: Implement taking a photo
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        );
      },
    );
  }
}