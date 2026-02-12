import 'package:hive/hive.dart';
import 'models/habit_metadata_model.dart';
import 'models/habit_completion_model.dart';

class HiveBoxes {
  static Box<HabitMetadataModel> getHabitsMetadataBox() {
    return Hive.box<HabitMetadataModel>('habits_metadata');
  }

  static Box<HabitCompletionModel> getHabitsCompletionBox() {
    return Hive.box<HabitCompletionModel>('habits_completion');
  }
}



