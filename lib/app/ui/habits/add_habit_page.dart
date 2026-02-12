import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'controller/habits_controller.dart';
import '../../models/habit_model.dart';
import 'enums/habit_page_mode.dart';
import 'enums/habit_frequency.dart';

import 'widgets/habit_name_input.dart';
import 'widgets/color_picker_widget.dart';
import 'widgets/frequency_selector_widget.dart';
import 'widgets/add_habit_button.dart';

class AddHabitPage extends StatefulWidget {
  final HabitPageMode mode;
  final HabitModel? habitToEdit;

  const AddHabitPage({
    Key? key,
    this.mode = HabitPageMode.add,
    this.habitToEdit,
  }) : super(key: key);

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController nameController = TextEditingController();
  LinearGradient? selectedGradient = const LinearGradient(
    colors: [Color(0xFFABDCFF), Color(0xFF0396FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  bool isNameValid = false;

  HabitFrequency selectedFrequency = HabitFrequency.daily;
  int targetCount = 1;
  List<int>? specificDays;

  final HabitsController habitsController = Get.find<HabitsController>();

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onNameChanged);

    if (widget.mode == HabitPageMode.edit && widget.habitToEdit != null) {
      final habit = widget.habitToEdit!;
      nameController.text = habit.name;
      isNameValid = habit.name.trim().length > 2;

      selectedFrequency = habit.frequency;
      targetCount = habit.targetCount;
      specificDays = habit.specificDays;

      if (habit.gradientColors != null && habit.gradientColors!.length >= 2) {
        selectedGradient = LinearGradient(
          colors: habit.gradientColors!.map((colorValue) => Color(colorValue)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }
    }
  }

  void _onNameChanged() {
    final valid = nameController.text.trim().length > 2;
    if (valid != isNameValid) {
      setState(() {
        isNameValid = valid;
      });
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    nameController.dispose();
    super.dispose();
  }

  void _handleHabitAction() async {
    if (!isNameValid) return;

    final name = nameController.text.trim();
    final gradientColors = selectedGradient?.colors.map((c) => c.value).toList();

    if (widget.mode == HabitPageMode.add) {
      await habitsController.addHabit(
        name: name,
        gradientColors: gradientColors,
        frequency: selectedFrequency,
        targetCount: targetCount,
        specificDays: specificDays,
      );
    } else {
      await habitsController.updateHabit(
        habitId: widget.habitToEdit!.id,
        name: name,
        gradientColors: gradientColors,
        frequency: selectedFrequency,
        targetCount: targetCount,
        specificDays: specificDays,
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = (selectedGradient?.colors.last) ?? const Color(0xff8081DB);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xff0b0d0f),
      appBar: null,
      body: Stack(
        children: [
          IgnorePointer(
            child: SizedBox.expand(
              child: Align(
                alignment: Alignment.topCenter,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double diameter = constraints.maxWidth * 1.6;
                    final Color base = accentColor;
                    return SizedBox(
                      width: diameter,
                      height: diameter,
                      child: Transform.translate(
                        offset: Offset(0, -diameter * 0.58),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  base.withOpacity(0.65),
                                  base.withOpacity(0.25),
                                  base.withOpacity(0.08),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.38, 0.70, 1.0],
                                center: Alignment.center,
                                radius: 0.95,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  HabitNameInput(
                    nameController: nameController,
                    isNameValid: isNameValid,
                  ),
                  const SizedBox(height: 18),
                  ColorPickerWidget(
                    selectedGradient: selectedGradient,
                    onGradientSelected: (gradient) {
                      setState(() {
                        selectedGradient = gradient;
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  FrequencySelectorWidget(
                    selectedFrequency: selectedFrequency,
                    targetCount: targetCount,
                    specificDays: specificDays,
                    onFrequencyChanged: (frequency, count, days) {
                      setState(() {
                        selectedFrequency = frequency;
                        targetCount = count;
                        specificDays = days;
                      });
                    },
                  ),
                  const SizedBox(height: 28),
                  AddHabitButton(
                    isNameValid: isNameValid,
                    onPressed: _handleHabitAction,
                    accentColor: accentColor,
                    buttonText: widget.mode.buttonText,
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



