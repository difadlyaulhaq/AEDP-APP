import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MaterialShimmer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const MaterialShimmer({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(backgroundColor: Colors.grey),
                title: Container(
                  height: 20,
                  width: screenWidth * 0.5,
                  color: Colors.grey,
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
