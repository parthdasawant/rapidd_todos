import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/views/todo_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewmodels/todo_viewmodel.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Save email to SharedPreferences
                final String email = _emailController.text;
                todoController.userTodos();
                await saveEmail(email, todoController);
                Navigator.pop(context);
                // Navigate to home screen or do other actions
                // For simplicity, just showing a snackbar here
                // todoController.navigateToList();
                // Navigator.pushReplacement(_, MaterialPageRoute(builder: (context) => const TodoList()));

              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveEmail(String email, TodoViewModel todoController, ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email) ;
    todoController.emailLoginController.text = email;
    await prefs.setBool('isLogin', true);
  }
}