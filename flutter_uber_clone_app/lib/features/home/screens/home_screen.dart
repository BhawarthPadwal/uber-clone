import 'package:flutter/material.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: InkWell(
        onTap: () {
          LocalStorageService.clearToken();
        },
        child: Text("Home Screen"))));
  }
}
