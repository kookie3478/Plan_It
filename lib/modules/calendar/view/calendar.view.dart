import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons
                .menu_rounded)), // Don't forget to add a function to open the drawer component here
        centerTitle: true,
        title: Text(
          "Calendar",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: context.theme.colorScheme.primaryContainer,
          ),
        ),
      ),
      body: TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime(1990),
          lastDay: DateTime(2050),
        calendarFormat: format,
        onFormatChanged: (CalendarFormat _format){
            setState(() {
              format = _format;
            });
        },
        startingDayOfWeek: StartingDayOfWeek.monday,
        onDaySelected: (DateTime selectDay, DateTime focusDay){
            setState(() {
              selectedDay=selectDay;
              focusedDay=focusDay;
            });
        },
        selectedDayPredicate: (DateTime day){
            return isSameDay(selectedDay, day);
        },
        calendarStyle:CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.primaryContainer,
          ),
        ),
      ),
    );
  }
}
