import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerStudentCard extends StatelessWidget {
  const ShimmerStudentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    Widget _buildShimmerContainer({double? width, double? height}) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          height: height,
          width: width,
          color: Colors.white,
        ),
      );
    }

    Widget _buildShimmerCircle(double size) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          margin: const EdgeInsets.all(4.0),
          height: size,
          width: size,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    Widget _buildInfoRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _buildShimmerContainer(width: 100, height: 16),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 4,
            child: _buildShimmerContainer(height: 16),
          ),
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        side: BorderSide(
          width: 0.1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildShimmerCircle(60),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: _buildShimmerContainer(height: 16),
                ),
                const SizedBox(width: 20),
                _buildShimmerCircle(30),
              ],
            ),
            const Divider(),
            // Duplicated rows (3 total)
            _buildInfoRow(),
            _buildInfoRow(),
            const Divider(),
            _buildInfoRow(),
          ],
        ),
      ),
    );
  }
}