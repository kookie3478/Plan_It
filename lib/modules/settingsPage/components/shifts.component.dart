import 'dart:ui';

class Shift {
  final String name; // Shift name (e.g., Morning, Evening)
  final DateTime startDate; // Start date of the shift
  final int consecutiveDays; // Number of consecutive days
  final Color color; // Color for visual distinction

  Shift({
    required this.name,
    required this.startDate,
    required this.consecutiveDays,
    required this.color,
  });
}