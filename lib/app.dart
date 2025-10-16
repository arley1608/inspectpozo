import 'package:flutter/material.dart';
import 'routes/app_router.dart';

class InspectPozoApp extends StatelessWidget {
  const InspectPozoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        fontFamily: 'Roboto',
      ),
    );
  }
}
