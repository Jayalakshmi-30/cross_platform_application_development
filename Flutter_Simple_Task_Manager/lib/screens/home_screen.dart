import 'package:crossplatform_crud_operations/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:intl/intl.dart'; // Import for date formatting

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'uxVKhhFVvipSr0IRpicMfcfaYuPIj5zxG4O68nKQ';
  const keyClientKey = 'OumKnW70jfRGcDx4aatYupbcU3cZgMWBlWutU7iV';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(const MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todoController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime? _selectedDate; // New DateTime variable for date selection

  ParseObject? _selectedTask;

  void addToDo() async {
    if (todoController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Empty fields"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a date"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    await saveTodo(
        todoController.text, descriptionController.text, _selectedDate!);
    setState(() {
      todoController.clear();
      descriptionController.clear();
      _selectedDate = null;
    });
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement( // Navigate to the login screen
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _editTask(ParseObject task) {
    setState(() {
      _selectedTask = task;
      todoController.text = task.get<String>('title') ?? '';
      descriptionController.text = task.get<String>('description') ?? '';
      _selectedDate = task.get<DateTime>('date'); // Fetch date from selected task
    });
  }

  void _clearSelectedTask() {
    setState(() {
      _selectedTask = null;
      todoController.clear();
      descriptionController.clear();
      _selectedDate = null; // Clear selected date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Task Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _confirmLogout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 1.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(children: [
                TextField(
                  controller: todoController,
                  decoration: InputDecoration(
                      hintText: "Task Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(width: 3.0))),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                      hintText: "Task Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(width: 3.0))),
                ),
                const SizedBox(
                  height: 16,
                ),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          // Button to select date
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(
              _selectedDate != null
                  ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!.toLocal())}'
                  : 'Select Date',
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueAccent,
            ),
            onPressed: _selectedTask != null ? _updateTask : addToDo,
            child: Text(_selectedTask != null ? "UPDATE" : "ADD"),
          ),
          Expanded(
            child: FutureBuilder<List<ParseObject>>(
              future: getTodo(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error..."),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("No Data..."),
                      );
                    } else {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 10.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final varTodo = snapshot.data![index];
                          final varTitle = varTodo.get<String>('title')!;
                          final varDescription =
                          varTodo.get<String>('description')!;
                          final varDone = varTodo.get<bool>('done')!;
                          final varDate = varTodo.get<DateTime>('date') ??
                              DateTime.now(); // Fetch date from ParseObject

                          return ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(varTitle),
                                Text(
                                  varDescription,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Date: ${DateFormat('yyyy-MM-dd').format(varDate.toLocal())}', // Format date for display
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                              varDone ? Colors.green : Colors.blue,
                              foregroundColor: Colors.white,
                              child: Icon(varDone ? Icons.check : Icons.error),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    _editTask(varTodo);
                                  },
                                ),
                                Checkbox(
                                  value: varDone,
                                  onChanged: (value) async {
                                    await updateTodo(
                                        varTodo.objectId!, value!);
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await deleteTodo(varTodo.objectId!);
                                    setState(() {
                                      const snackBar = SnackBar(
                                        content: Text("Task deleted!"),
                                        duration: Duration(seconds: 2),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    });
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveTodo(
      String title, String description, DateTime date) async {
    final todo = ParseObject('crud')
      ..set('title', title)
      ..set('description', description)
      ..set('done', false)
      ..set('date', date); // Save selected date
    await todo.save();
  }

  Future<List<ParseObject>> getTodo() async {
    QueryBuilder<ParseObject> queryTodo =
    QueryBuilder<ParseObject>(ParseObject('crud'));
    final ParseResponse apiResponse = await queryTodo.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<void> updateTodo(String id, bool done) async {
    var todo = ParseObject('crud')
      ..objectId = id
      ..set('done', done);
    await todo.save();
  }

  Future<void> deleteTodo(String id) async {
    var todo = ParseObject('crud')..objectId = id;
    await todo.delete();
  }

  Future<void> _updateTask() async {
    if (_selectedTask != null) {
      final title = todoController.text.trim();
      final description = descriptionController.text.trim();
      if (title.isNotEmpty && description.isNotEmpty) {
        _selectedTask!.set<String>('title', title);
        _selectedTask!.set<String>('description', description);
        _selectedTask!.set<DateTime>('date', _selectedDate!); // Update selected date
        await _selectedTask!.save();
        _clearSelectedTask();
      }
    }
  }
}
