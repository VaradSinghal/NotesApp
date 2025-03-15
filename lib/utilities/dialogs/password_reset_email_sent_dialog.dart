import 'package:flutter/material.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevents accidental dismissals
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.black87.withOpacity(0.9), // Dark translucent background
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_reset_rounded,
              size: 60,
              color: Colors.cyanAccent,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.cyanAccent.withOpacity(0.8),
                  offset: Offset(0, 0),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Password Reset',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.cyanAccent.withOpacity(0.6),
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We have sent a password reset link to your email. Please check your inbox and follow the instructions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                elevation: 5,
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
