import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "2023/2024",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                buildInvoiceSection(
                  title: "Even",
                  items: [
                    InvoiceItem("Tuition Fee", "February 18 2024", "AED 96,140"),
                    InvoiceItem("Administrative Fee", "February 18 2024", "AED 1,000"),
                  ],
                  isWide: screenWidth > 600, // Adapt layout for wide screens
                ),
                const SizedBox(height: 16),
                buildInvoiceSection(
                  title: "Odd",
                  items: [
                    InvoiceItem("Tuition Fee", "August 18 2024", "AED 96,140"),
                    InvoiceItem("Administrative Fee", "August 18 2024", "AED 1,000"),
                  ],
                  isWide: screenWidth > 600, // Adapt layout for wide screens
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildInvoiceSection({
    required String title,
    required List<InvoiceItem> items,
    required bool isWide,
  }) {
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
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        children: items
                            .sublist(0, (items.length / 2).ceil())
                            .map((item) => buildInvoiceItem(item, isWide))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        children: items
                            .sublist((items.length / 2).ceil())
                            .map((item) => buildInvoiceItem(item, isWide))
                            .toList(),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: items.map((item) => buildInvoiceItem(item, isWide)).toList(),
                ),
        ],
      ),
    );
  }

  Widget buildInvoiceItem(InvoiceItem item, bool isWide) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: isWide ? 3 : 5,
            child: Column(
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
          ),
          Flexible(
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0075A2),
              child: IconButton(
                icon: const Icon(Icons.file_download, color: Colors.white),
                onPressed: () {
                  // Add download functionality here
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InvoiceItem {
  final String title;
  final String date;
  final String amount;

  InvoiceItem(this.title, this.date, this.amount);
}
