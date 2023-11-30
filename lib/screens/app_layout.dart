import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';

class AppLayout extends StatelessWidget {
  final Widget child;

  AppLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: Header(), // Use the Header component as the AppBar
      body: Column(
        children: [
          Expanded(child: child), // Place the child widget inside an Expanded widget
          //Footer(), // Use the Footer component as the bottom navigation bar
        ],
      ),
    );
  }
}
