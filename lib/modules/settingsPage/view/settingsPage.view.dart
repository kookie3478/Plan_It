import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../components/shifts.component.dart';
import '../controller/settingsPage.controller.dart';

class SettingsPageView extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  final TextEditingController shiftInput = TextEditingController();
  final Rx<Color> selectedColor = const Color(0xFF2196F3).obs;

  SettingsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input + Color Picker + Add Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: shiftInput,
                    decoration: const InputDecoration(
                      labelText: "Add Shift (e.g. Morning)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => GestureDetector(
                  onTap: () => _showColorPicker(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedColor.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final name = shiftInput.text.trim();
                    if (name.isNotEmpty) {
                      controller.addShift(
                        Shift(name: name, color: selectedColor.value),
                      );
                      shiftInput.clear();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text("Available Shifts:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // List of shifts with color dots
            Expanded(
              child: Obx(() {
                if (controller.shifts.isEmpty) {
                  return const Center(child: Text("No shifts added yet."));
                }
                return ListView.separated(
                  itemCount: controller.shifts.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final shift = controller.shifts[index];
                    return ListTile(
                      leading: CircleAvatar(backgroundColor: shift.color), // <-- ✅ FIXED
                      title: Text(shift.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.removeShift(shift);
                          print('Shift: ${shift.name}, Color: ${shift.color.value}');
                        },
                      ),
                    );
                  },

                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void _showColorPicker(BuildContext context) {
    Color tempColor = selectedColor.value; // local color to work with

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: ColorPicker(
              pickerColor: tempColor,
              onColorChanged: (color) {
                setState(() {
                  tempColor = color; // locally update
                });
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              selectedColor.value = tempColor; // only update reactive color once
              Navigator.pop(context);
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

}
