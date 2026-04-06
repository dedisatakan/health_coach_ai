import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/services/hive_service.dart';
import 'core/services/remote_config_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.init();
  runApp(App(remoteConfigService: remoteConfigService));
}
