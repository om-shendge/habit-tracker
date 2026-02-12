enum HabitPageMode {
  add,
  edit;

  String get title {
    switch (this) {
      case HabitPageMode.add:
        return 'ADD HABIT';
      case HabitPageMode.edit:
        return 'EDIT HABIT';
    }
  }

  String get buttonText {
    switch (this) {
      case HabitPageMode.add:
        return 'Add Habit';
      case HabitPageMode.edit:
        return 'Update';
    }
  }

  String get successMessage {
    switch (this) {
      case HabitPageMode.add:
        return 'added successfully!';
      case HabitPageMode.edit:
        return 'updated successfully!';
    }
  }
}



