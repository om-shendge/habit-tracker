import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/habits_controller.dart';

class FloatingViewToggle extends StatelessWidget {
  final HabitsController controller;

  const FloatingViewToggle({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xff2a2d30),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => controller.setViewIndex(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.is5DayView
                            ? const Color(0xff8081DB).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.calendar_view_week_outlined,
                        color: controller.is5DayView ? const Color(0xff8081DB) : Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => controller.setViewIndex(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.isMonthView
                            ? const Color(0xff8081DB).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.calendar_month_outlined,
                        color: controller.isMonthView ? const Color(0xff8081DB) : Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => controller.setViewIndex(2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.isHeatmapView
                            ? const Color(0xff8081DB).withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.grid_on_outlined,
                        color:
                            controller.isHeatmapView ? const Color(0xff8081DB) : Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}


