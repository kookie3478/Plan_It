import 'package:flutter/material.dart';
import 'package:plan_it/modules/login/components/roleDropDownSearch.component.dart';
import 'package:plan_it/modules/login/controller/login.controller.dart';
import '../../../globalComponents/button.component.dart';
import '../../../globalComponents/customTextField.component.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController loginController = LoginController();
  @override
  void dispose() {
    super.dispose();
    loginController.email.dispose();
    loginController.password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Login",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Email",
              label: "Email",
              controller: loginController.email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Enter Password",
              isPassword: true,
              label: "Password",
              controller: loginController.password,
            ),
            const SizedBox(height: 30),
            // Admin or User role check, this value is stored inside the role text editing controller which will decide which screen to open up after login
            CustomTextField(
              hint: "Enter Role",
              label: "Role(Admin/User)",
              controller: loginController.role,
            ),
            const SizedBox(height: 30,),
            CustomButton(
              label: "Login",
              onPressed: ()=> loginController.login(context),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => loginController.goToSignup(),
                  child:
                      const Text("Signup", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            InkWell(
              onTap: ()=>loginController.forgotPassword(),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }


}
