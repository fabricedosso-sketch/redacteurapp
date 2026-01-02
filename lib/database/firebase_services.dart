import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redacteurapp/model/redacteur.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'redacteurs';

  // Récupérer tous les rédacteurs en temps réel
  Stream<List<Redacteur>> getRedacteurs() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Redacteur.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Ajouter un rédacteur
  Future<void> ajouterRedacteur(Redacteur redacteur) async {
    await _firestore.collection(_collectionName).add(redacteur.toFirestore());
  }

  // Modifier un rédacteur
  Future<void> modifierRedacteur(String id, Redacteur redacteur) async {
    await _firestore
        .collection(_collectionName)
        .doc(id)
        .update(redacteur.toFirestore());
  }

  // Supprimer un rédacteur
  Future<void> supprimerRedacteur(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }

  // Récupérer un rédacteur spécifique
  Future<Redacteur?> getRedacteur(String id) async {
    final doc = await _firestore.collection(_collectionName).doc(id).get();
    if (doc.exists) {
      return Redacteur.fromFirestore(doc.data()!, doc.id);
    }
    return null;
  }
}