import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';

class TodoEdit extends StatefulWidget {
  final snapshot;
  final ref;
  final id;
  const TodoEdit({super.key, required this.snapshot, required this.id,required this.ref});

  @override
  State<TodoEdit> createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoEdit> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("EDIT"),
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
                  controller: todoController.titlecontroller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required Field';
                    }
                    return null;
                  },
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
                    todoController.editTodo( widget.id, todoController.titlecontroller.text, widget.ref, widget.snapshot );
                  }
                },
                child: const Text(
                  "Save",
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