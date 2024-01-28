import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';

class TodoAccept extends StatefulWidget {
  final id;
  const TodoAccept({super.key, required this.id,});

  @override
  State<TodoAccept> createState() => _TodoAcceptState();
}

class _TodoAcceptState extends State<TodoAccept> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);
    final ref = FirebaseDatabase.instance.ref('todos');
    return Scaffold(
      appBar: AppBar(
        title: const Text("ACCEPT TODO"),
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
                decoration: BoxDecoration(
                  // color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  initialValue: ref.child(widget.id).child('todo').toString(),
                  // style: const TextStyle(color: Colors.red),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Title",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    todoController.acceptTodo(widget.id, ref );
                  }
                },
                child: const Text(
                  "Accept",
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