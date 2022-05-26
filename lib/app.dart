import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/repository/storage_repository.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/services/firebase/analytics_service.dart';
import 'package:water_tracker/services/firebase/firebase_authentication.dart';
import 'package:water_tracker/services/firebase/firestore.dart';
import 'package:water_tracker/services/firebase/storage_service.dart';
import 'package:water_tracker/view_models/theme_view_model.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    final _authService = AuthService();
    final _analyticsService = AnalyticsService();
    final _firestoreDatabase = FirestoreDatabase(_analyticsService);
    final _firestoreRepository = FirestoreRepositoryImpl(_firestoreDatabase);
    final _storageRepository =
        StorageRepositoryImpl(StorageService(_analyticsService));

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeViewModel()),
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                  authService: _authService,
                  firestoreRepository: _firestoreRepository)),
          Provider<FirestoreRepositoryImpl>(
            create: (context) => _firestoreRepository,
          ),
          Provider<StorageRepositoryImpl>(
            create: (context) => _storageRepository,
          ),
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
