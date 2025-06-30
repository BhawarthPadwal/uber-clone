import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_uber_clone_app/app.dart';
import 'package:flutter_uber_clone_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_uber_clone_app/features/home/bloc/home_bloc.dart';
import 'package:flutter_uber_clone_app/storage/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await LocalStorageService.init();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => HomeBloc()),
      ],
      child: const App()));
}
