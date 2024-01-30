import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rapidd_todos/viewmodels/vm_export.dart';
import 'package:rapidd_todos/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoList extends StatefulWidget {
  final String email;

  const TodoList({super.key, required this.email});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late SharedPreferences prefs;

  late bool? isLogin;

  // late String email;

  @override
  void initState() {
    showDiaFun();
    super.initState();
  }

  Future<void> showDiaFun() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool("isLogin");
    if (isLogin == null || isLogin == false) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    }
    // email = prefs.getString("email") ?? "";
    // print('e: $email');
  }

  @override
  Widget build(BuildContext context) {
    final todoController = Provider.of<TodoViewModel>(context);
    // print('from list: ${todoController.list}');
    final ref = FirebaseDatabase.instance.ref('todos');
    final refUser = FirebaseDatabase.instance.ref('users/${widget.email}');
    ref.keepSynced(true);
    late Query query, queryShared;
    query = ref.orderByChild('createdBy').equalTo(widget.email);
    queryShared = ref.orderByChild('id');

    return Scaffold(
      appBar: AppBar(
        title: const Text("TODOS"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoController.navigateToCreate();
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                sort: (a, b) {
                  DateTime dateTimeA =
                      DateTime.fromMillisecondsSinceEpoch(int.parse(a.key!));
                  DateTime dateTimeB =
                      DateTime.fromMillisecondsSinceEpoch(int.parse(b.key!));
                  return dateTimeB.compareTo(dateTimeA);
                },
                itemBuilder: (context, snapshot, animation, index) {
                  if(todoController.list.contains(snapshot.child('id').value.toString()) || snapshot.child('createdBy').value.toString() == widget.email){
                    return ListTile(
                      title: Text(snapshot.child('todo').value.toString()),
                      leading: Checkbox(
                        value: !(snapshot.child('isActive').value as bool),
                        // Provide a method to determine the active/inactive status
                        onChanged: (bool? value) {
                          // Handle checkbox state change
                          todoController.toggleTodoStatus(
                              snapshot, !(value as bool), ref);
                        },
                      ),
                      trailing: PopupMenuButton(
                          elevation: 4,
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(2))),
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  todoController.navigateToEdit(
                                      snapshot, ref);
                                },
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {

                                  Navigator.pop(context);

                                  ref
                                      .child(snapshot
                                      .child('id')
                                      .value
                                      .toString())
                                      .remove()
                                      .then((value) {})
                                      .onError((error, stackTrace) {});

                                  refUser
                                      .child(snapshot
                                      .child('id')
                                      .value
                                      .toString())
                                      .remove()
                                      .then((value) {})
                                      .onError((error, stackTrace) {});
                                },
                                leading: const Icon(Icons.delete_outline),
                                title: const Text('Delete'),
                              ),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: ListTile(
                                onTap: () async {
                                  todoController.navigateToShare(
                                      snapshot, ref);
                                  todoController.launchEmail(todoController.emailcon.text.toString(), snapshot.child('id').value.toString());
                                  Navigator.pop(context);

                                },
                                leading: const Icon(Icons.share),
                                title: const Text('Share'),
                              ),
                            ),
                          ]),
                    );
                  }
                  else{
                    return Container();
                  }
                }),
          ),
        ],
      ),
    );
  }
}

