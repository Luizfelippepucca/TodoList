import 'package:flutter/material.dart';
import 'package:todolist/empty_state.dart';
import 'card.dart';
import 'tarefa_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String task = "";
  List<Tarefa> tasks = [];

  final TextEditingController _controllerField = TextEditingController();

  void addTask() {
    final newTask = Tarefa(task, 0);

    setState(() {
      tasks.add(newTask);

      task = '';
    });
    _controllerField.clear();
  }

  void handleReorder(int oldIndex, int newIndex) {
    final clone = [...tasks];
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }
      final item = clone.removeAt(oldIndex);

      clone.insert(newIndex, item);
      tasks = clone;
    });
  }

  void removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color oddItemColor = Colors.purple.shade800;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade900,
          centerTitle: true,
          title: const Text('Lista de tarefas'),
        ),
        body: Container(
          color: Colors.purple.shade900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _controllerField,
                        maxLines: 1,
                        maxLength: 30,
                        onChanged: (value) => {task = value},
                        keyboardAppearance: Brightness.light,
                        decoration: InputDecoration(
                          counterStyle: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 8),
                          hintText: 'Digite sua tarefa',
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2.0,
                              color: Colors.purple.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shadowColor: Colors.purple,
                              minimumSize: const Size(120, 45),
                              backgroundColor: Colors.purple),
                          onPressed: () => addTask(),
                          child: Text(
                            'Adicionar'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              tasks.isEmpty
                  ? const EmptyState()
                  : Expanded(
                      child: ReorderableListView.builder(
                          itemBuilder: (context, index) {
                            final item = tasks[index];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              key: ValueKey(index),
                              title: MyCard(
                                description: item.task,
                                id: item.idTask,
                                remove: () => removeTask(index),
                              ),
                              tileColor: oddItemColor,
                            );
                          },
                          itemCount: tasks.length,
                          onReorder: (oldIndex, newIndex) =>
                              handleReorder(oldIndex, newIndex)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
