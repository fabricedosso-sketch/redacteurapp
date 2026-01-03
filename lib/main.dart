import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redacteurapp/firebase_options.dart';
import 'package:redacteurapp/pages/page_acceuil.dart';

/// Point d'entrée de l'application.
/// 
/// Configuration Firebase et initialisation du state management Riverpod
/// avant le démarrage de l'application Flutter.
Future<void> main() async {
  // Initialise les bindings Flutter avant toute opération asynchrone
  // Requis pour utiliser des plugins natifs (Firebase) avant runApp()
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialise Firebase avec la configuration générée par FlutterFire CLI
  // Les options sont spécifiques à la plateforme (Android, iOS, Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  // Lance l'application avec Riverpod
  // ProviderScope est le conteneur racine qui permet à tous les widgets
  // enfants d'accéder aux providers
  runApp(const ProviderScope(
    child: MonApplication()
    ),
  );
}

/// Widget racine de l'application.
/// 
/// Configure le MaterialApp avec le thème et la page d'accueil.
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine Infos - Gestion des Rédacteurs',
      
      // Désactive le bandeau "DEBUG" en mode développement
      debugShowCheckedModeBanner: false,
      
      // Configuration du thème global de l'application
      theme: ThemeData(
        primarySwatch: Colors.pink, // Couleur principale utilisée dans toute l'app
        useMaterial3: true,         // Active Material Design 3
      ),
      
      // Page affichée au démarrage de l'application
      home: const PageAcceuil(),
    );
  }
}