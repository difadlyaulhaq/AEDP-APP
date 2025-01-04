import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/bloc/invoice_download/invoice_download_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).invoice_title), // Use localized string for title
      ),
      body: BlocProvider(
        create: (_) => InvoiceDownloadBloc(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = MediaQuery.of(context).size.width;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "2023/2024", // You can localize this too if needed
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  buildInvoiceSection(
                    context: context,
                    title: S.of(context).invoice_even,
                    items: [
                      InvoiceItem(S.of(context).tuition_fee, "February 18 2024", "uploads/6779191aa340e_week_13.pdf"),
                      InvoiceItem(S.of(context).administrative_fee, "February 18 2024", "uploads/6779191aa341e_admin_fee.pdf"),
                    ],
                    isWide: screenWidth > 600,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInvoiceSection({
    required BuildContext context,
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
                            .map((item) => buildInvoiceItem(context, item))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        children: items
                            .sublist((items.length / 2).ceil())
                            .map((item) => buildInvoiceItem(context, item))
                            .toList(),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: items.map((item) => buildInvoiceItem(context, item)).toList(),
                ),
        ],
      ),
    );
  }

  Widget buildInvoiceItem(BuildContext context, InvoiceItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(item.date),
              ],
            ),
          ),
          Flexible(
            child: CircleAvatar(
              backgroundColor: const Color(0xFF0075A2),
              child: IconButton(
                icon: const Icon(Icons.file_download, color: Colors.white),
                onPressed: () {
                  _downloadAndOpenPDF(item.pdfPath);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to download and open PDF
  Future<void> _downloadAndOpenPDF(String pdfUrl) async {
    try {
      // Step 1: Download PDF from URL
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        // Step 2: Save the file to the device
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/downloaded_file.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Step 3: Open the PDF file
        await OpenFile.open(filePath);
      } else {
        print("Failed to download PDF: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

class InvoiceItem {
  final String title;
  final String date;
  final String pdfPath;

  InvoiceItem(this.title, this.date, this.pdfPath);
}
