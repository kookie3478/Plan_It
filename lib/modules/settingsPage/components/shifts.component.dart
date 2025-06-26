import 'package:flutter/material.dart';

class Shift {
  final String name;
  final Color color;

  Shift({required this.name, required this.color});

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color.value,
  };

  factory Shift.fromJson(Map<String, dynamic> json) {
    return Shift(
      name: json['name'],
      color: Color(json['color']),
    );
  }
}
