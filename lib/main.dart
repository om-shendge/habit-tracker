import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'app/hive/models/habit_metadata_model.dart';
import 'app/hive/models/habit_completion_model.dart';
import 'app/ui/habits/enums/habit_frequency.dart';
import 'app/services/habit_storage_service.dart';
import 'app/ui/habits/habits_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initHive();

  Get.put(HabitStorageService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xffFEFEFE),
        dialogBackgroundColor: const Color(0xffE0E3EB),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.poppins(
            fontSize: 24,
            color: const Color(0xff8081DB),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.poppins(
            fontSize: 20,
            color: const Color(0xff8081DB),
            fontWeight: FontWeight.normal,
          ),
        ),
        textTheme: TextTheme(
          headlineMedium: GoogleFonts.poppins(
            color: const Color(0xff98999B),
            letterSpacing: 3,
            fontSize: 18,
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 40,
            color: const Color(0xff323232),
            fontWeight: FontWeight.w500,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 20,
            color: const Color(0xff323232),
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 20,
            color: const Color(0xff98999B),
            fontWeight: FontWeight.normal,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff8081DB),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.cyan,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HabitsHome(),
    );
  }
}

Future<void> _initHive() async {
  await getApplicationDocumentsDirectory().then((dir) {
    Hive
      ..init(dir.path)
      ..registerAdapter(HabitMetadataModelAdapter())
      ..registerAdapter(HabitCompletionModelAdapter())
      ..registerAdapter(HabitFrequencyAdapter());
  });

  await Hive.openBox<HabitMetadataModel>('habits_metadata');
  await Hive.openBox<HabitCompletionModel>('habits_completion');
}
