import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/bloc/product_list/product_list_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/pages/product_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

///take input of flavour
Future<void> startApp({required String flavor}) async {
  // runApp(MyApp(flavor: flavor));
}

class MyApp extends StatelessWidget {
  // final String flavor;
  // MyApp({super.key,required this.flavor});
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ProductRepositoryImpl(FirebaseFirestore.instance),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductListBloc(
              context.read<ProductRepositoryImpl>(),
            ),
          ),
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Product Listing App',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: (state as ThemeInitial).isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const ProductListPage(),
            );
          },
        ),
      ),
    );
  }
} 