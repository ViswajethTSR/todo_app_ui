import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_provider/todo_provider.dart';
import '../custom_designs/custom_app_bar.dart';

class TodoProviderPage extends StatefulWidget {
  @override
  _TodoProviderPageState createState() => _TodoProviderPageState();
}

class _TodoProviderPageState extends State<TodoProviderPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: Consumer<TodoProvider>(
        builder: (context, todoProvider, _) {
          return TodoList();
        },
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  void initState() {
    var todoProvider = Provider.of<TodoProvider>(context, listen: false);
    super.initState();
    todoProvider.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    var todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: buildAppBarForNormalPage('TaskTrak'),
      body: todoProvider.buildBody(),
      floatingActionButton: todoProvider.buildAddTaskButton(context),
      extendBody: true,
    );
  }
}
