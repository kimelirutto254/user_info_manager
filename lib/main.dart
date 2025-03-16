import 'package:flutter/material.dart';
import 'package:frontend_interview/providers/user_provider.dart';
import 'package:frontend_interview/screens.dart/splash_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: Observer(
        builder:
            (_) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title:
                  '${'Frontend Interview'}${!isMobile ? ' ${platformName()}' : ''}',
              home: SplashScreen(),
              navigatorKey: navigatorKey,
              scrollBehavior: SBehavior(),
              supportedLocales: [const Locale('en', 'US')],
              localeResolutionCallback: (locale, supportedLocales) => locale,
            ),
      ),
    );
  }
}
