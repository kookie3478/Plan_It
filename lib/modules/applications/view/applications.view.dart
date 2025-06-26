import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/applications/controller/applications.controller.dart';

import '../../../globalComponents/textFieldForAll.component.dart';

class ApplicationView extends StatelessWidget {
  ApplicationView({super.key});

  final ApplicationController applicationController = Get.put(ApplicationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            const Text(
              "Recipient:",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (applicationController.isLoadingAdmins.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (applicationController.adminList.isEmpty) {
                return const Text("No recipients found for your group.");
              }

              return DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Select recipient",
                  border: OutlineInputBorder(),
                ),
                value: applicationController.selectedRecipientUid.value.isNotEmpty
                    ? applicationController.selectedRecipientUid.value
                    : null,
                items: applicationController.adminList.map((user) {
                  return DropdownMenuItem<String>(
                    value: user['uid'],
                    child: Text(user['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    applicationController.selectedRecipientUid.value = value;
                  }
                },
              );
            }),
            const SizedBox(height: 15),

            const Text("Subject:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
            const SizedBox(height: 10),
            TextFieldComponent(
              mx: 1,
              hint: 'Enter subject',
              controller: applicationController.subject,
              height: 50,
            ),
            const SizedBox(height: 15),

            const Text("Date:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
            const SizedBox(height: 10),
            TextFieldComponent(
              hint: 'Enter date',
              mx: 1,
              controller: applicationController.date,
              height: 50,
            ),
            const SizedBox(height: 18),
            const Text("Change From:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
            const SizedBox(height: 10),
            TextFieldComponent(
              mx: 1,
              hint: 'Enter current shift',
              controller: applicationController.changeFrom,
              height: 50,
            ),
            const SizedBox(height: 15),

            const Text("Change To:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
            const SizedBox(height: 10),
            TextFieldComponent(
              mx: 1,
              hint: 'Enter desired shift',
              controller: applicationController.changeTo,
              height: 50,
            ),
            const SizedBox(height: 10,),
            const Text("Body:", style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
            const SizedBox(height: 10,),
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
                  borderSide: BorderSide(color: context.theme.colorScheme.outline),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.theme.colorScheme.outline),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
              ),
              autofocus: false,
              maxLines: null,
              controller: applicationController.message,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 30),

            MaterialButton(
              onPressed: () async {
                if (applicationController.message.text.isNotEmpty &&
                    applicationController.date.text.isNotEmpty &&
                    applicationController.subject.text.isNotEmpty &&
                    applicationController.selectedRecipientUid.value.isNotEmpty &&
                    applicationController.changeFrom.text.isNotEmpty && applicationController.changeTo.text.isNotEmpty) {
                  await applicationController.sendApplication(
                    message: applicationController.message.text,
                    subject: applicationController.subject.text,
                    date: applicationController.date.text,
                    changeFrom: applicationController.changeFrom.text,
                    changeTo: applicationController.changeTo.text,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Application sent successfully!')),
                  );
                  applicationController.message.clear();
                  applicationController.subject.clear();
                  applicationController.date.clear();
                  applicationController.changeFrom.clear();
                  applicationController.changeTo.clear();
                  applicationController.selectedRecipientUid.value = '';
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
                child: const Center(
                  child: Text(
                    "Submit",
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
