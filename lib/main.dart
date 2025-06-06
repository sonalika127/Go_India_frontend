import 'package:flutter/material.dart';

void main() {
  runApp(UserDetailsApp());
}

class UserDetailsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Details Form',
      home: UserDetailsPage(),
    );
  }
}

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedGender;

  void _saveDetails() {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      String name = _nameController.text;
      String gender = _selectedGender!;

      // Simulate saving to database or local storage
      print('Saved: Name: $name, Gender: $gender');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Details saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              SizedBox(height: 20),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: Text('Select Gender'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
              SizedBox(height: 30),
              // Save Button
              ElevatedButton(
                onPressed: _saveDetails,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
