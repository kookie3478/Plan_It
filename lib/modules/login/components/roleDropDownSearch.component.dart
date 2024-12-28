import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:plan_it/modules/login/controller/login.controller.dart';

class RoleDropDownSearchComponent extends StatefulWidget {
  const RoleDropDownSearchComponent({super.key});

  @override
  _RoleDropDownSearchComponentState createState() =>
      _RoleDropDownSearchComponentState();
}

class _RoleDropDownSearchComponentState
    extends State<RoleDropDownSearchComponent> {
  // List of options for the dropdown
  final List<String> roles = ["Admin", "User"];
  LoginController loginController = LoginController();
  String? selectedRole; // To store the selected value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButton<String>(
        alignment: Alignment.center,
        menuWidth: double.infinity,
        iconSize: 30,
        //alignment: Alignment.center,
       style: TextStyle(
         fontSize: 18,
         color: context.theme.colorScheme.onSurface,
       ),
        value: selectedRole,
        hint: Text('Select your role'),
        icon: Icon(Icons.arrow_drop_down),
        isExpanded: true, // Expands to take full width
        items: roles.map((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(
                () {
              selectedRole = newValue;
              loginController.getRole(selectedRole!);
            },
          );
        },
      ),
    );
  }
}
