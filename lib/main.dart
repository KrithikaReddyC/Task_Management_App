import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class Task {
  String name;
  bool isCompleted;
  bool isDeleted;
  String priority;

  Task({
    required this.name,
    this.isCompleted = false,
    this.isDeleted = false,
    this.priority = 'Low',
  });
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Low';
  bool _isGridView = true; // State variable for view mode

  void _addTask() {
    final taskName = _taskController.text;
    if (taskName.isNotEmpty) {
      setState(() {
        _tasks.add(Task(name: taskName, priority: _selectedPriority));
        _taskController.clear();
        _selectedPriority = 'Low';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added')),
      );
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks[index].isDeleted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task marked as deleted')),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.amber;
      case 'Low':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    _tasks.sort((a, b) {
      final priorityLevels = {'High': 3, 'Medium': 2, 'Low': 1};
      return priorityLevels[b.priority]!.compareTo(priorityLevels[a.priority]!);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Darker background for AppBar
        title: Text(
          'Task Manager',
          style: TextStyle(
            fontSize: 24, // Increase font size
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // White color for contrast
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0), // Slight shadow
                blurRadius: 2.0,
                color: Colors.black54, // Dark shadow color
              ),
            ],
          ),
        ),
        centerTitle: true, // Center the title
        elevation: 5, // Slight elevation for depth
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue[50]!,
              Colors.lightGreen[50]!
            ], // Softer gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TaskInput(
                taskController: _taskController,
                selectedPriority: _selectedPriority,
                onPriorityChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                onAddTask: _addTask,
                isGridView: _isGridView,
                onToggleView: (value) {
                  setState(() {
                    _isGridView = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: _isGridView
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7, // 7 cards per row
                          childAspectRatio: 1.0, // Square cards
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0,
                        ),
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return Opacity(
                            opacity: task.isDeleted ? 0.5 : 1.0,
                            child: Card(
                              color: _getPriorityColor(task.priority),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      task.name,
                                      style: TextStyle(
                                        color: task.isCompleted
                                            ? Colors.green[900]
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            10, // Smaller font size for better fit
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Checkbox(
                                          value: task.isCompleted,
                                          onChanged: task.isDeleted
                                              ? null
                                              : (bool? value) {
                                                  _toggleTaskCompletion(index);
                                                },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.white),
                                          onPressed: () => _deleteTask(index),
                                        ),
                                      ],
                                    ),
                                    if (task.isDeleted)
                                      Text('Deleted',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 8)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          final task = _tasks[index];
                          return Opacity(
                            opacity: task.isDeleted ? 0.5 : 1.0,
                            child: Card(
                              color: _getPriorityColor(task.priority),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      task.name,
                                      style: TextStyle(
                                        color: task.isCompleted
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      task.priority,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                leading: Checkbox(
                                  value: task.isCompleted,
                                  onChanged: task.isDeleted
                                      ? null
                                      : (bool? value) {
                                          _toggleTaskCompletion(index);
                                        },
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteTask(index),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskInput extends StatelessWidget {
  final TextEditingController taskController;
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;
  final VoidCallback onAddTask;
  final bool isGridView;
  final ValueChanged<bool> onToggleView;

  TaskInput({
    required this.taskController,
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.onAddTask,
    required this.isGridView,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: taskController,
            decoration: InputDecoration(
              labelText: 'Enter task name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) => onAddTask(),
          ),
        ),
        SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedPriority,
          items: <String>['Low', 'Medium', 'High'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) onPriorityChanged(newValue);
          },
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: onAddTask,
          child: Text('Add'),
        ),
        SizedBox(width: 10),
        Switch(
          value: isGridView,
          onChanged: onToggleView,
        ),
      ],
    );
  }
}
