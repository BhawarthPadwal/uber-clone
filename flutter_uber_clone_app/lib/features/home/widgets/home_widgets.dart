import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/bloc/home_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/widgets/search_captain_bottom_sheet.dart';
import 'package:flutter_uber_clone_app/utils/widgets/app_widgets.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class HomeWidgets {
  static Widget buildShimmerLoader() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget buildInfoRow(dynamic icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          icon is IconData
              ? Icon(icon, color: AppColors.black, size: 28)
              : Image.asset(icon, height: 28, width: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppSizes.fontMedium,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
