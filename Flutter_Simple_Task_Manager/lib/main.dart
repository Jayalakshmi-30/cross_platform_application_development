import 'package:crossplatform_crud_operations/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'uxVKhhFVvipSr0IRpicMfcfaYuPIj5zxG4O68nKQ';
  const keyClientKey = 'OumKnW70jfRGcDx4aatYupbcU3cZgMWBlWutU7iV';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
