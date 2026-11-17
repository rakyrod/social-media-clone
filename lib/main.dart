import 'package:flutter/material.dart';
import 'package:flutter_application_7/auth/login.dart';
import 'package:flutter_application_7/model/userdata.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load comments that were saved the last time the app ran.
  await Userdata().loadComments();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginForm(),
    );
  }
}