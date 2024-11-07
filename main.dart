// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Routes/routeNames.dart';
// import 'package:flutter_application_1/Routes/routes.dart';
// import 'package:flutter_application_1/views/welcomeScreen.dart';
// import 'package:flutter_application_1/views/splashScreen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // home: Splashscreen(),
//       initialRoute: routeName.splashScreen,
//       onGenerateRoute: Routes.generateRoute,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth_Screens/loginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginScreen(),
    );
  }
}

class TripList extends StatefulWidget {
  @override
  _TripListState createState() => _TripListState();
}

class _TripListState extends State<TripList> {
  List<Trip> trips = [];

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    final response = await http.get(Uri.parse('http://localhost:3000/trips'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      setState(() {
        trips = data.map((trip) => Trip.fromJson(trip)).toList();
      });
    } else {
      // Handle API errors
      print('Error fetching trips: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Planner'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return ListTile(
            title: Text(trip.title),
            leading: Image.network(trip.imageUrl),
            onTap: () {
              // Navigate to a detail screen for this trip
            },
          );
        },
      ),
    );
  }
}
