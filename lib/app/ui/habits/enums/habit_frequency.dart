import 'package:hive/hive.dart';
import '../../../hive/hive_type_ids.dart';

part 'habit_frequency.g.dart';

@HiveType(typeId: HiveTypeID.habit_frequency_enum)
enum HabitFrequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
}

extension HabitFrequencyExtension on HabitFrequency {
  String get displayName {
    switch (this) {
      case HabitFrequency.daily:
        return 'Every Day';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
    }
  }

  String get description {
    switch (this) {
      case HabitFrequency.daily:
        return 'Do this habit every day';
      case HabitFrequency.weekly:
        return 'Set weekly target (e.g., 3 times per week)';
      case HabitFrequency.monthly:
        return 'Set monthly target (e.g., 4 times per month)';
    }
  }
}

