import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plan_it/modules/adminHomePage/controllers/adminHomePage.controller.dart';

class AdminHomePageView extends StatelessWidget {
   AdminHomePageView({super.key});

  AdminHomePageController adminHomePageController= AdminHomePageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu_rounded)), // Don't forget to add a function to open the drawer component here
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
                  await adminHomePageController.auth.signout();
                  adminHomePageController.goToLogin();
                },
                icon: Icon(
                  Icons.logout_outlined,
                  size: 25,
                  color: Colors.blueGrey,
                )),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [

              // Here you have the notification button where you need to add the notifications received by the user so that everyone gets the update for the holiday of dept

              Text(
                "Greeting",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 30),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "User Name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
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
                            "14/11/2024",
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
                                  fontWeight: FontWeight.w500, fontSize: 16, color: context.theme.colorScheme.onPrimary),
                            ),
                            Text(
                              "Morning",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w300, color: context.theme.colorScheme.onPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),

              // material button for opening up the shift calendar

              MaterialButton(
                onPressed: ()=> adminHomePageController.openCalendar(),
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
                      Text("Open Shift Calendar", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: context.theme.colorScheme.onPrimary),),
                      Icon(Icons.open_in_full_rounded, color: context.theme.colorScheme.outline,),

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              // material button for making a new application for a user, this application is sent to the admin
              // Also make sure that the in the home screen of the admin this material button is replaced by new requests material button which will lead him/her to the page where the

              MaterialButton(
                onPressed: ()=>adminHomePageController.showApplications(),
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
                      Text("Show All Applications", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: context.theme.colorScheme.onPrimary),),
                      Icon(Icons.add, color: context.theme.colorScheme.outline,size: 30,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
