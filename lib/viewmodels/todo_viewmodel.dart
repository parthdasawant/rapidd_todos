import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rapidd_todos/utils/utils_export.dart';
import 'package:rapidd_todos/views/views_export.dart';
import 'package:rapidd_todos/models/model_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/login.dart';
import '../views/todo_accept.dart';
import '../views/todo_share.dart';

class TodoViewModel extends ChangeNotifier {
  final NavigationService _navigationService;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController emailcon = TextEditingController();
  TextEditingController emailLoginController = TextEditingController();
  List<Todos> allTodos = [];
  List<String> list = [];
  late String _email; // Change to nullable type

  String get email => _email; // Getter

  set email(String value) => _email = value; // Setter

  TodoViewModel(this._navigationService) {
    getAllTodos();
    userTodos();
  }

  navigateToCreate() {
    _navigationService.navigate(const TodoCreate());
  }

  navigateToLogin() {
    _navigationService.navigateAsHome(const Login());
  }

  navigateToEdit(DataSnapshot snapshot, DatabaseReference ref) {
    titlecontroller.text = snapshot.child('todo').value.toString();

    _navigationService.navigate(TodoEdit(
        snapshot: snapshot,
        id: snapshot.child('id').value.toString(),
        ref: ref));
  }

  navigateToShare(DataSnapshot snapshot, DatabaseReference ref) {
    titlecontroller.text = snapshot.child('todo').value.toString();

    _navigationService.navigate(TodoShare(
        snapshot: snapshot,
        id: snapshot.child('id').value.toString(),
        ref: ref));
  }

  navigateToAccept(String id) {
    _navigationService.navigate(TodoAccept(id: id));
  }

  getAllTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLogin = prefs.getBool("isLogin");
    if (isLogin != null || isLogin == true) {
      String? temp = prefs.getString("email");
      if (temp != null) {
        email = temp;
      }
    } else {
      email = 'email';
    }

    userTodos();
    notifyListeners();
  }

  createUser(String id) async {
    final pref = await SharedPreferences.getInstance();
    final email = pref.getString('email') ;
    if(email != null){
      String email64 = encodeEmail(email);
      final ref2 = FirebaseDatabase.instance.ref('users/$email64');
      ref2.child(id).set(id).then((value) async {
        userTodos();
      }).onError((error, stackTrace) {
        print("Fail $error");
      });
    }

  }
  String encodeEmail(String email) {
    return base64Url.encode(utf8.encode(email));
  }

  createTodo(String id) async {
    final ref = FirebaseDatabase.instance.ref('todos');
    _navigationService.showLoader();
    final pref = await SharedPreferences.getInstance();
    final email = pref.getString('email');
    if(email != null){
      String email64 = encodeEmail(email);
    ref.child(id).set({
      'id': id,
      'todo': titlecontroller.text.toString(),
      'createdBy': email64,
      'updatedBy': email64,
      'updatedOn': DateTime.now().millisecondsSinceEpoch.toString(),
      'isActive': true
    }).then((value) async {
      _navigationService.goBack();
      _navigationService.goBack();
      userTodos();
      titlecontroller.clear();
    }).onError((error, stackTrace) {
      print("Fail $error");
    });}
  }

  editTodo(id, todo, ref, snapshot) async {
    _navigationService.showLoader();
    try {
      await ref.child(id).update({'todo': todo});
      userTodos();
      _navigationService.goBack();
      _navigationService.goBack();
      titlecontroller.clear();
      notifyListeners();
    } catch (error) {
      print("Error occurred during todo update: $error");
    }
  }


  acceptTodo(id) async {
    createUser(id);
    userTodos();
    _navigationService.goBack();
  }


  Future<void> launchEmail(String email, String id) async {
    final String emailSubject = "Todo from $email";
    final String emailBody = "https://parthdasawant.tech/accept/$id";
    final String encodedSubject = Uri.encodeComponent(emailSubject);
    final String encodedBody = Uri.encodeComponent('''
    This is the body of the email with a $emailBody 
    ''');
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      queryParameters: {'subject': encodedSubject, 'body': encodedBody},
    );
    try {
      await launchUrl(
          (Uri.parse(Uri.decodeComponent(emailLaunchUri.toString()))),
          mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not launch email';
    }
  }

  void toggleTodoStatus(
      DataSnapshot snapshot, bool newValue, DatabaseReference ref) {
    DatabaseReference todoRef = ref.child(snapshot.key.toString());
    todoRef.update({'isActive': newValue}).then((_) {
      notifyListeners();
    }).catchError((error) {
      print("Error toggling todo status: $error");
    });
  }

  void userTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? temp = prefs.getString("email");
    late String email;
    if (temp != null) {
      email = encodeEmail(temp);
    } else {
      email = '';
    }
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users').get();

    if (snapshot.exists) {
      List<String> tempList = extractKeysFromMapString(snapshot.child(email).value.toString());
      print('list : $tempList');
      list = tempList;
      notifyListeners();
    } else {
      list = [];
      notifyListeners();
    }

  }

  List<String> extractKeysFromMapString(String mapString) {
    List<String> keys = [];
    RegExp regex = RegExp(r'(\d+)(?=:)');
    Iterable<Match> matches = regex.allMatches(mapString);
    for (Match match in matches) {
      keys.add(match.group(1).toString());
    }
    return keys;
  }

}
