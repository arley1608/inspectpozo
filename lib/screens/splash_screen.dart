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
    try {
      // pequeño delay para mostrar el logo
      await Future.delayed(const Duration(milliseconds: 900));
      // lee sesión actual ya con Firebase inicializado (por main.dart)
      final user = FirebaseAuth.instance.currentUser;

      if (!mounted) return;
      // usa microtask para evitar conflictos con el frame actual
      Future.microtask(() {
        if (!mounted) return;
        context.go(user == null ? '/' : '/home');
      });
    } catch (e) {
      // si algo raro pasa, manda al login sí o sí
      if (!mounted) return;
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/logo_inspectpozo.png',
            height: h * 0.28,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
          ),
        ),
      ),
    );
  }
}
