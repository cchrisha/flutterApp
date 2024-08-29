import 'dart:convert';
import 'package:crud_flutter/screens/editPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'createPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://fluttercrud-xl0f.onrender.com/api/getStudents'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _students = json.decode(response.body);
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteStudent(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://fluttercrud-xl0f.onrender.com/api/deleteStudent/$id'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _students.removeWhere((student) => student['_id'] == id);
        });
      } else {
        print('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void editStudent(Map<String, dynamic> student) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentScreen(students: student),
      ),
    );

    if (result ?? false) {
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    String id = student['_id'] ?? '';
                    String firstName = student['firstName'] ?? '';
                    String lastName = student['lastName'] ?? '';
                    String course = student['course'] ?? 'Unknown';
                    int year = student['year'] ?? 0;
                    bool enrolled = student['enrolled'] ?? false;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      elevation: 4.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          '$firstName $lastName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          'Course: $course\nYear: $year',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.0,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editStudent(student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteStudent(id),
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: enrolled ? Colors.green : Colors.red,
                          child: Icon(
                            enrolled ? Icons.check : Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
          Positioned(
            bottom: 20.0,
            right: 16.0,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (context) => CreatePage(),
                  ),
                )
                    .then((value) {
                  fetchData();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Student"),
            ),
          ),
        ],
      ),
    );
  }
}
