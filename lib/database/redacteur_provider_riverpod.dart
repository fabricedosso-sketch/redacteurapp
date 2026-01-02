import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redacteurapp/model/redacteur.dart';
import 'package:redacteurapp/database/firebase_services.dart';

// Provider du service Firebase
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

// Provider pour le stream des rédacteurs
final redacteursStreamProvider = StreamProvider<List<Redacteur>>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getRedacteurs();
});

// Provider pour les opérations CRUD
final redacteurRepositoryProvider = Provider<RedacteurRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return RedacteurRepository(firebaseService);
});

// Repository pour encapsuler les opérations
class RedacteurRepository {
  final FirebaseService _firebaseService;

  RedacteurRepository(this._firebaseService);

  Future<void> ajouterRedacteur({
    required String nom,
    required String prenom,
    required String email,
    required String specialite,
  }) async {
    final redacteur = Redacteur(
      id: '',
      nom: nom,
      prenom: prenom,
      email: email,
      specialite: specialite,
    );
    await _firebaseService.ajouterRedacteur(redacteur);
  }

  Future<void> modifierRedacteur({
    required String id,
    required String nom,
    required String prenom,
    required String email,
    required String specialite,
  }) async {
    final redacteur = Redacteur(
      id: id,
      nom: nom,
      prenom: prenom,
      email: email,
      specialite: specialite,
    );
    await _firebaseService.modifierRedacteur(id, redacteur);
  }

  Future<void> supprimerRedacteur(String id) async {
    await _firebaseService.supprimerRedacteur(id);
  }
}