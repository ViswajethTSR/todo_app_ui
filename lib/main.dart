import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:viswa_todo_app/models/items.dart';

import 'package:viswa_todo_app/custom_designs/border.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoList(),
    );
  }
}

const api = 'http://64.227.166.14:3000';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];
  TextEditingController todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse('$api/get_todos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        todos = data.map((item) => Todo.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo() async {
    final response = await http.post(
      Uri.parse('$api/add_todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'title': todoController.text, 'completed': false}),
    );

    if (response.statusCode == 201) {
      fetchTodos();
      todoController.clear();
    } else {
      throw Exception('Failed to add todo');
    }
  }

  void _editTodoTitleDialog(BuildContext context, Todo todo) {
    TextEditingController editController = TextEditingController();
    editController.text = todo.title;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Todo'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: 'New Todo Title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                updateTodoTitle(todo.title, editController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateTodoTitle(String currentTitle, String newTitle) async {
    final response = await http.put(
      Uri.parse('$api/update_todo_title'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'currentTitle': currentTitle, 'newTitle': newTitle}),
    );

    if (response.statusCode == 200) {
      fetchTodos();
    } else {
      throw Exception('Failed to update todo title');
    }
  }

  Future<void> updateTodoState(String id, bool completed) async {
    final response = await http.put(
      Uri.parse('$api/update_todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'completed': completed}),
    );

    if (response.statusCode == 200) {
      fetchTodos();
    } else {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(String title) async {
    try {
      final response = await http.delete(Uri.parse('$api/delete_todos/$title'));

      if (response.statusCode == 200) {
        fetchTodos();
      } else {
        throw Exception('Failed to delete todo - ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting todo: $error');
    }
  }

  FloatingActionButton buildAddTaskButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Todo'),
              content: TextField(
                controller: todoController,
                decoration: InputDecoration(labelText: 'Todo'),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Add'),
                  onPressed: () {
                    addTodo();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        height: 900,
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ]),
                child: buildCards(todo),
              ),
            );
          },
        ),
      ),
    );
  }

  ListTile buildCards(Todo todo) {
    return ListTile(
      title: Text(todo.title),
      leading: Checkbox(
        value: todo.completed,
        onChanged: (bool? value) {
          updateTodoState(todo.title, value!);
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTodoTitleDialog(context, todo);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteTodo(todo.title);
            },
          ),
        ],
      ),
    );
  }

  PreferredSize buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80.0),
      child: AppBar(
        title: Text('Todo App'),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set your desired background color
        elevation: 0, // Remove the shadow below the app bar
        flexibleSpace: ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildAddTaskButton(context),
    );
  }
}
