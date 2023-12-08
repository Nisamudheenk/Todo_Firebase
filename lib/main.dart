import 'package:flutter/material.dart';
//import 'package:flutter_application_1/addtask.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/home.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:flutter_application_1/task.dart';
// ignore: unused_import
import 'package:google_sign_in/google_sign_in.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp(
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
  return MaterialApp(
    home: MyHomePage(),
    debugShowCheckedModeBanner:false,
  );


  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_application_1/firebase_options.dart';
// import 'package:flutter_application_1 /home.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Your App Name',
//       home: MyHomePage()
//     );
//   }
// }