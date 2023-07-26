import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class AuthProvider with ChangeNotifier {
  final storage = FlutterSecureStorage();
  String _accessToken = '';
  bool _isLoggedIn = false;
  dynamic _userProfileData; // Define userProfileData field
    bool _isLoadingUserProfileData = false;

  String get accessToken => _accessToken;
  bool get isLoggedIn => _isLoggedIn;
  dynamic get userProfileData => _userProfileData; 
  // Define getter for userProfileData
Future<void> _saveTokenToStorage(String token) async {
    await storage.write(key: 'accessToken', value: token);
  }
  Future<void> checkLoginStatus() async {
    _accessToken = await storage.read(key: 'accessToken') ?? '';
    _isLoggedIn = _accessToken.isNotEmpty;
    notifyListeners();
    //await _fetchUserProfileData();
    
  }
Future<Map<String, dynamic>> loginUser(String email, String password) async {
  try {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    var request = http.Request('POST', Uri.parse('https://demo.trainingzone.in/api/login'));
    request.body = json.encode({
      "email": email,
      "password": password,
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // Parse the response body and return the data
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> data = json.decode(responseBody);
      return data;
    } else {
      // Return an empty map if login fails
      return {};
    }
  } catch (e) {
    // Handle any exceptions that may occur during login
    print("Failed to login: $e");
    return {};
  }
}

  Future<void> login(String email, String password) async {
    try {
      
      
      Map<String, dynamic> loginResponse = await loginUser(email, password);

    if (loginResponse.containsKey('data')) {
      // If login is successful, get the access token from the response
      String accessToken = loginResponse['data']['token'];

      if (accessToken.isNotEmpty) {
        _accessToken = accessToken;
        _isLoggedIn = true;
        await storage.write(key: 'accessToken', value:accessToken);
        //notifyListeners();

        // Fetch user profile data after login
        await fetchUserProfileData();
      } else {
        // Handle login failure
        _isLoggedIn = false;
      }
    } else {
      // Handle login failure
      _isLoggedIn = false;
    }
  } catch (e) {
    // Handle login failure
    print("Failed to login: $e");
    _isLoggedIn = false;
  }
}

Future<dynamic> getUserProfileData(String accessToken) async {
  try {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
'Authorization': 'Bearer $accessToken '   };
    var request = await http.Request('GET', Uri.parse('https://demo.trainingzone.in/api/user/me'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to fetch user profile data: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Failed to fetch user profile data: $e');
  }
}   

  Future<void> fetchUserProfileData() async {
    try {


      if (_isLoadingUserProfileData) {
        // If a request is already in progress, return without making a new request
        return;
      }

      String accessToken = this.accessToken;
      if (accessToken.isNotEmpty) {
                _isLoadingUserProfileData = true; // Set the flag to true when making the request

        dynamic userProfileData = await getUserProfileData(accessToken);
               _isLoadingUserProfileData = true; // Set the flag to true when making the request

       
        if (userProfileData != null) {
          _userProfileData = userProfileData;
          notifyListeners();
        } else {
          print("Unable to fetch user profile data");
        }
      } else {
        print("No user profile data fetched");
      }
    } catch (e) {
      print("Failed to fetch user profile data: $e");
    }
  }
        

Future<dynamic> logoutApiCall(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('https://demo.trainingzone.in/access_token/InValidate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      // Handle any exceptions that may occur during logout
      print("Failed to logout: $e");
      return e.toString();
    }
  }

  Future<void> logout() async {
  try {
    String accessToken = this.accessToken;

    // Call the logout method with the access token to invalidate it
      await logoutApiCall(accessToken);

    // Clear the access token and set login status to false
    _accessToken = '';
    _isLoggedIn = false;
    

      // Clear user profile data
      _userProfileData = null;

    // Delete the access token from storage
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'userProfileData');

    notifyListeners();
  } catch (e) {
    // Handle any exceptions that may occur during logout
    print("Failed to logout: $e");
  }
}
}
