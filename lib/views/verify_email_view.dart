// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/services/auth/bloc/auth_bloc.dart';
import 'package:myapp/services/auth/bloc/auth_event.dart';
import 'package:myapp/views/notes/notes_view.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  Future<void> checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });

      if (isEmailVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NotesView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFff758c), Color(0xFFff7eb3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.email, size: 80, color: Colors.white),
                const SizedBox(height: 20),
                const Text(
                  "Verify Your Email",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          "We've sent you an email verification. Please check your inbox and verify your account.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),

                        // Resend Email Button
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              const AuthEventSendEmailVerification(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Center(child: Text('Resend Verification Email', style: TextStyle(fontSize: 18))),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Check Verification Status Button
                        ElevatedButton(
                          onPressed: () async {
                            await checkEmailVerification();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.greenAccent.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Center(child: Text('Check Verification Status', style: TextStyle(fontSize: 18))),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Restart (Logout) Button
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                          },
                          child: const Text('Restart', style: TextStyle(color: Colors.pinkAccent)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
