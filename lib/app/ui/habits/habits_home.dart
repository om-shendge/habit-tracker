import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller/habits_controller.dart';

import 'widgets/empty_habits_widget.dart';
import 'widgets/scrollable_weekly_view.dart';
import 'widgets/month_view_widget.dart';
import 'widgets/heatmap_view_widget.dart';
import 'widgets/floating_view_toggle.dart';

class HabitsHome extends StatefulWidget {
  const HabitsHome({Key? key}) : super(key: key);

  @override
  State<HabitsHome> createState() => _HabitsHomeState();
}

class _HabitsHomeState extends State<HabitsHome> with SingleTickerProviderStateMixin {
  late AnimationController _fabGlowController;
  late Animation<double> _fabGlowAnimation;
  bool _showGlow = false;

  @override
  void initState() {
    super.initState();

    _fabGlowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fabGlowAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabGlowController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showGlow = true;
        });
        _fabGlowController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _fabGlowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HabitsController habitsController = Get.put(HabitsController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff0b0d0f),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          'HABIT TRACKER',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.7),
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Obx(() {
            if (habitsController.hasHabits) {
              return IconButton(
                onPressed: () {
                  habitsController.navigateToAddHabit();
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
                padding: const EdgeInsets.only(right: 16),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
      floatingActionButton: Obx(() {
        if (!habitsController.hasHabits) {
          return AnimatedBuilder(
            animation: _fabGlowAnimation,
            builder: (context, child) {
              final scale = _showGlow ? _fabGlowAnimation.value : 1.0;
              return Transform.scale(
                scale: scale,
                child: FloatingActionButton.extended(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  label: Text(
                    'Add Habit',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 22,
                  ),
                  backgroundColor: Colors.amber.withOpacity(0.9),
                  elevation: 0,
                  onPressed: () {
                    habitsController.navigateToAddHabit();
                  },
                ),
              );
            },
          );
        } else {
          return FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 28,
            ),
            backgroundColor: const Color(0xff8081DB),
            onPressed: () {
              habitsController.navigateToAddHabit();
            },
          );
        }
      }),
      body: Obx(() {
        if (habitsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xff8081DB),
            ),
          );
        }

        if (!habitsController.hasHabits) {
          return const EmptyHabitsWidget();
        }

        return Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  if (habitsController.is5DayView) ...[
                    ScrollableWeeklyView(controller: habitsController),
                  ] else if (habitsController.isMonthView) ...[
                    MonthViewWidget(controller: habitsController),
                  ] else if (habitsController.isHeatmapView) ...[
                    HeatmapViewWidget(controller: habitsController),
                  ],
                ],
              ),
            ),
            FloatingViewToggle(controller: habitsController),
          ],
        );
      }),
    );
  }
}
