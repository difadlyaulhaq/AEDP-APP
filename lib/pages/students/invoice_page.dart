import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  bool isDownloading = false;

  Future<void> _downloadAndOpenPDF(String documentId) async {
    if (await Permission.storage.request().isGranted) {
      try {
        setState(() => isDownloading = true);

        // Step 1: Fetch PDF path from Firestore
        final snapshot = await FirebaseFirestore.instance
            .collection('payments')
            .doc(documentId)
            .get();

        if (!snapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File not found in Firestore')),
          );
          return;
        }

        final pdfPath = snapshot['pdf_path']; // Get relative path
        if (pdfPath == null || pdfPath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid PDF path in Firestore')),
          );
          return;
        }

        // Step 2: Combine base URL with relative path
        final baseUrl = "https://gold-tiger-632820.hostingersite.com/";
        final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

        // Step 3: Download PDF from URL
        final response = await http.get(Uri.parse(downloadUrl));
        if (response.statusCode == 200) {
          // Step 4: Save the file locally
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/${pdfPath.split('/').last}';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          // Step 5: Open the PDF file
          await OpenFile.open(filePath);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to $filePath')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to download PDF: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading file: $e')),
        );
      } finally {
        setState(() => isDownloading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required to download.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('payments').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No invoices found.'));
          }

          final items = snapshot.data!.docs.map((doc) {
            return InvoiceItem(
              doc['parent_name'] ?? 'Unknown',
              'February 18 2024', // Static date for demo
              doc.id, // Pass document ID for fetching later
            );
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: buildInvoiceSection(
              context: context,
              title: "Even Semester",
              items: items,
            ),
          );
        },
      ),
    );
  }

  Widget buildInvoiceSection({
    required BuildContext context,
    required String title,
    required List<InvoiceItem> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
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
              child: isDownloading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : IconButton(
                      icon: const Icon(Icons.file_download, color: Colors.white),
                      onPressed: () => _downloadAndOpenPDF(item.pdfPath),
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
  final String pdfPath;

  InvoiceItem(this.title, this.date, this.pdfPath);
}
