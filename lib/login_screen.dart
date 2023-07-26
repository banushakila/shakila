import 'package:flutter/material.dart';

import 'package:login_auth/authprovider.dart';
import 'package:login_auth/dashboard_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  final emailController = TextEditingController();
    final passController = TextEditingController();

    String email = '';
  String password = '';
  bool _showPassword = false;
   final String accessToken = "";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

   
     return Scaffold(
      appBar: AppBar(
        title: Text("WASTE MANAGEMENT"),
        centerTitle: true,
        backgroundColor: Colors.green
      ),
body: SingleChildScrollView(
  child: Padding(
padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
     child : Form(
      key: _formKey,
  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,

    children: [
  Image.asset(
"images/gar3.png",
height: 200,
width: 200,
  ),

  SizedBox(height: 40,),
  TextFormField(
 keyboardType: TextInputType.emailAddress,
 controller: emailController,
                          decoration: InputDecoration(
                           // focusedBorder: UnderlineInputBorder
                  labelText: 'EMAILADDRESS',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                   // color: Colors.black
                  ),
                  prefixIcon:Icon(Icons.email),
                  
                    ),

   validator: (email){
   if  (email!.isEmpty) {
                     return "Please enter your email";
                   }
                   bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email) ;
                   
                   if(!emailValid){
            return "Please enter a valid email address";

                    
                   }
                    
                   return null;
                          },
                          onSaved: (value) {
                  email = value!;
                },



                    ),
                   
                   SizedBox(height:20),
                    TextFormField(
 keyboardType: TextInputType.emailAddress,
 controller: passController,
 obscureText: passToggle,
                          decoration: InputDecoration(
                            
                           // focusedBorder: UnderlineInputBorder
                  labelText: 'PASSWORD',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                  ),
                  prefixIcon:Icon(Icons.lock),

                  suffix: InkWell(
                    onTap: () {
                      setState(() {
                        passToggle = !passToggle;


                      });
                    },
        child: Icon( passToggle ? Icons.visibility : Icons.visibility_off)

                      
                    
                  )
                    ),
 validator: (password){
                            
                     if (password!.isEmpty) {
                 
                       return 'Please enter your password';
                     }
                     if (password.length  <8) {
                       return 'Password must be at least 8 characters long';
                     }
                         return null;
                          },
                          onSaved: (value) {
                  password = value!;
                },


                    ),
      

      SizedBox(height: 60),
      
      
      ElevatedButton(
                onPressed: () async {
                  await authProvider.login(
                    emailController.text,
                    passController.text,
                  );
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
              
      
            
        child: Container(
          height: 40,
            width: 300, // Optional: You can also set a specific width if needed

          decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25),


          ),
          child: Center(
            child : Text(
        'Login To Account',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
            )),
        )
       ),
       
        

       SizedBox(height: 30),

Row( mainAxisAlignment: MainAxisAlignment.center,
children: [
  //mapResponse== null?
  Text( "Don't have an Account?",
  
  style : TextStyle(
    fontSize: 17,
  ),),

  TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        FocusScope.of(context).unfocus();
      },
       
       
        child: Text("Sign Up",
        style : TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        )),

)],


),
  ],
  )

)

)),
     );
     }
  }