import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;

  FirebaseRemoteConfig get getRemoteConfig => _firebaseRemoteConfig;

  Future<void> setupRemoteConfig() async {
    await _firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 12),
    ));
    await setDefaults();
    await _firebaseRemoteConfig.fetchAndActivate();
  }

  Future<void> setDefaults() async {
    await _firebaseRemoteConfig
        .setDefaults({'progress_indicator_type': 'circular'});
  }

  Future<void> forceFetch() async {
    await _firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _firebaseRemoteConfig.fetchAndActivate();
  }
}
