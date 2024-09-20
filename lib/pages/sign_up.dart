import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedCountry = 'Bangladesh';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name*',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone no.*',
                        hintText: '+880',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    flex: 3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: '1710008927',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text =
                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Gender*',
                ),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: ['Bangladesh', 'Peru', 'USA', 'Other']
                    .map((country) => DropdownMenuItem(
                  value: country,
                  child: Text(country),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Country*',
                ),
              ),
              SizedBox(height: 16),
              // Campo de Dirección
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900], // Color del botón
                    minimumSize: Size(200, 50), // Tamaño del botón
                  ),
                  child: Text('Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}