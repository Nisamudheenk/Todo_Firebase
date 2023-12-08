// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter_application_1/addtask.dart';
// // import 'package:flutter_application_1/group.dart';
// // import 'package:flutter_application_1/home.dart';
// // import 'package:google_sign_in/google_sign_in.dart'; // Import the group page file

// // class Task extends StatefulWidget {
// //   // final String username;
// //   const Task({Key? key}) : super(key: key);

// //   @override
// //   _TaskState createState() => _TaskState();
// // }

// // class _TaskState extends State<Task> {
// //   int _currentIndex = 0;
// //   List<String> tasks = [];
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Fetch data from Firestore when the widget is initialized
// //     fetchTasksFromFirestore();
// //   }

// //   Future<void> fetchTasksFromFirestore() async {
// //     try {
// //       // Replace 'tasks' with the actual name of your Firestore collection
// //       QuerySnapshot<Map<String, dynamic>> snapshot =
// //           await FirebaseFirestore.instance.collection('tasks').get();

// //       // Clear existing tasks
// //       setState(() {
// //         tasks.clear();
// //       });

// //       // Add tasks from Firestore to the list
// //       snapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
// //         String task = document.get('tasks');
// //         setState(() {
// //           tasks.add(task);
// //         });
// //       });
// //     } catch (error) {
// //       print('Error fetching data: $error');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {String? email = GoogleSignIn().currentUser?.email;
// // String displayUsername = email != null ? email.replaceAll('@gmail.com', '') : 'guest';

// // return Scaffold(
// //   appBar: AppBar(
// //     backgroundColor: Colors.black,
// //     title: Column(
// //       children: [
// //         Text('To Do app'),
// //         SizedBox(width: 8),
// //         Text(displayUsername),
// //           ],
// //         ),
// //         actions: [
// //           IconButton(
// //             icon: Icon(Icons.person),
// //             onPressed: () {
// //               GoogleSignIn().signOut();
// //               print(GoogleSignIn().currentUser?.displayName);
// //               // Handle profile icon tap
// //               Navigator.of(context)
// //                   .push(MaterialPageRoute(builder: (context) => MyHomePage()));
// //             },
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Text('Welcome to the Home Page!, $displayUsername!'),
// //             SizedBox(height: 15),
// //             Text('Tasks:'),
// //             Column(children: tasks.map((task) => Text(task)).toList())
// //           ],
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async {
// //           // Handle floating action button tap
// //           // ignore: unused_local_variable
// //           String? newTask = await Navigator.push(
// //               context, MaterialPageRoute(builder: (context) => addtask()));
// //           if (newTask != null) {
// //             // Add the new task to the list
// //             // tasks.add(newTask);
// //             addTaskToFirestore(newTask);
// //           }
// //         },
// //         child: Icon(Icons.add),
// //         backgroundColor: const Color.fromARGB(255, 0, 0, 0),
// //       ),
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _currentIndex,
// //         onTap: (index) {
// //           setState(() {
// //             _currentIndex = index;
// //             if (_currentIndex == 0) {
// //               // Navigate to the Group page
// //               Navigator.push(
// //                 context,
// //                 MaterialPageRoute(builder: (context) => group()),
// //               );
// //             } else if (_currentIndex == 1) {
// //               // Navigate to the Completed Task page
// //               // Add your navigation code here
// //             }
// //           });
// //         },
// //         items: [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.group),
// //             label: 'Group',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.check),
// //             label: 'Completed Task',
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Future<void> addTaskToFirestore(String newTask) async {
// //     try {
// //       // Replace 'tasks' with the actual name of your Firestore collection
// //       await FirebaseFirestore.instance.collection('tasks').doc('Name').set({
// //         'task': newTask,
// //       });

// //       // Update the local state to reflect the change
// //       await fetchTasksFromFirestore();
// //     } catch (error) {
// //       print('Error adding task to Firestore: $error');
// //     }
// //   }
// // }





import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/addtask.dart';
// ignore: unused_import
import 'package:flutter_application_1/profile.dart';

class Task extends StatefulWidget {
  const Task({Key? key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final TextEditingController _editTaskController = TextEditingController();

  Future<void> _showEditDialog(String taskId) async {
    _editTaskController.text = "";
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Task"),
              TextField(
                controller: _editTaskController,
                decoration: InputDecoration(
                  hintText: "Enter new task",
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(taskId)
                      .update({
                    'task': _editTaskController.text,
                  });
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text('TO DO'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchTaskDelegate());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    var task = snapshot.data!.docs[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(task['task']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Subdetails: ${task['subdetails']}'),
                            Text('Date: ${task['dateTime'].toDate()}'),
                            Text(
                                'Time: ${task['dateTime'].toDate().toLocal().toLocal()}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(task.id);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(task.id)
                                    .delete();
                                print('Delete: ${task['task']}');
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor:  Colors.blue,
      ),
    );
  }
}

class SearchTaskDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search Results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search Suggestions for: $query'),
    );
  }
}

