import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Makes the body scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "2023/2024",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            buildInvoiceSection("Even", [
              InvoiceItem("Tuition Fee", "February 18 2024", "AED 96,140"),
              InvoiceItem("Administrative Fee", "February 18 2024", "AED 1,000"),
            ]),
            const SizedBox(height: 16),
            buildInvoiceSection("Odd", [
              InvoiceItem("Tuition Fee", "August 18 2024", "AED 96,140"),
              InvoiceItem("Administrative Fee", "August 18 2024", "AED 1,000"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceSection(String title, List<InvoiceItem> items) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0075A2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => buildInvoiceItem(item)),
        ],
      ),
    );
  }

  Widget buildInvoiceItem(InvoiceItem item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(item.date),
                Text(item.amount),
              ],
            ),
            CircleAvatar(
              backgroundColor: const Color(0xFF0075A2),
              child: IconButton(
                icon: const Icon(Icons.file_download, color: Colors.white),
                onPressed: () {
                  // Add download functionality here
                },
              ),
            ),
          ],
        ),
        const Divider(thickness: 1, height: 20),
      ],
    );
  }
}

class InvoiceItem {
  final String title;
  final String date;
  final String amount;

  InvoiceItem(this.title, this.date, this.amount);
}
