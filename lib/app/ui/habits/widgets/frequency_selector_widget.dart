import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../enums/habit_frequency.dart';
import 'frequency_bottom_sheet.dart';

class FrequencySelectorWidget extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final int targetCount;
  final List<int>? specificDays;
  final Function(HabitFrequency frequency, int targetCount, List<int>? specificDays)
      onFrequencyChanged;

  const FrequencySelectorWidget({
    Key? key,
    required this.selectedFrequency,
    required this.targetCount,
    this.specificDays,
    required this.onFrequencyChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1a1c1e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Frequency',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          GestureDetector(
            onTap: () => _showFrequencyBottomSheet(context),
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xff2a2d30),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xff8081DB).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedFrequency.displayName,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (selectedFrequency != HabitFrequency.daily) ...[
                        const SizedBox(height: 2),
                        Text(
                          _getFrequencySubtext(),
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ],
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFrequencySubtext() {
    switch (selectedFrequency) {
      case HabitFrequency.weekly:
        return '$targetCount ${targetCount == 1 ? 'time' : 'times'} per week';
      case HabitFrequency.monthly:
        return '$targetCount ${targetCount == 1 ? 'time' : 'times'} per month';
      case HabitFrequency.daily:
        return '';
    }
  }

  void _showFrequencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FrequencyBottomSheet(
        selectedFrequency: selectedFrequency,
        targetCount: targetCount,
        specificDays: specificDays,
        onFrequencyChanged: onFrequencyChanged,
      ),
    );
  }
}



