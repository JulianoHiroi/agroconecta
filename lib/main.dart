import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/router/router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => PageNotifier(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: AppRouteInformationParser(),
      routerDelegate: AppRouterDelegate(
        notifier: Provider.of<PageNotifier>(context),
      ),
      title: 'Navigator 2.0',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
