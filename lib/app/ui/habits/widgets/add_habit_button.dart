import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddHabitButton extends StatelessWidget {
  final bool isNameValid;
  final VoidCallback onPressed;
  final Color accentColor;
  final String buttonText;

  const AddHabitButton({
    Key? key,
    required this.isNameValid,
    required this.onPressed,
    required this.accentColor,
    this.buttonText = 'ADD HABIT',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 160,
        child: ElevatedButton(
          onPressed: isNameValid ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.disabled)) {
                return Colors.grey.shade700;
              }
              return accentColor.withOpacity(0.9);
            }),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            padding: WidgetStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 14),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          child: Text(
            buttonText.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

