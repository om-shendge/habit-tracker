import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/habit_model.dart';
import '../enums/habit_frequency.dart';
import '../enums/tracker_view_type.dart';

class HabitFrequencyTextWidget extends StatelessWidget {
  final HabitModel habit;
  final TrackerViewType trackerViewType;

  const HabitFrequencyTextWidget({
    Key? key,
    required this.habit,
    required this.trackerViewType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _getFrequencyText(habit, trackerViewType),
      style: _getTextStyle(trackerViewType),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getFrequencyText(HabitModel habit, TrackerViewType trackerViewType) {
    switch (habit.frequency) {
      case HabitFrequency.weekly:
        return '${habit.targetCount}x/week';
      case HabitFrequency.monthly:
        return '${habit.targetCount}x/month';
      case HabitFrequency.daily:
        return 'everyday';
    }
  }

  TextStyle _getTextStyle(TrackerViewType trackerViewType) {
    switch (trackerViewType) {
      case TrackerViewType.weekly:
        return GoogleFonts.montserrat(
          fontSize: 8,
          color: Colors.grey.withOpacity(0.7),
        );
      case TrackerViewType.month:
        return GoogleFonts.montserrat(
          fontSize: 8,
          color: Colors.grey.withOpacity(0.7),
        );
      case TrackerViewType.heatmap:
        return GoogleFonts.montserrat(
          fontSize: 8,
          color: Colors.grey.withOpacity(0.7),
        );
    }
  }
}

