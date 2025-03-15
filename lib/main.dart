import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/di/environments.dart';
import 'core/modules/pinapp_module.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
