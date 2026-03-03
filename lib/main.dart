// ignore_for_file: depend_on_referenced_packages

import 'package:buynuk/core/app/app.dart';
import 'package:buynuk/core/app/providers.dart';
import 'package:buynuk/core/services/prefe_service.dart';
import 'package:buynuk/presentation/language/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PrefsService.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final languageProvider = LanguageProvider();
  await languageProvider.loadSavedLanguage();

  runApp(MultiProvider(providers: buildProviders(languageProvider), child: const App(isLoggedIn: false)));
}




 // akram@gmail.com



  // ElevatedButton(
  //    onPressed: () {
  //    //
  //           },
  //      child: Text('data'),
  // )



