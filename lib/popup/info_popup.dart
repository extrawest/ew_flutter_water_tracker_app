import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:water_tracker/app_config.dart';
import 'package:water_tracker/utils/application_utils.dart';

import '../utils/logger.dart';

class InfoPopup extends StatefulWidget {
  const InfoPopup({Key? key}) : super(key: key);

  @override
  State<InfoPopup> createState() => _InfoPopupState();
}

class _InfoPopupState extends State<InfoPopup> {
  String? packageName;

  String? version;

  String? buildNumber;

  String? phoneModel;

  String? deviceUdId;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      final packageName = packageInfo.packageName;
      final version = packageInfo.version;
      final buildNumber = packageInfo.buildNumber;
      setState(() {
        this.packageName = packageName;
        this.version = version;
        this.buildNumber = buildNumber;
      });

      getDeviceUdId().then((String? udid) {
        setState(() {
          deviceUdId = udid;
        });
      });
    });

    try {
      // ignore: omit_local_variable_types
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        deviceInfo.androidInfo.then((AndroidDeviceInfo androidInfo) {
          setState(() {
            phoneModel = androidInfo.model;
          });
        });
      }
      if (Platform.isIOS) {
        deviceInfo.iosInfo.then((IosDeviceInfo iosInfo) {
          setState(() {
            phoneModel = iosInfo.utsname.machine;
          });
        });
      }
    } catch (e) {
      log.severe('platform error $e');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.of(context)!;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: <Widget>[
            _buildTile('Flavor: ', config.flavorName),
            _buildTile('Phone Model: ', '$phoneModel'),
            _buildTile('App name: ', config.appName),
            _buildTile('API URLs: ', config.apiUrl),
            _buildTile('PackageName: ', packageName),
            _buildTile('Version: ', version),
            _buildTile('BuildNumber: ', buildNumber),
            _buildTile('Device Unique ID: ', deviceUdId),
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                      text: buildLine('Phone Model', phoneModel) +
                          buildLine('Flavor', config.flavorName) +
                          buildLine('App name', config.appName) +
                          buildLine('API URL', config.apiUrl) +
                          buildLine('PackageName', packageName) +
                          buildLine('Version', version) +
                          buildLine('BuildNumber', buildNumber)),
                );
              },
              child: const Text('Copy to clipboard'),
            ),
          ],
        ),
      ),
    );
  }

  static String buildLine(String key, String? value) {
    return '$key: $value\n';
  }

  Widget _buildTile(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
              child: Text(
                value ?? 'this value is null',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ))
        ],
      ),
    );
  }
}
