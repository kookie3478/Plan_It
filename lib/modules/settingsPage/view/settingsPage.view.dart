import 'package:flutter/material.dart';
import 'package:plan_it/globalComponents/textFieldForAll.component.dart';
import 'package:plan_it/modules/settingsPage/controller/settingsPge.controller.dart';

class SettingsPageView extends StatelessWidget {
  SettingsPageView({super.key});
  SettingsPageController settingsPageController= SettingsPageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25,
          color: Colors.blue,
        ),),
        centerTitle: true,
      ),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text("Add your shifts in order : ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Shift : ", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),),
                TextFieldComponent(hint: "Enter", controller: settingsPageController.shiftName, height: 40, width: 250,mx: 2,)
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Text("Days : ", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),),
                TextFieldComponent(keyboardType: TextInputType.number,hint: "Enter", controller: settingsPageController.days, height: 40, width: 250,mx: 2,)
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Text("Color : ", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),),
                TextFieldComponent(hint: "Enter", controller: settingsPageController.color, height: 40, width: 250,mx: 2,)
              ],
            )
          ],
        ),
      ),
    );
  }
}
