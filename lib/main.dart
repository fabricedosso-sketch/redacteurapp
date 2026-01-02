import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redacteurapp/firebase_options.dart';
import 'package:redacteurapp/pages/page_acceuil.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(
    child: MonApplication()
    ),
  );
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine Infos - Gestion des Rédacteurs', 
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const PageAcceuil(),
    );
  }
}
