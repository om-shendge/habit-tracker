import 'package:get/get.dart';
import '../hive/hive_boxes.dart';
import '../hive/models/habit_metadata_model.dart';
import '../hive/models/habit_completion_model.dart';
import '../models/habit_model.dart';

class HabitStorageService extends GetxService {
  static HabitStorageService get instance => Get.find<HabitStorageService>();

  Future<void> saveHabit(HabitModel habit) async {
    final now = DateTime.now();

    final metadata = HabitMetadataModel(
      id: habit.id,
      name: habit.name,
      gradientColors: habit.gradientColors,
      createdAt: habit.createdAt,
      updatedAt: now,
      frequency: habit.frequency,
      targetCount: habit.targetCount,
      specificDays: habit.specificDays,
      isActive: true,
    );

    final metadataBox = HiveBoxes.getHabitsMetadataBox();
    await metadataBox.put(habit.id, metadata);

    final completionBox = HiveBoxes.getHabitsCompletionBox();
    for (final entry in habit.completedDays.entries) {
      if (entry.value) {
        final date = _parseDate(entry.key);
        final completion = HabitCompletionModel(
          habitId: habit.id,
          date: date,
          isCompleted: true,
          completedAt: now,
        );
        await completionBox.put(completion.compositeKey, completion);
      }
    }
  }

  Future<List<HabitModel>> loadAllHabits() async {
    final metadataBox = HiveBoxes.getHabitsMetadataBox();
    final completionBox = HiveBoxes.getHabitsCompletionBox();

    final habits = <HabitModel>[];

    for (final metadata in metadataBox.values.where((h) => h.isActive)) {
      final completedDays = <String, bool>{};

      final habitCompletions =
          completionBox.values.where((c) => c.habitId == metadata.id && c.isCompleted).toList();

      for (final completion in habitCompletions) {
        final dateKey = completion.dateKey;
        completedDays[dateKey] = true;
      }

      final habit = HabitModel(
        id: metadata.id,
        name: metadata.name,
        gradientColors: metadata.gradientColors,
        createdAt: metadata.createdAt,
        completedDays: completedDays,
        frequency: metadata.frequency,
        targetCount: metadata.targetCount,
        specificDays: metadata.specificDays,
      );

      habits.add(habit);
    }

    return habits;
  }

  Future<Map<String, bool>> loadHabitCompletionsForDateRange(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final completionBox = HiveBoxes.getHabitsCompletionBox();
    final completions = <String, bool>{};

    var currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      final dateKey = _dateToKey(currentDate);
      final compositeKey = '${habitId}_$dateKey';

      final completion = completionBox.get(compositeKey);
      completions[dateKey] = completion?.isCompleted ?? false;

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return completions;
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dateKey = _dateToKey(normalizedDate);
    final compositeKey = '${habitId}_$dateKey';

    final completionBox = HiveBoxes.getHabitsCompletionBox();
    final existing = completionBox.get(compositeKey);

    if (existing != null) {
      final updated = existing.copyWith(
        isCompleted: !existing.isCompleted,
        completedAt: DateTime.now(),
      );
      await completionBox.put(compositeKey, updated);
    } else {
      final completion = HabitCompletionModel(
        habitId: habitId,
        date: normalizedDate,
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await completionBox.put(compositeKey, completion);
    }

    await _updateHabitTimestamp(habitId);
  }

  Future<void> deleteHabit(String habitId) async {
    final metadataBox = HiveBoxes.getHabitsMetadataBox();
    final completionBox = HiveBoxes.getHabitsCompletionBox();

    final metadata = metadataBox.get(habitId);
    if (metadata != null) {
      final updated = metadata.copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      await metadataBox.put(habitId, updated);
    }

    final completionsToDelete =
        completionBox.values.where((c) => c.habitId == habitId).map((c) => c.compositeKey).toList();

    for (final key in completionsToDelete) {
      await completionBox.delete(key);
    }
  }

  Future<void> updateHabit(HabitModel habit) async {
    final metadataBox = HiveBoxes.getHabitsMetadataBox();
    final existing = metadataBox.get(habit.id);

    if (existing != null) {
      final updated = existing.copyWith(
        name: habit.name,
        gradientColors: habit.gradientColors,
        frequency: habit.frequency,
        targetCount: habit.targetCount,
        specificDays: habit.specificDays,
        updatedAt: DateTime.now(),
      );
      await metadataBox.put(habit.id, updated);
    }
  }

  Future<bool> isHabitCompletedOnDate(String habitId, DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dateKey = _dateToKey(normalizedDate);
    final compositeKey = '${habitId}_$dateKey';

    final completionBox = HiveBoxes.getHabitsCompletionBox();
    final completion = completionBox.get(compositeKey);

    return completion?.isCompleted ?? false;
  }

  Future<int> getHabitCompletionCount(
    String habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final completionBox = HiveBoxes.getHabitsCompletionBox();

    return completionBox.values
        .where((c) =>
            c.habitId == habitId &&
            c.isCompleted &&
            c.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            c.date.isBefore(endDate.add(const Duration(days: 1))))
        .length;
  }

  DateTime _parseDate(String dateStr) {
    final parts = dateStr.split('-');
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _updateHabitTimestamp(String habitId) async {
    final metadataBox = HiveBoxes.getHabitsMetadataBox();
    final metadata = metadataBox.get(habitId);

    if (metadata != null) {
      final updated = metadata.copyWith(updatedAt: DateTime.now());
      await metadataBox.put(habitId, updated);
    }
  }
}



