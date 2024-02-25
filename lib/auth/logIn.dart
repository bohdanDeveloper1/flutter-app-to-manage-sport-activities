import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../adminInterface/addActivity.dart';
import '../userInterface/findActivity.dart';

class LoInScreen extends StatelessWidget {
  LoInScreen({super.key});

  final logInFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  String userEmail = '';
  String userPassword = '';
  String logInException = '';
  var db = FirebaseFirestore.instance;

  Future<bool> logInUser(String userEmail, String userPassword) async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );
      logInException = 'you are loged in';
      return true;
    } on FirebaseAuthException catch (e) {
      logInException = 'Wrong data, try again';
      return false;
    }
  }

  Future<bool> checkIfUserIsAdmin(String userEmail) async {
    final querySnapshot = await db.collection("users").where("email", isEqualTo: userEmail).get();
    for (var docSnapshot in querySnapshot.docs) {
      bool ifUserIsAdmin = docSnapshot.get('isAdmin');
      return ifUserIsAdmin;
    }
    return false; // zwróć false, jeśli nie znaleziono użytkownika z podanym adresem e-mail
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Login screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 12,),
        child: Form(
          key: logInFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value != null && EmailValidator.validate(value)) {
                    return null;
                  }
                  return 'Please enter valid email';
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        userEmail = emailController.text.toString();
                        userPassword  = passwordController.text.toString();

                        if(logInFormKey.currentState!.validate()){
                          if(await logInUser(userEmail, userPassword)){
                            // check if user is admin, (with email) and redirect user
                              bool ifUserIsAdmin = await checkIfUserIsAdmin(userEmail);

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ifUserIsAdmin ? AddActivity() : FindActivity(),
                                ),
                              );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                              content: new Text(logInException)));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                              content: new Text("Wrong email or password")));
                        }
                      },
                      child: const Text('Log in'),
                    ),
                    const SizedBox(height: 8), // додайте проміжок між кнопками, якщо потрібно
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth');
                      },
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
