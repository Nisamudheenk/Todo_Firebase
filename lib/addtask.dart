// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class addtask extends StatefulWidget {
//   const addtask({Key? key}) : super(key: key);

//   @override
//   _AddTaskState createState() => _AddTaskState();
// }

// class _AddTaskState extends State<addtask> {
//   TextEditingController _newTaskController = TextEditingController();
//   TextEditingController _subTaskController = TextEditingController();

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//    User? auth = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text('Add Task'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _newTaskController,
//               decoration: InputDecoration(labelText: 'New Task'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _subTaskController,
//               decoration: InputDecoration(labelText: 'Sub Task'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle submit button tap
//                 String newTask = _newTaskController.text;
//                 String subTask = _subTaskController.text;
//                 _saveToFirestore(newTask, subTask);

//                 // Process the new task and subtask as needed
//                 print('New Task: $newTask, Sub Task: $subTask');
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _saveToFirestore(String newTask, String subTask) async {
//     // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//     try {
//       User? auth = FirebaseAuth.instance.currentUser;
//       if (auth?.email != null) {
//         print(auth?.displayName);
//         await _firestore.collection('tasks').doc(auth?.uid).set({
//           'newTask': newTask,
//           'subTask': subTask,
//         });

//         print('Task data saved to Firestore');
//       } else {
//         print('user is null,canot save task data to firestore');
//       }
//     } catch (e) {
//       print('Error saving task data to Firestore: $e');
//     }
//   }
// }


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddTaskPage(),
    );
  }
}

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subDetailsController = TextEditingController();

  Future<void> _selectDate() async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (_selectedDate != null) {
      print("Selected Date: $_selectedDate");
    }
  }

  Future<void> _selectTime() async {
    _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_selectedTime != null) {
      print("Selected Time: $_selectedTime");
    }
  }

  Future<void> _addTask() async {
    try {
      if (_selectedDate != null &&
          _selectedTime != null &&
          _taskController.text.isNotEmpty &&
          _subDetailsController.text.isNotEmpty) {
        DateTime dateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
          
        );

        CollectionReference tasks =
            FirebaseFirestore.instance.collection('users');

        await tasks.add({
          'task': _taskController.text,
          'subdetails': _subDetailsController.text,
          'dateTime': dateTime,
        });

        print("Task added to Firestore: ${_taskController.text}");
        print("Subtask added to Firestore: ${_subDetailsController.text}");
        print("Date and Time added to Firestore: $dateTime");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Task()),
        );
      } else {
        print('Check Date, Time, and Task Details');
      }
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('ADD TASK', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _taskController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TASK',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _subDetailsController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'SUB DETAILS',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _selectDate,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text('DATE'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selectTime,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>( Colors.blue),
                  ),
                  child: Text('TIME'),
                ),
              ],
            ),
            SizedBox(height: 40),
            SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                onPressed: _addTask,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}