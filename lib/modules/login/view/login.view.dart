import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive/hive.dart';
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
        child: ListView(
          children: [
            SizedBox(height: 100,),
            const Text("Login", textAlign: TextAlign.center,
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
            const Text("Select Role:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed:  () => loginController.getRole("Admin"),
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
                      color: loginController.selectedRole.value == "Admin"
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    child: Text("Admin", style: TextStyle(color: loginController.selectedRole.value == "Admin"
                        ? Colors.white
                        : Colors.black,),),
                  ),
                ),

                const SizedBox(width: 20),
                MaterialButton(
                  onPressed:  () => loginController.getRole("User"),
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
                      color: loginController.selectedRole.value == "User"
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    child: Text("User", style: TextStyle(color: loginController.selectedRole.value == "User"
                        ? Colors.white
                        : Colors.black,),),
                  ),
                ),

              ],
            )),

            const SizedBox(height: 20),

// Optional: still allow manual typing if needed
//             CustomTextField(
//               hint: "Enter Role",
//               label: "Role (optional manual entry)",
//               controller: loginController.role,
//             ),

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
                textAlign: TextAlign.center,
                "Forgot Password?",
                style: TextStyle(color: Colors.blue),
              ),
            ),

          ],
        ),
      ),
    );
  }


}
