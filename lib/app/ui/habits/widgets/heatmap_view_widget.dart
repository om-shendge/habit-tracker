import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/habit_model.dart';
import '../controller/habits_controller.dart';
import '../utils/date_interaction_utils.dart';
import '../enums/tracker_view_type.dart';
import 'habit_context_menu.dart';
import 'habit_frequency_text_widget.dart';

class HeatmapViewWidget extends StatefulWidget {
  final HabitsController controller;

  const HeatmapViewWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<HeatmapViewWidget> createState() => _HeatmapViewWidgetState();
}

class _HeatmapViewWidgetState extends State<HeatmapViewWidget> with TickerProviderStateMixin {
  final Map<String, AnimationController> _animationControllers = {};
  final Map<String, Animation<double>> _shakeAnimations = {};

  @override
  void dispose() {
    for (final controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  AnimationController _getAnimationController(String habitId) {
    if (!_animationControllers.containsKey(habitId)) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      _animationControllers[habitId] = controller;

      _shakeAnimations[habitId] = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }
    return _animationControllers[habitId]!;
  }

  void _triggerTodayAnimation(String habitId) {
    final controller = _getAnimationController(habitId);
    controller.reset();
    controller.forward();
  }

  void _initializeAnimation(String habitId) {
    _getAnimationController(habitId);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: widget.controller.habits.length,
          itemBuilder: (context, index) {
            return Obx(() {
              final habit = widget.controller.habits[index];
              return _buildHabitHeatmapCard(habit);
            });
          },
        ),
      ),
    );
  }

  Widget _buildHabitHeatmapCard(HabitModel habit) {
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

    return GestureDetector(
      onPanEnd: (details) {
        const double minVelocity = 300.0;
        if (details.velocity.pixelsPerSecond.dx.abs() > minVelocity) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            widget.controller.navigateToPreviousMonth(habit.id);
          } else {
            widget.controller.navigateToNextMonth(habit.id);
          }
        }
      },
      onLongPress: () {
        HabitContextMenu.show(
          context: context,
          habit: habit,
          habitGradient: habitGradient,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1a1c1e),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  final today = DateTime.now();
                  widget.controller.toggleHabitCompletion(habit.id, today);
                  _triggerTodayAnimation(habit.id);
                },
                child: Builder(builder: (_) {
                  final isCompletedToday = habit.isCompletedOnDate(DateTime.now());

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      gradient: isCompletedToday ? habitGradient : null,
                      color: isCompletedToday ? null : const Color(0xff2a2d30),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        if (isCompletedToday) ...[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            offset: const Offset(-2, -2),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            offset: const Offset(2, 2),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ] else ...[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(-1, -1),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.08),
                            offset: const Offset(1, 1),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isCompletedToday ? "Checked" : "Check",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isCompletedToday ? Icons.done_all : Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    HabitFrequencyTextWidget(
                      habit: habit,
                      trackerViewType: TrackerViewType.heatmap,
                    ),
                    const SizedBox(height: 8),
                    Obx(() {
                      final displayMonth = widget.controller.getDisplayMonthForHabit(habit.id);
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
                      return Text(
                        '${monthNames[displayMonth.month - 1]} ${displayMonth.year}',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                        ),
                      );
                    }),

                    Expanded(
                      child: Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.3, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              key: ValueKey(
                                  '${habit.id}_${widget.controller.getDisplayMonthForHabit(habit.id).month}_${widget.controller.getDisplayMonthForHabit(habit.id).year}'),
                              child: _buildMiniHeatmap(habit, habitGradient),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniHeatmap(HabitModel habit, LinearGradient habitGradient) {
    _initializeAnimation(habit.id);

    final now = DateTime.now();
    final displayMonth = widget.controller.getDisplayMonthForHabit(habit.id);
    final lastDayOfMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    final List<Widget> dayWidgets = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(displayMonth.year, displayMonth.month, day);
      final isCompleted = habit.isCompletedOnDate(date);
      final isAutoCompleted = habit.isAutoCompletedOnDate(date);
      final isToday = date.day == now.day && date.month == now.month && date.year == now.year;

      Widget dayWidget = GestureDetector(
        onTap: () async {
          await DateInteractionUtils.handleDateTap(
            date: date,
            habit: habit,
            controller: widget.controller,
            habitGradient: habitGradient,
            onAnimationTrigger: isToday ? () => _triggerTodayAnimation(habit.id) : null,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: (isCompleted || isAutoCompleted)
                ? habitGradient
                : LinearGradient(
                    colors: habitGradient.colors.map((color) => color.withOpacity(0.1)).toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(2),
            border: isToday ? Border.all(color: Colors.white, width: 1) : null,
            boxShadow: [
              if (isAutoCompleted) ...[
                BoxShadow(
                  color: Colors.white.withOpacity(0.25),
                  blurRadius: 4,
                  spreadRadius: -1,
                ),
              ],
            ],
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 6,
                  )
                : isAutoCompleted
                    ? const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 6,
                      )
                    : null,
          ),
        ),
      );

      if (isToday) {
        final shakeAnimation = _shakeAnimations[habit.id];
        if (shakeAnimation != null) {
          dayWidget = AnimatedBuilder(
            animation: shakeAnimation,
            builder: (context, child) {
              final shakeValue = shakeAnimation.value;
              return Transform.translate(
                offset: Offset(
                  (shakeValue * 8 * (1 - shakeValue)) *
                      (shakeValue < 0.5 ? 1 : -1),
                  0,
                ),
                child: Transform.scale(
                  scale: 1.0 + (shakeValue * 0.1),
                  child: child,
                ),
              );
            },
            child: dayWidget,
          );
        }
      }

      dayWidgets.add(dayWidget);
    }

    final crossAxisCount = (daysInMonth <= 28) ? 7 : 8;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }
}


