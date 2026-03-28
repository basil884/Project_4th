import 'package:flutter/material.dart';
import 'package:sugar_wise/features/patient/add_payment/add_payment.dart';
import 'package:sugar_wise/features/patient/mobile_billing_plans/model/billiing_model.dart';

class Billing extends StatelessWidget {
  Billing({super.key});

  List<BillingModel> billingList = [
    BillingModel(
      date: "Oct 24, 2024",
      title: "Consultation - Dr. Ali",
      price: 50,
    ),
    BillingModel(
      date: "Sep 24, 2024",
      title: "Monthly Subscription",
      price: 19.99,
    ),
    BillingModel(date: "Aug 24, 2024", title: "Lab Analysis", price: 35),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F5),

      appBar: AppBar(
        title: const Text(
          "Billing & Plans",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Billing & Plans",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              Row(
                children: const [
                  Icon(Icons.credit_card, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    "Payment Method",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// VISA CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffEBF2FF),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "VISA",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) {
                                return AddPyment();
                              },
                            );
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: const Text(
                              "PRIMARY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "**** **** **** 4242",
                      style: TextStyle(fontSize: 18, letterSpacing: 2),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "EXPIRES 12/25",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Billing History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              ListView.builder(
                itemCount: billingList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemBuilder: (context, index) {
                  final bill = billingList[index];

                  return Card(
                    color: const Color.fromARGB(218, 255, 255, 255),
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 15),

                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bill.date,
                                style: const TextStyle(color: Colors.grey),
                              ),

                              const Text(
                                "Paid",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),

                          Text(
                            bill.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${bill.price}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Invoice",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
