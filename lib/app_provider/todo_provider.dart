// todo_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/items.dart';

const api = 'http://64.227.166.14:3000';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  TextEditingController _todoController = TextEditingController();

  List<Todo> get todos => _todos;
  TextEditingController get todoController => _todoController;

  Future<void> fetchTodos() async {
    final response = await http.get(Uri.parse('$api/get_todos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _todos = data.map((item) => Todo.fromJson(item)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load todos');
    }
    notifyListeners();
  }

  Future<void> addTodo() async {
    final response = await http.post(
      Uri.parse('$api/add_todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'title': _todoController.text, 'completed': false}),
    );

    if (response.statusCode == 201) {
      await fetchTodos();
      _todoController.clear();
    } else {
      throw Exception('Failed to add todo');
    }
    notifyListeners();
  }

  Future<void> _editTodoTitleDialog(BuildContext context, Todo todo) async {
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
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        height: 650,
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: buildCards(context, todo),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCards(BuildContext context, Todo todo) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: todo.completed ? Colors.grey : Colors.black87,
          decoration: todo.completed ? TextDecoration.lineThrough : null,
        ),
      ),
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
            icon: const Icon(
              Icons.edit,
              color: Colors.indigo,
            ),
            onPressed: () {
              _editTodoTitleDialog(context, todo);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteTodo(todo.title);
            },
          ),
        ],
      ),
    );
  }

  FloatingActionButton buildAddTaskButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 20,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Todo'),
              content: TextField(
                controller: _todoController,
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
}
