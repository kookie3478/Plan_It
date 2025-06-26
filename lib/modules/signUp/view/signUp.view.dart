import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:plan_it/modules/signUp/controller/signUp.controller.dart';
import '../../../globalComponents/button.component.dart';
import '../../../globalComponents/customTextField.component.dart';

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
    signUpController.group.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text("SignUp",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            SizedBox(
              height: 40,
            ),
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
            const SizedBox(height: 30),
            CustomTextField(
              hint: "Enter Group Number",
              label: "Group Number",
              controller: signUpController.group,
            ),
            SizedBox(
              height: 30,
            ),
            Text("Select Role: ", style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
            SizedBox(height: 10,),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed:  () => signUpController.getRole("Admin"),
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  visualDensity: VisualDensity.compact,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    height: 50,
                    width: 130,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: signUpController.selectedRole.value == "Admin"
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    child: Text("Admin", style: TextStyle(color: signUpController.selectedRole.value == "Admin"
                        ? Colors.white
                        : Colors.black,),),
                  ),
                ),

                const SizedBox(width: 20),
                MaterialButton(
                  onPressed:  () => signUpController.getRole("User"),
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  visualDensity: VisualDensity.compact,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    height: 50,
                    width: 130,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: signUpController.selectedRole.value == "User"
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    child: Text("User", style: TextStyle(color: signUpController.selectedRole.value == "User"
                        ? Colors.white
                        : Colors.black,),),
                  ),
                ),

              ],
            )),
            SizedBox(height: 30,),
            CustomButton(
              label: "Signup",
              onPressed: () => signUpController.handleSignup(
                  context,
                  signUpController.email.text,
                  signUpController.password.text,
                  signUpController.name.text,
                  signUpController.role.text,
                  signUpController.group.text
              ),
            ),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () => signUpController.goToLogin(),
                child: const Text("Login", style: TextStyle(color: Colors.red)),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
