import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/bloc/auth_bloc/auth_bloc.dart';
import 'package:water_tracker/bloc/dynamic_link_bloc/dynamic_link_barrel.dart';
import 'package:water_tracker/repository/firestore_repository.dart';
import 'package:water_tracker/repository/storage_repository.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/services/firebase/analytics_service.dart';
import 'package:water_tracker/services/firebase/cloud_messaging_service.dart';
import 'package:water_tracker/services/firebase/crashlytics_service.dart';
import 'package:water_tracker/services/firebase/dynamic_links_service.dart';
import 'package:water_tracker/services/firebase/firebase_authentication.dart';
import 'package:water_tracker/services/firebase/firestore.dart';
import 'package:water_tracker/services/firebase/remote_config_service.dart';
import 'package:water_tracker/services/firebase/storage_service.dart';
import 'package:water_tracker/view_models/theme_view_model.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late final AuthService _authService;
  late final AnalyticsService _analyticsService;
  late final CrashlyticsService _crashlyticsService;
  late final FirestoreDatabase _firestoreDatabase;
  late final CloudMessagingService _cloudMessagingService;
  late final FirestoreRepositoryImpl _firestoreRepository;
  late final StorageRepositoryImpl _storageRepository;

  @override
  void initState() {
    _authService = AuthService();
    _analyticsService = AnalyticsService();
    _crashlyticsService = CrashlyticsService()..listenAuthState(_authService);
    _firestoreDatabase = FirestoreDatabase();
    _cloudMessagingService = CloudMessagingService();
    _firestoreRepository = FirestoreRepositoryImpl(
        firestoreDatabase: _firestoreDatabase,
        cloudMessagingService: _cloudMessagingService,
        analyticsService: _analyticsService);
    _storageRepository = StorageRepositoryImpl(
        storageService: StorageService(), analyticsService: _analyticsService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ThemeViewModel()),
          BlocProvider<AuthBloc>(
              create: (context) => AuthBloc(
                  authService: _authService,
                  firestoreRepository: _firestoreRepository,
                  crashlyticsService: _crashlyticsService)),
          BlocProvider<DynamicLinkBloc>(
              create: (context) => DynamicLinkBloc(DynamicLinksService())),
          RepositoryProvider<FirestoreRepositoryImpl>(
            create: (context) => _firestoreRepository,
          ),
          RepositoryProvider<StorageRepositoryImpl>(
            create: (context) => _storageRepository,
          ),
          RepositoryProvider<CrashlyticsService>(
            create: (context) => _crashlyticsService,
          ),
          RepositoryProvider<RemoteConfigService>(
            create: (context) => RemoteConfigService(),
          ),
          RepositoryProvider<CloudMessagingService>(
            create: (context) => _cloudMessagingService,
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
