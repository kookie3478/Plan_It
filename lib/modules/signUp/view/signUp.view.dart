import 'package:flutter/material.dart';
import 'package:plan_it/modules/signUp/controller/signUp.controller.dart';
import '../../../globalComponents/button.component.dart';
import '../../../globalComponents/customTextField.component.dart';
import '../../login/components/roleDropDownSearch.component.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignUpController signUpController = SignUpController();


  @override
  void dispose() {
    super.dispose();
    signUpController.name.dispose();
    signUpController.email.dispose();
    signUpController.password.dispose();
    signUpController.missNum.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Spacer(),
            const Text("SignUp",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            SizedBox(height: 40,),
            CustomTextField(
              hint: "Enter Name",
              label: "Name",
              controller: signUpController.name,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: signUpController.email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              label: "Password",
              isPassword: true,
              controller: signUpController.password,
            ),
            SizedBox(height: 20,),
            CustomTextField(
              hint: "Enter Role",
              label: "Role (Admin/User)",
              controller: signUpController.role,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Signup",
              onPressed: ()=>signUpController.handleSignup(context, signUpController.email.text, signUpController.password.text, signUpController.name.text, signUpController.role.text),
            ),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () => signUpController.goToLogin(),
                child: const Text("Login", style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }


}