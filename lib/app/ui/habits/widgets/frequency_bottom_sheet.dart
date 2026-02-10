import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../enums/habit_frequency.dart';

class FrequencyBottomSheet extends StatefulWidget {
  final HabitFrequency selectedFrequency;
  final int targetCount;
  final List<int>? specificDays;
  final Function(HabitFrequency frequency, int targetCount, List<int>? specificDays)
      onFrequencyChanged;

  const FrequencyBottomSheet({
    Key? key,
    required this.selectedFrequency,
    required this.targetCount,
    this.specificDays,
    required this.onFrequencyChanged,
  }) : super(key: key);

  @override
  State<FrequencyBottomSheet> createState() => _FrequencyBottomSheetState();
}

class _FrequencyBottomSheetState extends State<FrequencyBottomSheet> {
  late HabitFrequency _selectedFrequency;
  late int _targetCount;
  late List<int>? _specificDays;

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.selectedFrequency;
    _targetCount = widget.targetCount;
    _specificDays = widget.specificDays;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff1a1c1e),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Frequency',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildFrequencyOption(
                  HabitFrequency.daily,
                  Icons.today,
                  'Perfect for daily routines like exercise, reading, or meditation',
                ),
                const SizedBox(height: 12),
                _buildFrequencyOption(
                  HabitFrequency.weekly,
                  Icons.view_week,
                  'Great for habits you want to do multiple times per week',
                ),
                const SizedBox(height: 12),
                _buildFrequencyOption(
                  HabitFrequency.monthly,
                  Icons.calendar_month,
                  'Ideal for monthly goals like budgeting or deep cleaning',
                ),
              ],
            ),
          ),

          if (_selectedFrequency != HabitFrequency.daily) ...[
            const SizedBox(height: 24),
            _buildTargetCountSelector(),
          ],

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xff2a2d30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFrequencyChanged(_selectedFrequency, _targetCount, _specificDays);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xff8081DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Apply',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyOption(HabitFrequency frequency, IconData icon, String description) {
    final isSelected = _selectedFrequency == frequency;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFrequency = frequency;
          if (frequency == HabitFrequency.daily) {
            _targetCount = 1;
          } else if (frequency == HabitFrequency.weekly) {
            _targetCount = _targetCount > 7 ? 3 : _targetCount;
          } else if (frequency == HabitFrequency.monthly) {
            _targetCount = _targetCount > 31 ? 4 : _targetCount;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff8081DB).withOpacity(0.1) : const Color(0xff2a2d30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xff8081DB) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff8081DB) : const Color(0xff3a3d40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    frequency.displayName,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xff8081DB),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetCountSelector() {
    final maxCount = _selectedFrequency == HabitFrequency.weekly ? 7 : 31;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2a2d30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Count',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_targetCount ${_targetCount == 1 ? 'time' : 'times'} per ${_selectedFrequency == HabitFrequency.weekly ? 'week' : 'month'}',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[300],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_targetCount > 1) {
                        setState(() {
                          _targetCount--;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _targetCount > 1 ? const Color(0xff8081DB) : const Color(0xff3a3d40),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _targetCount.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      if (_targetCount < maxCount) {
                        setState(() {
                          _targetCount++;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _targetCount < maxCount
                            ? const Color(0xff8081DB)
                            : const Color(0xff3a3d40),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

