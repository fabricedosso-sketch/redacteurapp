import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redacteurapp/model/redacteur.dart';


// Cette classe gère tout ce qui concerne Firebase pour les rédacteurs
// C'est comme un intermédiaire entre ton app et la base de données
class FirebaseService {

  // _firestore : c'est la connexion à Firebase
  // Le _ devant veut dire que c'est privé (utilisable que dans cette classe)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Le nom de ta "table" dans Firebase (on appelle ça une collection)
  final String _collectionName = 'redacteurs';

  // ========== VOIR TOUS LES RÉDACTEURS (EN DIRECT) ==========
  
  // Cette fonction récupère TOUS les rédacteurs
  // Stream = flux en temps réel, ça se met à jour automatiquement !
  // Dès que quelqu'un ajoute/modifie/supprime un rédacteur, tu le vois
  Stream<List<Redacteur>> getRedacteurs() {
    return _firestore
        .collection(_collectionName) // Va dans la collection 'redacteurs'
        .snapshots() // Écoute les changements en temps réel
        .map((snapshot) => snapshot.docs // Pour chaque mise à jour, prends tous les documents
            .map((doc) => Redacteur.fromFirestore(doc.data(), doc.id)) // Transforme chaque doc en objet Redacteur
            .toList()); // Mets tout ça dans une liste
  }

  // ========== AJOUTER UN NOUVEAU RÉDACTEUR ==========
  
  // Ajoute un nouveau rédacteur dans Firebase
  // Future = fonction asynchrone (elle prend du temps car elle contacte internet)
  // await = on attend que ça se finisse avant de continuer
  Future<void> ajouterRedacteur(Redacteur redacteur) async {
    // .add() crée un nouveau document avec un ID automatique
    // toFirestore() transforme ton objet Redacteur en données Firebase (Map)
    await _firestore.collection(_collectionName).add(redacteur.toFirestore());
  }

  // ========== MODIFIER UN RÉDACTEUR EXISTANT ==========
  
  // Change les infos d'un rédacteur qui existe déjà
  // Il faut lui donner l'ID du rédacteur et les nouvelles infos
  Future<void> modifierRedacteur(String id, Redacteur redacteur) async {
    await _firestore
        .collection(_collectionName) // Va dans la collection
        .doc(id) // Trouve le document avec cet ID
        .update(redacteur.toFirestore()); // Met à jour avec les nouvelles données
  }

  // ========== SUPPRIMER UN RÉDACTEUR ==========
  
  // Efface un rédacteur de la base de données
  // ATTENTION : c'est définitif, tu peux pas annuler !
  Future<void> supprimerRedacteur(String id) async {
    await _firestore
    .collection(_collectionName) // Va dans la collection
    .doc(id) // Trouve le document
    .delete(); // Supprime-le
  }

  // ========== VOIR UN SEUL RÉDACTEUR ==========
  
  // Récupère UN rédacteur spécifique (pas en temps réel, juste une fois)
  // Redacteur? = peut retourner un Redacteur OU null si pas trouvé
  Future<Redacteur?> getRedacteur(String id) async {
    // Va chercher le document
    final doc = await _firestore.collection(_collectionName).doc(id).get();

    // Vérifie si le document existe vraiment
    if (doc.exists) {
      // Si oui, transforme les données en objet Redacteur et retourne-le
      return Redacteur.fromFirestore(doc.data()!, doc.id);
    }
    // Si non, retourne null (rien trouvé)
    return null;
  }
}