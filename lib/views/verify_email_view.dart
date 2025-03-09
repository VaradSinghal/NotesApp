import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/main.dart';

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
    // Check email verification status when the widget is first loaded
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
        // Navigate to NotesView if email is verified
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NotesView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address:'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Verification email sent!')),
              );
            },
            child: const Text('Send email verification'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: checkEmailVerification,
            child: const Text('Check Verification Status'),
          ),
        ],
      ),
    );
  }
}