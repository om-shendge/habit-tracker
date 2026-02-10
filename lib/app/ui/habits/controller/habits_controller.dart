import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/habit_model.dart';
import '../../../services/habit_storage_service.dart';
import '../enums/habit_frequency.dart';
import '../add_habit_page.dart';

class HabitsController extends GetxController {
  final RxList<HabitModel> habits = <HabitModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxInt currentViewIndex = 0.obs;

  final Map<String, Rx<DateTime>> habitDisplayMonths = <String, Rx<DateTime>>{};

  final HabitStorageService _storageService = HabitStorageService.instance;

  @override
  void onInit() {
    super.onInit();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    try {
      isLoading.value = true;
      final loadedHabits = await _storageService.loadAllHabits();
      habits.value = loadedHabits;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load habits: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHabits() async {
    await _loadHabits();
  }

  Future<void> addHabit({
    required String name,
    List<int>? gradientColors,
    HabitFrequency frequency = HabitFrequency.daily,
    int targetCount = 1,
    List<int>? specificDays,
  }) async {
    try {
      final newHabit = HabitModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        gradientColors: gradientColors,
        createdAt: DateTime.now(),
        frequency: frequency,
        targetCount: targetCount,
        specificDays: specificDays,
      );

      await _storageService.saveHabit(newHabit);

      habits.add(newHabit);

      Get.snackbar(
        'Success',
        'Habit "$name" added successfully!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add habit: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateHabit({
    required String habitId,
    required String name,
    List<int>? gradientColors,
    HabitFrequency? frequency,
    int? targetCount,
    List<int>? specificDays,
  }) async {
    try {
      final habitIndex = habits.indexWhere((habit) => habit.id == habitId);
      if (habitIndex == -1) {
        Get.snackbar(
          'Error',
          'Habit not found',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }

      final existingHabit = habits[habitIndex];
      final updatedHabit = existingHabit.copyWith(
        name: name.trim(),
        gradientColors: gradientColors,
        frequency: frequency,
        targetCount: targetCount,
        specificDays: specificDays,
      );

      await _storageService.updateHabit(updatedHabit);

      habits[habitIndex] = updatedHabit;

      Get.snackbar(
        'Success',
        'Habit "$name" updated successfully!',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update habit: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    try {
      final habitIndex = habits.indexWhere((habit) => habit.id == habitId);
      if (habitIndex == -1) return;

      await _storageService.toggleHabitCompletion(habitId, date);

      final updatedHabit = habits[habitIndex].toggleCompletion(date);
      habits[habitIndex] = updatedHabit;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update habit: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _storageService.deleteHabit(habitId);

      habits.removeWhere((habit) => habit.id == habitId);

      Get.snackbar(
        'Deleted',
        'Habit removed successfully',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete habit: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  HabitModel? getHabitById(String habitId) {
    try {
      return habits.firstWhere((habit) => habit.id == habitId);
    } catch (e) {
      return null;
    }
  }

  int get habitsCount => habits.length;

  bool get hasHabits => habits.isNotEmpty;

  static const int maxHabitsLimit = 20;

  bool canAddMoreHabits() {
    return habits.length < maxHabitsLimit;
  }

  void showHabitLimitReached() {
    Get.snackbar(
      'Cannot add more than 20 habits',
      'Please delete/edit some habits',
      backgroundColor: Colors.orange.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToAddHabit() {
    if (canAddMoreHabits()) {
      Get.to(
        () => const AddHabitPage(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    } else {
      showHabitLimitReached();
    }
  }

  int get todayCompletedCount {
    final today = DateTime.now();
    return habits.where((habit) => habit.isCompletedOnDate(today)).length;
  }

  double get todayCompletionPercentage {
    if (habits.isEmpty) return 0.0;
    return (todayCompletedCount / habits.length) * 100;
  }

  void setViewIndex(int index) {
    if (index >= 0 && index <= 2) {
      currentViewIndex.value = index;
    }
  }

  bool get is5DayView => currentViewIndex.value == 0;
  bool get isMonthView => currentViewIndex.value == 1;
  bool get isHeatmapView => currentViewIndex.value == 2;

  DateTime getDisplayMonthForHabit(String habitId) {
    final rx = habitDisplayMonths.putIfAbsent(habitId, () => DateTime.now().obs);
    return rx.value;
  }

  void navigateToMonth(String habitId, DateTime month) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final targetMonth = DateTime(month.year, month.month);

    if (targetMonth.isAfter(currentMonth)) {
      return;
    }

    final rx = habitDisplayMonths.putIfAbsent(habitId, () => DateTime.now().obs);
    rx.value = targetMonth;
  }

  void navigateToPreviousMonth(String habitId) {
    final currentDisplayMonth = getDisplayMonthForHabit(habitId);
    final previousMonth = DateTime(currentDisplayMonth.year, currentDisplayMonth.month - 1);
    navigateToMonth(habitId, previousMonth);
  }

  void navigateToNextMonth(String habitId) {
    final currentDisplayMonth = getDisplayMonthForHabit(habitId);
    final nextMonth = DateTime(currentDisplayMonth.year, currentDisplayMonth.month + 1);
    navigateToMonth(habitId, nextMonth);
  }
}

