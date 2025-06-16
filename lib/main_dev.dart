// lib/main_dev.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await startApp(flavor: 'development');
}
