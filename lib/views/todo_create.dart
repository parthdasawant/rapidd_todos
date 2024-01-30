import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';

class TodoCreate extends StatefulWidget {
  const TodoCreate({super.key});

  @override
  State<TodoCreate> createState() => _TodoCreateState();
}

class _TodoCreateState extends State<TodoCreate> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO"),
      ),
      body: Form(
        key: formKey,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
              Container(
                width: 400,
                padding: const EdgeInsets.all(10),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  controller: todoController.titlecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Field';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "New Todo",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    todoController.createTodo(id);
                    todoController.createUser(id);
                    todoController.userTodos();
                  }
                },
                child: const Text(
                  "Create",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
