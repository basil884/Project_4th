import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/notfications/notifactions_edit/model/model_notifaction_edit.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<Notifications> {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: "Appointment Reminders",
      subtitle: "Get notified 1 hour before your visit",
      value: true,
    ),
    NotificationItem(
      title: "Lab Test Results",
      subtitle: "Receive an email when results are ready",
      value: true,
    ),
    NotificationItem(
      title: "Marketing Offers",
      subtitle: "Receive updates about new clinic features",
      value: false,
    ),
    NotificationItem(
      title: "Security Alerts",
      subtitle: "Get notified about login attempts",
      value: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(228, 255, 255, 255),

      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 11),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Notifications",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              const Text(
                "Manage how we communicate with you.",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),

                      decoration: BoxDecoration(
                        color: const Color(0xffF3F4F6),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: SwitchListTile(
                        title: Text(
                          notifications[index].title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        subtitle: Text(
                          notifications[index].subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        value: notifications[index].value,
                        activeColor: Colors.blue,

                        onChanged: (v) {
                          setState(() {
                            notifications[index].value = v;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
