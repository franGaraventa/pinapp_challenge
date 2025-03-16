import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/di/environments.dart';
import 'core/di/shared_preferences_manager.dart';
import 'core/modules/pinapp_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.initialize();
  runApp(
    ModularApp(
      module: PinAppModule(environment: Environment.latest),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
          useMaterial3: true,
        ),
        routerConfig: Modular.routerConfig,
      ),
    ),
  );
}
