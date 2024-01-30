import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';

class TodoShare extends StatefulWidget {
  final DataSnapshot snapshot;
  final DatabaseReference ref;
  final String  id;
  const TodoShare({super.key, required this.snapshot, required this.id,required this.ref});

  @override
  State<TodoShare> createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoShare> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Todo"),
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
                  controller: todoController.emailcon,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Field';
                    }
                    return null;
                  },
                  // style: const TextStyle(color: Colors.red),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // todoController.updateTodo(widget.id, widget.snapshot, widget.ref, todoController.emailcon.text.toString());
                    todoController.launchEmail(todoController.emailLoginController.text.toString(), widget.snapshot.child('id').value.toString(), ).then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    });
                  }
                },
                child: const Text(
                  "Send",
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