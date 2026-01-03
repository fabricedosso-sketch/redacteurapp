import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redacteurapp/model/redacteur.dart';
import 'package:redacteurapp/database/firebase_services.dart';

// ========== PROVIDER 1 : LE SERVICE FIREBASE ==========

// Ce provider crée UNE SEULE instance de FirebaseService pour toute l'app
// C'est comme avoir UN SEUL téléphone pour appeler Firebase
// Provider = ne change jamais, toujours le même objet
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});


// ========== PROVIDER 2 : LA LISTE DES RÉDACTEURS EN TEMPS RÉEL ==========

// Ce provider donne accès à la liste des rédacteurs qui se met à jour automatiquement
// StreamProvider = pour les données qui changent en temps réel (Stream)
// Dès qu'un rédacteur est ajouté/modifié/supprimé dans Firebase, tous les widgets
// qui écoutent ce provider voient le changement instantanément !
final redacteursStreamProvider = StreamProvider<List<Redacteur>>((ref) {
  // ref.watch = "surveille" le firebaseServiceProvider
  // Si firebaseService change, ce provider se recrée automatiquement
  final firebaseService = ref.watch(firebaseServiceProvider);
  
  // Retourne le stream des rédacteurs
  return firebaseService.getRedacteurs();
});


// ========== PROVIDER 3 : LE REPOSITORY (pour faire les actions) ==========

// Ce provider donne accès au Repository qui contient toutes les actions
// (ajouter, modifier, supprimer)
// C'est comme avoir une télécommande avec tous les boutons
final redacteurRepositoryProvider = Provider<RedacteurRepository>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return RedacteurRepository(firebaseService);
});


// ========== LA CLASSE REPOSITORY ==========

// Le Repository c'est une couche intermédiaire
// Pourquoi ? Pour simplifier le code et ne pas appeler Firebase directement partout
// C'est comme un serveur dans un restaurant : tu lui demandes ce que tu veux,
// et lui va chercher ça en cuisine (Firebase)
class RedacteurRepository {

  // Stocke le service Firebase (privé car on veut pas y accéder de l'extérieur)
  final FirebaseService _firebaseService;

  // Constructeur : quand tu crées un Repository, tu lui donnes un FirebaseService
  RedacteurRepository(this._firebaseService);

  // ========== AJOUTER UN RÉDACTEUR ==========
  
  // Cette fonction simplifie l'ajout d'un rédacteur
  // Au lieu de créer un objet Redacteur dans ton widget, tu donnes juste les infos
  // et le Repository s'occupe de tout !
  // 
  // required = obligatoire, tu DOIS donner cette info
  Future<void> ajouterRedacteur({
    required String nom,
    required String prenom,
    required String email,
    required String specialite,
  }) async {
    // Crée l'objet Redacteur avec les infos données
    // id = '' car Firebase va générer l'ID automatiquement
    final redacteur = Redacteur(
      id: '', // Vide pour le moment, Firebase va le remplir
      nom: nom,
      prenom: prenom,
      email: email,
      specialite: specialite,
    );

    // Envoie le rédacteur à Firebase
    await _firebaseService.ajouterRedacteur(redacteur);
  }

  // ========== MODIFIER UN RÉDACTEUR ==========
  
  // Change les infos d'un rédacteur existant
  // Ici on a besoin de l'ID car on doit savoir QUEL rédacteur modifier
  Future<void> modifierRedacteur({
    required String id, // L'ID du rédacteur à modifier 
    required String nom,
    required String prenom,
    required String email,
    required String specialite,
  }) async {
    // Crée un nouvel objet Redacteur avec les nouvelles infos
    final redacteur = Redacteur(
      id: id,  // Cette fois l'ID est fourni
      nom: nom,
      prenom: prenom,
      email: email,
      specialite: specialite,
    );

    // Met à jour dans Firebase
    await _firebaseService.modifierRedacteur(id, redacteur);
  }

  // ========== SUPPRIMER UN RÉDACTEUR ==========
  
  // Efface un rédacteur (juste besoin de l'ID)
  Future<void> supprimerRedacteur(String id) async {
    await _firebaseService.supprimerRedacteur(id);
  }
}