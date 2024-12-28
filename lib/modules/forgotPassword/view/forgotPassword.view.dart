import 'package:flutter/material.dart';
import 'package:plan_it/modules/forgotPassword/controller/forgotPassword.controller.dart';
import '../../../globalComponents/button.component.dart';
import '../../../globalComponents/customTextField.component.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  final ForgotPasswordController forgotPasswordController = ForgotPasswordController();
  void dispose() {
    super.dispose();
    forgotPasswordController.email1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 300,),
              CustomTextField(hint: "enter registered email", label: "Reset Password with Email", controller: forgotPasswordController.email1,),
              SizedBox(height: 40,),
              CustomButton(label: "Reset Password", onPressed: ()=>forgotPasswordController.resetPassword(),)
            ],
          ),
        )
    );
  }


}



