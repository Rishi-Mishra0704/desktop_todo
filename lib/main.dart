import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      final file = await getFile();
      if (file.existsSync()) {
        final data = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(data);
        final List<Todo> loadedTodos =
            jsonList.map((item) => Todo.fromJson(item)).toList();
        setState(() {
          todos = loadedTodos;
        });
      }
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  Future<void> saveTodos() async {
    try {
      final file = await getFile();
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonData = jsonEncode(jsonList);
      await file.writeAsString(jsonData);
    } catch (e) {
      print('Error saving todos: $e');
    }
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todos.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) {
                      setState(() {
                        todo.isDone = value!;
                        saveTodos();
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        todos.removeAt(index);
                        saveTodos();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Enter ToDo title',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _addTodo();
                  },
                  child: Text('Add ToDo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo() {
    final newTodo = Todo(title: controller.text);
    setState(() {
      todos.add(newTodo);
      controller.clear();
    });
    saveTodos();
  }
}