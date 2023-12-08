// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/task.dart';
// //import 'package:flutter_application_2/task.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class MyHomePage extends StatelessWidget {

//   Future<void> _handleSignIn(BuildContext context) async {
//     try {
//       // await _googleSignIn.signIn();
//       signInCheck(context);
//       //  If sign-in is successful, navigate to the home page
//     } catch (error) {
//       print('Error during Google sign in: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(252, 0, 0, 0),
//         title: Text('Google Sign-In '),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _handleSignIn(context),
//           child: Text('Sign In with Google'),
//           style: ElevatedButton.styleFrom(
//               backgroundColor: const Color.fromARGB(255, 0, 0, 0)),
//         ),
//       ),
//     );
//   }
// }

// Future<void> signInCheck(BuildContext context) async {
//   GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
//   print(GoogleSignIn().isSignedIn() == true ? 'True' : 'false');
//   gUser;
//   print(GoogleSignIn().isSignedIn() == true ? 'TRUE' : 'FALSE');
//   if (gUser?.email != null) {
//     print(gUser?.displayName);
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => Task()),
//     );
//   }
// }




import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_application_1/addtask.dart';
import 'package:flutter_application_1/task.dart';
import 'package:google_sign_in/google_sign_in.dart';


class MyHomePage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignIn(
      BuildContext context, MaterialPageRoute materialPageRoute) async {
    try {
      await _googleSignIn.signIn();
      // If sign-in is successful, navigate to the home page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Task()),
      );
    } catch (error) {
      print('Error during Google sign in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<User?> signInWithGoogle() async {
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();
        if (googleSignInAccount == null) return null;

        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        print(authResult);
        print('s');
        print('Google Sign-In Successful: ${user?.displayName}');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Task()));
        return user;
      } catch (e) {
        print('Error signing in with Google: $e');
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Text('Google Sign-In '),
      ),
      body: Center(
        child: ElevatedButton(
          // onPressed: () => _handleSignIn(context,
          // MaterialPageRoute(builder: (context) => Task())),
          onPressed: () {
            try {
              signInWithGoogle();
            } on Exception catch (e) {
              print(e);
            }
          },
          child: Center(child: Image(image: AssetImage('assets/social.png'))),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(100, 100),
              backgroundColor: Color.fromARGB(255, 255, 253, 253)),
        ),
      ),
    );
  }
}