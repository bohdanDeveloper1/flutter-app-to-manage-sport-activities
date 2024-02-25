import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// authentification
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/auth.dart';
import 'auth/logIn.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    title: 'test',
      initialRoute: '/',
      routes: {
        '/': (context) => LoInScreen(),
        '/auth': (context) => CreateAnAccount(),
      },
  ));
}
