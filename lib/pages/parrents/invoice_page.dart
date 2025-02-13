import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  bool isDownloading = false;

  Future<void> _downloadAndOpenPDF(String pdfPath) async {
    try {
      setState(() => isDownloading = true);

      // Combine base URL with relative path
      const baseUrl = "https://gold-tiger-632820.hostingersite.com/";
      final downloadUrl = Uri.parse(baseUrl).resolve(pdfPath).toString();

      // Open the URL in a browser or appropriate app
      if (await canLaunchUrl(Uri.parse(downloadUrl))) {
        await launchUrl(
          Uri.parse(downloadUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $downloadUrl';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open URL: ${e.toString()}')),
      );
    } finally {
      setState(() => isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).invoice_title),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('payments').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(S.of(context).noFilesAvailable));
          }

          final items = snapshot.data!.docs.map((doc) {
            final fatherName = doc['father_name'] ?? S.of(context).fatherName;
            final pdfPath = doc['pdf_path'] ?? '';
            return InvoiceItem(fatherName, 'February 18 2024', pdfPath);
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: buildInvoiceSection(
              context: context,
              title: S.of(context).evenSemester,
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
      )],
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