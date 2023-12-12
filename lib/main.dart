import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'models/doctor.dart';
import 'models/user_profile.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health and Fitness App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserProfileScreen(),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    userProfile = UserProfile(
      name: '',
      email: '',
      gender: '',
      dateOfBirth: null,
      height: 0.0,
      weight: 0.0,
      bloodGroup: '',
    );
    _loadUserProfile();
  }

  _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileString = prefs.getString('userProfile') ?? '{}';
    Map<String, dynamic> userProfileMap = json.decode(userProfileString);

    setState(() {
      userProfile = UserProfile.fromMap(userProfileMap);
    });
  }

  _saveUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', json.encode(userProfile.toMap()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.name = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.email = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.gender = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Gender'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.dateOfBirth = DateTime.tryParse(value);
                      });
                    },
                    decoration: InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.height = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Height'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.weight = double.tryParse(value) ?? 0.0;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Weight'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        userProfile.bloodGroup = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Blood Group'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _saveUserProfile();
                    },
                    child: Text('Create Profile'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorListScreen()),
                      );
                    },
                    child: Text('Select Doctors'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorListScreen extends StatelessWidget {
  List<Doctor> doctors = [
    Doctor(name: 'Dr. John Doe', specialty: 'Cardiologist', rating: 4.5),
    Doctor(name: 'Dr. Jane Smith', specialty: 'Orthopedic Surgeon', rating: 3.8),
    Doctor(name: 'Dr. Michael Brown', specialty: 'Dermatologist', rating: 4.2),
    Doctor(name: 'Dr. Emily White', specialty: 'Neurologist', rating: 4.7),
    Doctor(name: 'Dr. Christopher Lee', specialty: 'Pediatrician', rating: 3.5),
    Doctor(name: 'Dr. Sarah Johnson', specialty: 'Ophthalmologist', rating: 4.0),
    Doctor(name: 'Dr. David Miller', specialty: 'Gastroenterologist', rating: 4.9),
    Doctor(name: 'Dr. Jessica Davis', specialty: 'Endocrinologist', rating: 3.2),
    Doctor(name: 'Dr. Brian Wilson', specialty: 'Allergist', rating: 4.8),
    Doctor(name: 'Dr. Megan Taylor', specialty: 'Rheumatologist', rating: 3.9),
    // Add more doctors as needed
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    debugPrint(screenSize.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'List of Doctors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(doctors[index].name),
                      subtitle: Text(doctors[index].specialty),
                      trailing: RatingBar.builder(
                        initialRating: doctors[index].rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          // You can update the doctor's rating here if needed
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailsScreen(doctor: doctors[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailsScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: ${doctor.name}'),
            Text('Specialty: ${doctor.specialty}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentBookingScreen(doctor: doctor)),
                );
              },
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentBookingScreen extends StatelessWidget {
  final Doctor doctor;

  AppointmentBookingScreen({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You are booking an appointment with ${doctor.name}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Confirm Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
