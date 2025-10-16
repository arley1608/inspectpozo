import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    context.go(user == null ? '/' : '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/logo.png',
            height: MediaQuery.of(context).size.height * 0.28,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
          ),
        ),
      ),
    );
  }
}
