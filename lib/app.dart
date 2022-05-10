import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/app_config.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/view_models/theme_view_model.dart';

import 'services/api_service.dart';
import 'view_models/home_view_model.dart';
import 'view_models/posts_view_model.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    final appConfig = AppConfig.of(context)!;
    final _apiService = ApiService(appConfig.apiUrl);

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeViewModel()),
          ChangeNotifierProvider(create: (context) => HomeViewModel()),
          ChangeNotifierProvider(create: (context) => PostsViewModel(_apiService)),
        ],
        child: Consumer<ThemeViewModel>(builder: (context, themeViewModel, _) {
          return MaterialApp(
            title: 'Water Tracker',
            theme: themeViewModel.getThemeData,
            initialRoute: splashScreenRoute,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              localizationDelegate
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: localizationDelegate.currentLocale,
            routes: applicationRoutes,
          );
        }),
      ),
    );
  }
}
