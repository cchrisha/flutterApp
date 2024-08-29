import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _course = '';
  int _year = 1;
  bool _enrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'First Name', border: OutlineInputBorder()),
                onSaved: (value) {
                  _firstName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Last Name', border: OutlineInputBorder()),
                onSaved: (value) {
                  _lastName = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              DropdownButtonFormField<int>(
                value: null,
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
                    return 'Please select your academic year';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Course', border: OutlineInputBorder()),
                onSaved: (value) {
                  _course = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your course';
                  }
                  return null;
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
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
              const Padding(padding: EdgeInsets.only(top: 20)),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Prepare the data
                    final Map<String, dynamic> formData = {
                      'firstName': _firstName,
                      'lastName': _lastName,
                      'course': _course,
                      'year': _year,
                      'enrolled': _enrolled,
                    };

                    try {
                      final response = await http.post(
                        Uri.parse(
                            'https://fluttercrud-xl0f.onrender.com/api/createStudents'),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode(formData),
                      );

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        print('Form submitted successfully');
                        print('Response: ${response.body}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Student info created successfully!')),
                        );
                        Navigator.pop(context, true);
                      } else {
                        print('Failed to submit form');
                        print('Status Code: ${response.statusCode}');
                        print('Response: ${response.body}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to create student.')),
                        );
                      }
                    } catch (e) {
                      print('Error submitting form: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'An error occurred while submitting the form.'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
