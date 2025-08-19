import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

@override
void dispose() {
  emailController.dispose();
  passwordController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Login",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 30),),
            SizedBox(height: 10,),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Email"),
                hintText: "Enter your email",
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Password"),
                hintText: "Enter your password",
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(width: double.infinity,height: 45,
            child: OutlinedButton(
              onPressed: () async {
                await AuthServiceHelper.loginWithEmail(emailController.text, passwordController.text).then((value){
                  if(value == "Login Successful"){
                  Message.show(message: "Logged In");
                  Navigator.pushReplacementNamed(context, "/home");
                }
                else{
                  Message.show(message: "Error $value");
                }
                });
                

            }, child: Text("Login")),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Need an account?"),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, "/signup");
                }, child: Text("Register"),)
              ],
            )
          ],
        ),),
      ),
    );
  }
}

