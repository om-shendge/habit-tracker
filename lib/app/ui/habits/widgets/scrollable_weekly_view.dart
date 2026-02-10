import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/habit_model.dart';
import '../controller/habits_controller.dart';
import '../utils/date_interaction_utils.dart';
import '../enums/tracker_view_type.dart';
import 'habit_context_menu.dart';
import 'habit_frequency_text_widget.dart';

class ScrollableWeeklyView extends StatefulWidget {
  final HabitsController controller;

  const ScrollableWeeklyView({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ScrollableWeeklyView> createState() => _ScrollableWeeklyViewState();
}

class _ScrollableWeeklyViewState extends State<ScrollableWeeklyView> {
  late ScrollController _scrollController;
  bool _showLeftFade = false;
  bool _showRightFade = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(_updateFadeEffects);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _updateFadeEffects() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final showLeft = position.pixels > 0;
    final showRight = position.pixels < position.maxScrollExtent;

    if (_showLeftFade != showLeft || _showRightFade != showRight) {
      setState(() {
        _showLeftFade = showLeft;
        _showRightFade = showRight;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final habitNameWidth = screenWidth * 0.3;
    final dayTileWidth = 40.0;
    final totalDaysWidth = dayTileWidth * 7;

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: habitNameWidth,
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.controller.habits.length,
                          itemBuilder: (context, index) {
                            final habit = widget.controller.habits[index];
                            return _buildHabitNameTile(habit);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          _showLeftFade ? Colors.transparent : Colors.black,
                          Colors.black,
                          Colors.black,
                          _showRightFade ? Colors.transparent : Colors.black,
                        ],
                        stops: const [0.0, 0.05, 0.95, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalDaysWidth,
                        child: Column(
                          children: [
                            _buildScrollableWeekHeader(dayTileWidth),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                itemCount: widget.controller.habits.length,
                                itemBuilder: (context, index) {
                                  final habit = widget.controller.habits[index];
                                  return _buildHabitDayTiles(habit, dayTileWidth);
                                },
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildScrollableWeekHeader(double dayTileWidth) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: _buildWeekDays(dayTileWidth),
      ),
    );
  }

  List<Widget> _buildWeekDays(double dayTileWidth) {
    final now = DateTime.now();
    final weekDays = <Widget>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = DateFormat('E').format(date).toUpperCase().substring(0, 2);
      final dayNumber = DateFormat('d').format(date);

      final isToday = i == 0;

      weekDays.add(
        Expanded(
          child: Column(
            children: [
              Text(
                dayName,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isToday ? Colors.white : Colors.grey[400],
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: isToday
                    ? BoxDecoration(
                        color: const Color(0xff8081DB),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Text(
                  dayNumber,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isToday ? Colors.white : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return weekDays;
  }

  Widget _buildHabitNameTile(HabitModel habit) {
    LinearGradient habitGradient;
    if (habit.gradientColors != null && habit.gradientColors!.length >= 2) {
      final colors = habit.gradientColors!.map((colorValue) => Color(colorValue)).toList();
      habitGradient = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      habitGradient = const LinearGradient(
        colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4, right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HabitContextMenu.show(
              context: context,
              habit: habit,
              habitGradient: habitGradient,
            );
          },
          onLongPress: () {
            HabitContextMenu.show(
              context: context,
              habit: habit,
              habitGradient: habitGradient,
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    habit.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  HabitFrequencyTextWidget(
                    habit: habit,
                    trackerViewType: TrackerViewType.weekly,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitDayTiles(HabitModel habit, double dayTileWidth) {
    final now = DateTime.now();
    final weekDates = List.generate(7, (index) => now.subtract(Duration(days: 6 - index)));

    LinearGradient habitGradient;
    Color habitColor;

    if (habit.gradientColors != null && habit.gradientColors!.length >= 2) {
      final colors = habit.gradientColors!.map((colorValue) => Color(colorValue)).toList();
      habitGradient = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      habitColor = colors.first;
    } else {
      habitGradient = const LinearGradient(
        colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
      habitColor = const Color(0xff6366F1);
    }

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: List.generate(7, (index) {
          final date = weekDates[index];
          final isCompleted = habit.isCompletedOnDate(date);
          final isAutoCompleted = habit.isAutoCompletedOnDate(date);

          return Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () async {
                  await DateInteractionUtils.handleDateTap(
                    date: date,
                    habit: habit,
                    controller: widget.controller,
                    habitGradient: habitGradient,
                  );
                },
                child: Container(
                  width: 28,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: (isCompleted || isAutoCompleted)
                        ? habitGradient
                        : LinearGradient(
                            colors: habitGradient.colors
                                .map((color) => color.withOpacity(0.13))
                                .toList(),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      if (isCompleted || isAutoCompleted) ...[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(-2, -2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        if (isAutoCompleted) ...[
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: -2,
                          ),
                        ],
                      ] else ...[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.08),
                          offset: const Offset(-1, -1),
                          blurRadius: 2,
                          spreadRadius: 0,
                        ),
                      ],
                    ],
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        )
                      : isAutoCompleted
                          ? const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 18,
                            )
                          : Icon(
                              Icons.close,
                              color: habitColor.withOpacity(0.6),
                              size: 16,
                            ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

