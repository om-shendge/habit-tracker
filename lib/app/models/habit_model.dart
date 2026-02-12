import '../ui/habits/enums/habit_frequency.dart';

class HabitModel {
  final String id;
  final String name;
  final List<int>? gradientColors;
  final DateTime createdAt;
  final Map<String, bool> completedDays;
  final HabitFrequency frequency;
  final int targetCount;
  final List<int>? specificDays;

  HabitModel({
    required this.id,
    required this.name,
    this.gradientColors,
    required this.createdAt,
    Map<String, bool>? completedDays,
    this.frequency = HabitFrequency.daily,
    this.targetCount = 1,
    this.specificDays,
  }) : completedDays = completedDays ?? {};

  bool isCompletedOnDate(DateTime date) {
    final dateKey = _dateToKey(date);
    return completedDays[dateKey] ?? false;
  }

  bool isAutoCompletedOnDate(DateTime date) {
    if (frequency == HabitFrequency.daily) return false;

    if (frequency == HabitFrequency.weekly) {
      final weekStart = _getWeekStart(date);
      final weekDates = List.generate(7, (index) => weekStart.add(Duration(days: index)));
      final completedInWeek = weekDates.where((d) => isCompletedOnDate(d)).length;

      return completedInWeek >= targetCount && !isCompletedOnDate(date);
    }

    if (frequency == HabitFrequency.monthly) {
      final monthStart = DateTime(date.year, date.month, 1);
      final monthEnd = DateTime(date.year, date.month + 1, 0);
      final monthDates =
          List.generate(monthEnd.day, (index) => monthStart.add(Duration(days: index)));
      final completedInMonth = monthDates.where((d) => isCompletedOnDate(d)).length;

      return completedInMonth >= targetCount && !isCompletedOnDate(date);
    }

    return false;
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  HabitModel toggleCompletion(DateTime date) {
    final dateKey = _dateToKey(date);
    final newCompletedDays = Map<String, bool>.from(completedDays);
    newCompletedDays[dateKey] = !(newCompletedDays[dateKey] ?? false);

    return copyWith(completedDays: newCompletedDays);
  }

  String _dateToKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<bool> getCurrentWeekCompletion() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));

    return List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      return isCompletedOnDate(date);
    });
  }

  List<DateTime> getCurrentWeekDates() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday % 7));

    return List.generate(7, (index) {
      return weekStart.add(Duration(days: index));
    });
  }

  HabitModel copyWith({
    String? id,
    String? name,
    List<int>? gradientColors,
    DateTime? createdAt,
    Map<String, bool>? completedDays,
    HabitFrequency? frequency,
    int? targetCount,
    List<int>? specificDays,
  }) {
    return HabitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gradientColors: gradientColors ?? this.gradientColors,
      createdAt: createdAt ?? this.createdAt,
      completedDays: completedDays ?? this.completedDays,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      specificDays: specificDays ?? this.specificDays,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gradientColors': gradientColors,
      'createdAt': createdAt.toIso8601String(),
      'completedDays': completedDays,
      'frequency': frequency.name,
      'targetCount': targetCount,
      'specificDays': specificDays,
    };
  }

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'],
      name: json['name'],
      gradientColors: json['gradientColors']?.cast<int>(),
      createdAt: DateTime.parse(json['createdAt']),
      completedDays: Map<String, bool>.from(json['completedDays'] ?? {}),
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => HabitFrequency.daily,
      ),
      targetCount: json['targetCount'] ?? 1,
      specificDays: json['specificDays']?.cast<int>(),
    );
  }
}



