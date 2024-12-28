import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plan_it/modules/home/view/home.view.dart';
import 'package:plan_it/modules/login/view/login.view.dart';

class WrapperView extends StatelessWidget {
  const WrapperView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something went wrong!",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
            );
          }
          else {
            if(snapshot.data==null){
              // user currently not logged in
              return LoginView();
            }else{
              return HomeView();
            }
          }
        },
      ),
    );
  }
}
