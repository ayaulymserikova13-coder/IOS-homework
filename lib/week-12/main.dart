import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/cart_bloc.dart';
import 'cubit/auth_cubit.dart';
import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const TechStoreApp());

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    // Above the Navigator: every route shares the same state owners.
    providers: [
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => CartBloc()),
    ],
    child: MaterialApp(
      title: 'TechStore',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LoginScreen(),
    ),
  );
}
