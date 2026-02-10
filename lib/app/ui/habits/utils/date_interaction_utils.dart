import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/habit_model.dart';
import '../controller/habits_controller.dart';

class DateInteractionUtils {
  static Future<bool> handleDateTap({
    required DateTime date,
    required HabitModel habit,
    required HabitsController controller,
    required LinearGradient habitGradient,
    VoidCallback? onAnimationTrigger,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate.isAfter(today)) {
      _showFutureDateSnackbar();
      return false;
    }

    if (targetDate.isAtSameMomentAs(today)) {
      controller.toggleHabitCompletion(habit.id, date);
      onAnimationTrigger?.call();
      return true;
    }

    final confirmed = await _showPastDateConfirmationDialog(
      date: date,
      habit: habit,
      habitGradient: habitGradient,
    );

    if (confirmed) {
      controller.toggleHabitCompletion(habit.id, date);
      return true;
    }

    return false;
  }

  static void _showFutureDateSnackbar() {
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          const Icon(
            Icons.access_time,
            color: Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Hold on young man!',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
      messageText: Text(
        'The day is yet to come',
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.grey[300],
        ),
      ),
      backgroundColor: const Color(0xff2a2d30),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static Future<bool> _showPastDateConfirmationDialog({
    required DateTime date,
    required HabitModel habit,
    required LinearGradient habitGradient,
  }) async {
    final isCompleted = habit.isCompletedOnDate(date);
    final action = isCompleted ? 'uncheck' : 'check';

    final result = await Get.dialog<bool>(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff1a1c1e),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: habitGradient.colors.first.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '$action ${_formatDate(date)}?',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: habitGradient.colors.first,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(result: true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          gradient: habitGradient,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: habitGradient.colors.first.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );

    return result ?? false;
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    final weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    if (targetDate.isAtSameMomentAs(today)) {
      return 'today (${weekdayNames[date.weekday - 1]})';
    } else if (targetDate.isAtSameMomentAs(yesterday)) {
      return 'yesterday (${weekdayNames[date.weekday - 1]})';
    } else {
      return '${weekdayNames[date.weekday - 1]}, ${monthNames[date.month - 1]} ${date.day}';
    }
  }
}

