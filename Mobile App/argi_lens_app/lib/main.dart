import 'package:agre_lens_app/modules/splash/splash_screen.dart';
import 'package:agre_lens_app/shared/bloc_observer.dart';
import 'package:agre_lens_app/shared/cubit/cubit.dart';
import 'package:agre_lens_app/shared/network/remote/dio_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';



void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoic3RyaW5nMSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiYWI1ZTdlZTYtNWEzZC00NmIxLWE1OGUtNWEyNWEwYzdkZDM0IiwianRpIjoiNzVjNmI4OTUtNWY3YS00MzM5LTgxNDEtNDczOTBhMmQyMTM3IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiRmFybWVyIiwiZXhwIjoxNzgzMjg0Njg4LCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MTIyIiwiYXVkIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NzEyMiJ9.axmaTevNQEbE2ELByxXeGg-bDdFSCjJ5CI0EdT9VM6U');
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(
    BlocProvider(
      create: (context) => AppCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFEF7FF)
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
