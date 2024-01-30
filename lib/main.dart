import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/utils/utils_export.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';
import 'package:rapidd_todos/views/todo_accept.dart';
import 'package:rapidd_todos/views/views_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? temp = prefs.getString("email");
  late String email;
  if (temp != null) {
    email = encodeEmail(temp);
  } else {
    email = '';
  }
  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  final String email;

  const MyApp({super.key, required this.email});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoViewModel>(
            create: (_) => TodoViewModel(NavigationService.instance))
      ],
      child: MaterialApp.router(
        title: 'Rapidd Todos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          routes: [
            GoRoute(
                path: '/',
                builder: (context, state) => TodoList(email: email),
                routes: [
                  GoRoute(
                      path: 'accept/:id',
                      builder: (context, state) => TodoAccept(id: state.pathParameters['id'].toString())
                  )]),
          ],
          navigatorKey: NavigationService.instance.navigationKey,
        ),
      ),
    );
  }
}

String encodeEmail(String email) {
  return base64Url.encode(utf8.encode(email));
}
