import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_store/pet_form_page.dart';
import 'package:pet_store/pet.dart';
import 'package:pet_store/pet_list_page.dart';
import 'package:pet_store/pet_shop_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final home = kIsWeb ? const PetsListPage() : const PetShopPage();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Petstore',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => home,
      },
    );
  }
}
