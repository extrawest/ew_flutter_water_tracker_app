import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksService {
  final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  FirebaseDynamicLinks get dynamicLinkInstance => _dynamicLinks;

  Future<Uri> createDynamicLink(String sumOfMilliliters) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://watertrackerapp.page.link',
        link: Uri.parse(
            'https://watertrackerapp.page.link/?sumofmilliliters=$sumOfMilliliters'),
        androidParameters: const AndroidParameters(
            packageName: 'com.extrawest.water_tracker', minimumVersion: 1),
        iosParameters: const IOSParameters(
            bundleId: 'com.extrawest.waterTracker',
            minimumVersion: '1',
            appStoreId: '123456789'));
    final link = await _dynamicLinks.buildLink(parameters);
    return link;
  }
}
