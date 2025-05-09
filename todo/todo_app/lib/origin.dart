import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ToDoScreen());
    // TODO: implement build
  }
}

//Tạo màn hình chính của Todo Screen
class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Học Dart', 'completed': true},
    {'title': 'Học Flutter', 'completed': false},
  ];

  final TextEditingController _taskController = TextEditingController();

  void _addTask(String task) {
    setState(() {
      _tasks.add({'title': task, 'completed': false});
    });
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thêm công việc"),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: "Nhập tên công việc"),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Huỷ"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  _addTask(_taskController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Thêm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To-Do App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green[100],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: Checkbox(
                  value: _tasks[index]['completed'],
                  onChanged: (_) => _toggleTask(index),
                  activeColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(
                  _tasks[index]['title'],
                  style: TextStyle(
                    decoration:
                        _tasks[index]['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                    fontWeight:
                        _tasks[index]['completed']
                            ? FontWeight.normal
                            : FontWeight.bold,
                    color:
                        _tasks[index]['completed']
                            ? Colors.grey[600]
                            : Colors.black87,
                  ),
                ),

                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeTask(index),
                ),
              ),
            ),
          );

          return ListTile(
            leading: Checkbox(
              value: _tasks[index]['completed'],
              onChanged: (_) => _toggleTask(index),
              activeColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            title: Text(
              _tasks[index]['title'],
              style: TextStyle(
                decoration:
                    _tasks[index]['completed']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                fontWeight:
                    _tasks[index]['completed']
                        ? FontWeight.normal
                        : FontWeight.bold,
                color:
                    _tasks[index]['completed']
                        ? Colors.grey[600]
                        : Colors.black87,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeTask(index),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
