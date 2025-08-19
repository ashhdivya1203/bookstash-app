import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

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
            Text("Sign Up",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 30),),
            SizedBox(height: 10,),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Email"),
                hintText: "Enter you email",
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Password"),
                hintText: "Enter you password",
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(width: double.infinity,height: 45,
            child: OutlinedButton(
              onPressed: () async {
                await AuthServiceHelper.createAccountWithEmail(emailController.text, passwordController.text).then((value){
                  if(value == "Account Created"){
                    Message.show(message: "Account Created");
                    Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                  }
                  else{
                    Message.show(message: "Error: $value");
                  }
                });
               
            }, child: Text("Sign Up")),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Login In"),)
              ],
            )
          ],
        ),),
      ),
    );
  }
}