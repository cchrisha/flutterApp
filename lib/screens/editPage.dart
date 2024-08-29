import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditStudentScreen extends StatefulWidget {
  final Map<String, dynamic> students;

  const EditStudentScreen({required this.students});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late int _year;
  late String _course;
  late bool _enrolled;

  @override
  void initState() {
    super.initState();
    _firstName = widget.students['firstName'] ?? '';
    _lastName = widget.students['lastName'] ?? '';
    _year = widget.students['year'] ?? 1;
    _course = widget.students['course'] ?? '';
    _enrolled = widget.students['enrolled'] ?? false;
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<String, dynamic> updatedData = {
        'firstName': _firstName,
        'lastName': _lastName,
        'year': _year,
        'course': _course,
        'enrolled': _enrolled,
      };

      try {
        final response = await http.put(
          Uri.parse(
              'https://fluttercrud-xl0f.onrender.com/api/updateStudent/${widget.students['_id']}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(updatedData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student info updated successfully!')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update student.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _firstName,
                decoration: const InputDecoration(
                    labelText: 'First Name', border: OutlineInputBorder()),
                onSaved: (value) {
                  _firstName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _lastName,
                decoration: const InputDecoration(
                    labelText: 'Last Name', border: OutlineInputBorder()),
                onSaved: (value) {
                  _lastName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _year,
                decoration: const InputDecoration(
                    labelText: 'Select a year', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('First Year')),
                  DropdownMenuItem(value: 2, child: Text('Second Year')),
                  DropdownMenuItem(value: 3, child: Text('Third Year')),
                  DropdownMenuItem(value: 4, child: Text('Fourth Year')),
                  DropdownMenuItem(value: 5, child: Text('Fifth Year')),
                ],
                onChanged: (value) {
                  setState(() {
                    _year = value!;
                  });
                },
                onSaved: (value) {
                  _year = value!;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select the academic year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _course,
                decoration: const InputDecoration(
                    labelText: 'Course', border: OutlineInputBorder()),
                onSaved: (value) {
                  _course = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the course';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SwitchListTile(
                  title: const Text('Enrolled'),
                  value: _enrolled,
                  onChanged: (bool value) {
                    setState(() {
                      _enrolled = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStudent,
                child: const Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
