import 'package:hive/hive.dart';
import '../hive_type_ids.dart';

part 'habit_completion_model.g.dart';

@HiveType(typeId: HiveTypeID.habit_completion)
class HabitCompletionModel {
  @HiveField(0)
  final String habitId;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime completedAt;

  @HiveField(4)
  final bool isAutoCompleted;

  HabitCompletionModel({
    required this.habitId,
    required this.date,
    required this.isCompleted,
    required this.completedAt,
    this.isAutoCompleted = false,
  });

  String get compositeKey {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${habitId}_$dateStr';
  }

  String get dateKey {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String get monthKey {
    return '${habitId}_${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  HabitCompletionModel copyWith({
    String? habitId,
    DateTime? date,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isAutoCompleted,
  }) {
    return HabitCompletionModel(
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      isAutoCompleted: isAutoCompleted ?? this.isAutoCompleted,
    );
  }
}



