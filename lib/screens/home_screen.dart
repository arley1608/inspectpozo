import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    final name = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : 'Usuario';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // saludo centrado arriba
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Text(
                '👋 Bienvenido, $name',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            ),

            // contenido principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Image.asset(
                    'assets/logo_inspectpozo.png',
                    height: size.height * 0.22,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const FlutterLogo(size: 100),
                  ),
                  const SizedBox(height: 60),

                  // Botón primario (azul)
                  FilledButton.icon(
                    onPressed: () => context.push('/projects/new'),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Crear nuevo proyecto'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón secundario (outlined)
                  OutlinedButton.icon(
                    onPressed: () => context.push('/projects/active'),
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Proyectos activos'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // botón de cerrar sesión
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
