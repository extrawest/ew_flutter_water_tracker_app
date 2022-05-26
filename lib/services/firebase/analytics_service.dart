import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> addWaterEvent(int amount) async {
    await _analytics.logEvent(name: 'AddDrink', parameters: {'amount': amount});
  }

  Future<void> photoUpdatedEvent() async {
    await _analytics.logEvent(name: 'Changed photo');
  }

  Future<void> nameUpdatedEvent(String name) async {
    await _analytics.logEvent(name: 'Changed name', parameters: {'new name': name});
  }
}
