import 'dart:convert';

Map<String, Todos> todosFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Todos>(k, Todos.fromJson(v)));

String todosToJson(Map<String, Todos> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

class Todos {
  String createdBy;
  String id;
  bool isActive;
  String todo;
  String updatedBy;
  String updatedOn;

  Todos({
    required this.createdBy,
    required this.id,
    required this.isActive,
    required this.todo,
    required this.updatedBy,
    required this.updatedOn,
  });

  factory Todos.fromJson(Map<String, dynamic> json) => Todos(
    createdBy: json["createdBy"],
    id: json["id"],
    isActive: json["isActive"],
    todo: json["todo"],
    updatedBy: json["updatedBy"],
    updatedOn: json["updatedOn"],
  );

  Map<String, dynamic> toJson() => {
    "createdBy": createdBy,
    "id": id,
    "isActive": isActive,
    "todo": todo,
    "updatedBy": updatedBy,
    "updatedOn": updatedOn,
  };
}
