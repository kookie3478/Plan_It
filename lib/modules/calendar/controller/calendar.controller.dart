import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../settingsPage/components/shifts.component.dart';

class ShiftCalendarController extends GetxController {
  var isEditMode = false.obs;
  var shifts = <Shift>[].obs;
  var assignedShifts = <DateTime, Shift>{}.obs;

  final Rxn<DateTime> selectedStart = Rxn<DateTime>();
  final Rxn<DateTime> selectedEnd = Rxn<DateTime>();

  // For long-press range selection
  var isSelectingRange = false.obs;
  Rxn<DateTime> selectionStart = Rxn<DateTime>();
  Rxn<DateTime> selectionEnd = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _loadAssignedShifts();
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    if (!isEditMode.value) clearSelection();
  }

  void addShift(Shift shift) {
    if (!shifts.any((s) => s.name == shift.name)) {
      shifts.add(shift);
    }
  }

  void assignShift(DateTime date, Shift shift) {
    final normalizedDate = normalizeDate(date);
    assignedShifts[normalizedDate] = shift;
    _saveAssignedShifts();
  }

  void removeShift(DateTime date) {
    final normalizedDate = normalizeDate(date);
    assignedShifts.remove(normalizedDate);
    _saveAssignedShifts();
  }

  Shift? getShift(DateTime date) {
    final normalizedDate = normalizeDate(date);
    return assignedShifts[normalizedDate];
  }

  DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  void startSelection(DateTime day) {
    final normalized = normalizeDate(day);
    isSelectingRange.value = true;
  }

  void updateSelection(DateTime day) {
    if (!isSelectingRange.value) return;
    selectionEnd.value = normalizeDate(day);
  }

  void clearSelection() {
    isSelectingRange.value = false;
    selectionStart.value = null;
    selectionEnd.value = null;
  }

  List<DateTime> getSelectedDates() {
    final start = selectionStart.value;
    final end = selectionEnd.value;
    if (start == null || end == null) return [];

    final from = start.isBefore(end) ? start : end;
    final to = start.isAfter(end) ? start : end;

    return List.generate(to.difference(from).inDays + 1,
            (i) => DateTime(from.year, from.month, from.day + i));
  }

  void assignShiftToSelection(Shift shift) {
    for (final d in getSelectedDates()) {
      assignedShifts[normalizeDate(d)] = shift;
    }
    _saveAssignedShifts();
    clearSelection();
  }

  void removeShiftsInSelection() {
    final dates = getSelectedDates();
    for (final date in dates) {
      assignedShifts.remove(date);
    }
    _saveAssignedShifts();
    clearSelection();
  }

  void assignPatternToRange(List<Shift> pattern, int totalDays) {
    List<Shift> temp=pattern;
    if (temp.length >= 2) {
      temp.removeRange(0, 2);
    }
    selectedStart.value = getSelectedDates().last;

    if (selectedStart.value == null){
      print("hello motherfucker");
      return;
    }

    DateTime startDate = normalizeDate(selectedStart.value!);

    for (int i = 1; i <= totalDays; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      Shift shift = pattern[(i-1) % pattern.length];
      assignedShifts[normalizeDate(currentDate)] = shift;
    }

    assignedShifts.refresh();
    _saveAssignedShifts(); // Persist the pattern

    // Clear selection to reset UI state
    isSelectingRange.value = false;
    selectedStart.value = null;
    selectedEnd.value = null;
  }


  // =========================
  // SharedPreferences Storage
  // =========================

  Future<void> _saveAssignedShifts() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> shiftsMap = assignedShifts.map((date, shift) {
      return MapEntry(date.toIso8601String(), jsonEncode(shift.toJson()));
    });

    await prefs.setString('assignedShifts', jsonEncode(shiftsMap));
  }

  Future<void> _loadAssignedShifts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString('assignedShifts');

    if (stored != null) {
      final Map<String, dynamic> map = jsonDecode(stored);
      assignedShifts.value = map.map((dateString, shiftJson) {
        final date = DateTime.parse(dateString);
        final shift = Shift.fromJson(jsonDecode(shiftJson));
        return MapEntry(date, shift);
      });
    }
  }

  void clearData() {
    shifts.clear();
    assignedShifts.clear();
  }

  void loadDataForUser(String userId) async {
    assignedShifts.clear(); // Clear previous data
    // Load fresh data from Firestore or wherever
  }

  // Add this method inside ShiftCalendarController
  String getTodayShift() {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    final assignedShift = assignedShifts[todayKey];
    return assignedShift?.name ?? "No shift today";
  }

}
