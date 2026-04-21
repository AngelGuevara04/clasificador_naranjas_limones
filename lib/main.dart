import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/classifier_view_model.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inyectamos el ViewModel para inicializar el patrón MVVM
        ChangeNotifierProvider(create: (_) => ClassifierViewModel()),
      ],
      child: MaterialApp(
        title: 'Clasificador Limones Naranjas',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}