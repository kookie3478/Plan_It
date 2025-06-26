import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/adminHomePage/controllers/adminHomePage.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../calendar/controller/calendar.controller.dart';

class AdminHomePageView extends StatefulWidget {
  AdminHomePageView({super.key});

  @override
  State<AdminHomePageView> createState() => _AdminHomePageViewState();
}

class _AdminHomePageViewState extends State<AdminHomePageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AdminHomePageController adminHomePageController =
  Get.put(AdminHomePageController());
  final ShiftCalendarController shiftCalendarController= Get.put(ShiftCalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(
                context.theme.colorScheme.onPrimaryContainer,
              ),
              backgroundColor: WidgetStateProperty.all<Color>(
                context.theme.colorScheme.surface,
              ),
            ),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          // Don't forget to add a function to open the drawer component here
          centerTitle: true,
          title: const Text(
            "Home",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Colors.blue,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  // Clear in-memory shifts
                  Get.find<ShiftCalendarController>().clearData();

                  // Clear from SharedPreferences
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('assignedShifts'); // Use your actual key
                  await adminHomePageController.auth.signout();
                  adminHomePageController.goToLogin();
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  size: 25,
                  color: Colors.blueGrey,
                )),
          ],
        ),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Text(
                    'More',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Colors.cyan),
                  ),
                ),

                MaterialButton(
                    onPressed: ()=>adminHomePageController.goToSettings(),
                    minWidth: 0,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    visualDensity: VisualDensity.compact,
                    child: const Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10,),
                        Text(
                          "Settings Page",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              // Here you have the notification button where you need to add the notifications received by the user so that everyone gets the update for the holiday of dept

              Obx(() => Text(
                adminHomePageController.greeting.value,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 30),
              )),
              const SizedBox(
                height: 15,
              ),
              Obx(() => Text(
                adminHomePageController.userName.value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w400),
              )),

              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //border: Border.all(color: Colors.green),
                        color: context.theme.colorScheme.primary,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: context.theme.colorScheme.onPrimary),
                          ),
                          Text(
                            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: context.theme.colorScheme.onPrimary),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          //border: Border.all(color: context.theme.colorScheme.scrim),
                          color: context.theme.colorScheme.primary,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Today's Shift",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: context.theme.colorScheme.onPrimary),
                            ),
                            Obx(() {
                              final todayShift = shiftCalendarController.getTodayShift();
                              return Text(
                                todayShift,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  color: context.theme.colorScheme.onPrimary,
                                ),
                              );
                            }),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // material button for opening up the shift calendar

              MaterialButton(
                onPressed: ()=>adminHomePageController.goToShiftCalendar(),
                visualDensity: VisualDensity.compact,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                minWidth: 0,
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Open Shift Calendar",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: context.theme.colorScheme.onPrimary),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color: context.theme.colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // material button for making a new application for a user, this application is sent to the admin
              // Also make sure that the in the home screen of the admin this material button is replaced by new requests material button which will lead him/her to the page where the

              MaterialButton(
                onPressed: () => adminHomePageController.showApplications(),
                visualDensity: VisualDensity.compact,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                minWidth: 0,
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Show All Applications",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: context.theme.colorScheme.onPrimary),
                      ),
                      Icon(
                        Icons.pending,
                        color: context.theme.colorScheme.outline,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: ()=>adminHomePageController.goToApprovedAppplications(),
                minWidth: 0,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(30),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Approved Applications",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: context.theme.colorScheme.onPrimary),
                      ),
                      Icon(
                        Icons.task_alt,
                        color: context.theme.colorScheme.outline,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}