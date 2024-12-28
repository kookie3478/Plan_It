import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/applications/controller/applications.controller.dart';

import '../../../globalComponents/textFieldForAll.component.dart';

class ApplicationView extends StatelessWidget {
  ApplicationView({super.key});

  ApplicationController applicationController = ApplicationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons
                .menu_rounded)), // Don't forget to add a function to open the drawer component here
        centerTitle: true,
        title: const Text(
          "Create application",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: Colors.blue,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Text(
              "Recipients: ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldComponent(
              hint: 'Enter user profile',
              mx: 1,
              controller: applicationController.recipients,
              height: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Subject: ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldComponent(
              mx: 1,
              hint: 'Enter subject',
              controller: applicationController.subject,
              height: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Date: ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFieldComponent(
              hint: 'Enter date',
              mx: 1,
              controller: applicationController.date,
              height: 50,
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              "Body: ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                counterText: "",
                hintText: "Enter Text",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: context.theme.colorScheme.outline,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: context.theme.colorScheme.outline),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: context.theme.colorScheme.outline),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
              autofocus: false,
              maxLines: null,
              controller: applicationController.message,
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              onPressed: () async {
                if (applicationController.message.text.isNotEmpty && applicationController.date.text.isNotEmpty && applicationController.subject.text.isNotEmpty) {
                  await applicationController.sendApplication(applicationController.message.text, applicationController.subject.text, applicationController.date.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Application sent successfully!'),
                  ));
                  applicationController.message.clear();
                  applicationController.subject.clear();
                  applicationController.date.clear();
                  applicationController.recipients.clear();
                }
              },
              minWidth: 0,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.theme.colorScheme.primaryContainer,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Submit",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
