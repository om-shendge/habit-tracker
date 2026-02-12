import 'package:hive/hive.dart';
import '../hive_type_ids.dart';
import '../../ui/habits/enums/habit_frequency.dart';

part 'habit_metadata_model.g.dart';

@HiveType(typeId: HiveTypeID.habit_metadata)
class HabitMetadataModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<int>? gradientColors;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime updatedAt;

  @HiveField(5)
  final HabitFrequency frequency;

  @HiveField(6)
  final int targetCount;

  @HiveField(7)
  final List<int>? specificDays;

  @HiveField(8)
  final bool isActive;

  HabitMetadataModel({
    required this.id,
    required this.name,
    this.gradientColors,
    required this.createdAt,
    required this.updatedAt,
    this.frequency = HabitFrequency.daily,
    this.targetCount = 1,
    this.specificDays,
    this.isActive = true,
  });

  HabitMetadataModel copyWith({
    String? id,
    String? name,
    List<int>? gradientColors,
    DateTime? createdAt,
    DateTime? updatedAt,
    HabitFrequency? frequency,
    int? targetCount,
    List<int>? specificDays,
    bool? isActive,
  }) {
    return HabitMetadataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gradientColors: gradientColors ?? this.gradientColors,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      specificDays: specificDays ?? this.specificDays,
      isActive: isActive ?? this.isActive,
    );
  }
}



