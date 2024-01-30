import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';

class TodoAccept extends StatefulWidget {
  final String id;
  const TodoAccept({super.key, required this.id,});

  @override
  State<TodoAccept> createState() => _TodoAcceptState();
}


class _TodoAcceptState extends State<TodoAccept> {



  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);
    final ref = FirebaseDatabase.instance.ref('todos');
    final query =  ref.orderByChild('id').equalTo(widget.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text("ACCEPT TODO"),
      ),
      body: FirebaseAnimatedList(
        query: query,
        itemBuilder: (context, snapshot, animation, index) {
          return SizedBox(
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
                    initialValue: snapshot.child('todo').value.toString(),
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

                      todoController.acceptTodo(widget.id);

                  },
                  child: const Text(
                    "Accept",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}