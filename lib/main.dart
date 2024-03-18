import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'variable.dart';
import 'homepage.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loading(),
    ));

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> getData() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        joke = [data];
        print(joke[0]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Homepage()),
        );
      } else {
        throw Exception('Failed to load joke: ${response.statusCode}');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Message'),
            content: Text('No Internet Connection'),
            actions: [
              TextButton(
                onPressed: () {
                  getData();
                  Navigator.pop(context);
                },
                child: Text('Retry'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Joke4LL',
              style: GoogleFonts.luckiestGuy(
                fontSize: 70.0,
                color: Color.fromARGB(255, 204, 158, 8), // Outline color
                fontWeight: FontWeight.bold,
                shadows: [],
              ),
            ),
            Image.network(
              'https://images.emojiterra.com/google/noto-emoji/unicode-15/animated/1f639.gif',
              height: 200,
            ),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(
              color: Color.fromARGB(255, 204, 158, 8),
            )
          ],
        ),
      ),
    );
  }
}
