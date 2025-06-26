import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/calendar/controller/calendar.controller.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../settingsPage/components/shifts.component.dart';
import '../../settingsPage/controller/settingsPage.controller.dart';
import '../../settingsPage/view/settingsPage.view.dart';

class ShiftCalendarView extends StatefulWidget {

  ShiftCalendarView({super.key});

  @override
  State<ShiftCalendarView> createState() => _ShiftCalendarViewState();
}

class _ShiftCalendarViewState extends State<ShiftCalendarView> {
  final ShiftCalendarController controller = Get.put(ShiftCalendarController());

  final SettingsController settingsController = Get.put(SettingsController());

  late CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.blue,),
            onPressed: () => Get.to(() => SettingsPageView()),
          ),
        ],
      ),
      body: ListView(
        children: [
          Obx(() =>
              SwitchListTile(
                title: const Text("Edit Mode"),
                value: controller.isEditMode.value,
                onChanged: (_) => controller.toggleEditMode(),
              )),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2050, 12, 31),
            rowHeight: 90,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.twoWeeks: '2 Weeks',
              CalendarFormat.week: 'Week',
            },
            focusedDay: DateTime.now(),
            onDayLongPressed: (selectedDay, _) {
              if (controller.isEditMode.value) {
                controller.selectionStart.value=controller.normalizeDate(selectedDay);
                controller.selectionEnd.value=controller.normalizeDate(selectedDay);
                controller.startSelection(selectedDay);
              }else{
                controller.clearSelection();
              }
            },
            onDaySelected: (selectedDay, _) {
              if (controller.isEditMode.value) {
                if (controller.isSelectingRange.value) {
                  controller.updateSelection(selectedDay);
                } else {
                  _showShiftDialog(context, selectedDay);
                }
              }
            },

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                return Obx(() {
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  final shift = controller.getShift(normalizedDay);
                  final isEditing = controller.isEditMode.value;
                  final isSelected = controller.getSelectedDates().any((d) =>
                  d.year == day.year && d.month == day.month && d.day == day.day);

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.lightBlueAccent
                          : (isEditing && shift != null
                          ? Colors.yellow
                          : null),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Text('${day.day}', style: TextStyle(color: shift?.color),),
                        if (shift != null)
                          Text(
                            shift.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: shift.color,
                              fontWeight: isEditing ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  );
                });
              },


              todayBuilder: (context, day, _) {
                return Obx(() {
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  final shift = controller.getShift(normalizedDay);
                  final isEditing = controller.isEditMode.value;
                  final isSelected = controller.getSelectedDates().any((d) =>
                  d.year == day.year && d.month == day.month && d.day == day.day);

                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.lightBlueAccent
                          : (isEditing && shift != null
                          ? Colors.yellow
                          : null),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(100)
                          ),
                          child: Text('${day.day}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                        ),
                        if (shift != null)
                          Text(
                            shift.name,
                            style: TextStyle(
                              fontSize: 10,
                              color: shift.color,
                              fontWeight: isEditing ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  );
                });
              },
            ),


          ),

        ],
      ),
      floatingActionButton: Obx(() {
        if (controller.isSelectingRange.value && controller.isEditMode.value) {
          return FloatingActionButton.extended(
            onPressed: () {
              _showShiftRangeDialog(context); // implement below
            },
            icon: const Icon(Icons.check),
            label: const Text("Assign to Range"),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  void _showShiftDialog(BuildContext context, DateTime day) {
    final shifts = settingsController.shifts;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Shift"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.maxFinite,
          child: Column(
            children: [
              Obx(() {
                final assignedShift = controller.getShift(day);
                return Expanded(
                  child: ListView.builder(
                    itemCount: shifts.length,
                    itemBuilder: (context, index) {
                      final shift = shifts[index];
                      final isSelected = shift.name == assignedShift?.name;
                      return ListTile(
                        title: Text(
                          shift.name,
                          style: TextStyle(
                            color: isSelected ? Colors.blue : null,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                        onTap: () {
                          if (controller.isSelectingRange.value) {
                            controller.assignShiftToSelection(shift);
                          } else {
                            controller.assignShift(day, shift);
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              }),
              const Divider(),
              if (!controller.isSelectingRange.value)
                TextButton(
                  onPressed: () {
                    controller.removeShift(day);
                    Navigator.pop(context);
                  },
                  child: const Text("Remove Shift", style: TextStyle(color: Colors.red)),
                ),
              if (controller.isSelectingRange.value)
                TextButton(
                  onPressed: () {
                    controller.clearSelection();
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel Range Selection", style: TextStyle(color: Colors.red)),
                ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showShiftRangeDialog(BuildContext context) {
    final shifts = settingsController.shifts;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Assign Shifts to Selected Range"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.maxFinite,
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: shifts.length,
                    itemBuilder: (context, index) {
                      final shift = shifts[index];
                      return ListTile(
                        title: Text(shift.name),
                        onTap: () {
                          controller.assignShiftToSelection(shift);
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  controller.removeShiftsInSelection();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text("Remove all"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showRepeatPatternDialog(context);
                },
                icon: const Icon(Icons.repeat),
                label: const Text("Repeat Pattern"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showRepeatPatternDialog(BuildContext context) {
    final shifts = settingsController.shifts;
    final TextEditingController repeatDaysController = TextEditingController();

    final selectedDates = controller.getSelectedDates()..sort((a, b) => a.compareTo(b));
    final selectedPattern = selectedDates
        .map((date) => controller.getShift(date))
        .where((shift) => shift != null)
        .cast<Shift>()
        .toList()
        .obs;

    if (selectedPattern.isEmpty) {
      Get.snackbar("No Pattern Found", "Selected range has no shifts to repeat.");
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Repeat Shift Pattern"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: double.maxFinite,
          child: Obx(() => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Selected Pattern:"),
                Wrap(
                  spacing: 6,
                  children: selectedPattern.map((s) => Chip(label: Text(s.name))).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: repeatDaysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter number of days to repeat pattern",
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final repeatDays = int.tryParse(repeatDaysController.text.trim());
                      if (selectedPattern.isNotEmpty && repeatDays != null && repeatDays > 0) {
                        controller.selectedStart.value = controller.getSelectedDates().first;
                        controller.assignPatternToRange(selectedPattern.toList(), repeatDays);
                        Navigator.pop(context);
                      } else {
                        Get.snackbar("Invalid Input", "Please select a pattern and valid day count.");
                      }
                    },
                    child: const Text("Assign Pattern"),
                  ),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }


}



