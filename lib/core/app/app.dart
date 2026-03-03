// ignore_for_file: depend_on_referenced_packages

import 'package:buynuk/core/routes/app_routes.dart';
import 'package:buynuk/core/services/navigation_service.dart';
import 'package:buynuk/presentation/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  const App({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.splash,
          locale: provider.locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
