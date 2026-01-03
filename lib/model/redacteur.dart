class Redacteur {

  // ========== LES PROPRIÉTÉS (les infos du rédacteur) ==========
  
  // final = une fois qu'on donne une valeur, on peut plus la changer
  // C'est comme écrire au stylo au lieu du crayon
  final String id; // L'identifiant unique (ex: "abc123")
  final String nom; // Le nom de famille (ex: "Dupont")
  final String prenom; // Le prénom (ex: "Jean")
  final String email; // L'adresse email (ex: "jean@example.com")
  final String specialite; // Le domaine d'expertise (ex: "Tech", "Sport")

  // ========== LE CONSTRUCTEUR (comment créer un rédacteur) ==========
  
  // C'est la fonction qui crée un nouveau rédacteur
  // required = tu DOIS donner toutes ces infos, rien n'est optionnel
  Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.specialite,
  });

  // ========== TRANSFORMER LES DONNÉES DE FIREBASE EN OBJET REDACTEUR ==========
  
  // factory = constructeur spécial pour créer un objet d'une façon particulière
  // Ici, on transforme les données Firebase (qui arrivent sous forme de Map)
  // en un joli objet Redacteur qu'on peut utiliser facilement
  // 
  // Map<String, dynamic> = comme un dictionnaire : clé → valeur
  // Exemple : {'nom': 'Dupont', 'prenom': 'Jean', ...}
  factory Redacteur.fromFirestore(Map<String, dynamic> data, String id) {
    return Redacteur(
      id: id, // L'ID vient à part (pas dans le data)

      // data['nom'] récupère le nom dans la Map
      // ?? '' = si le nom n'existe pas, on met une chaîne vide ''
      // C'est une sécurité pour éviter les bugs si les données sont incomplètes
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      specialite: data['specialite'] ?? '',
    );
  }

  // ========== TRANSFORMER L'OBJET REDACTEUR EN DONNÉES FIREBASE ==========
  
  // C'est l'inverse de fromFirestore !
  // On transforme notre objet Redacteur en Map pour l'envoyer à Firebase
  // 
  // Pourquoi on met pas l'ID ? Parce que Firebase le gère automatiquement
  // dans le document, pas besoin de le mettre dans les données
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom, // Clé 'nom' → valeur nom
      'prenom': prenom,
      'email': email,
      'specialite': specialite,
    };
  }

  
  // ========== COPIER UN RÉDACTEUR AVEC QUELQUES MODIFICATIONS ==========
  
  // CopyWith pour faciliter les modifications
  // copyWith est super pratique ! Imagine que tu veux changer juste l'email
  // mais garder le reste identique. Sans copyWith, tu devrais tout réécrire.
  // 
  // String? = peut être un String OU null
  // null = rien, vide, pas de valeur
  // 
  // Comment ça marche ?
  // Si tu donnes un nouvel email, il prend le nouveau
  // Si tu donnes null (rien), il garde l'ancien (this.email)
  Redacteur copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? email,
    String? specialite,
  }) {
    return Redacteur(
      // ?? = opérateur "ou alors"
      // id ?? this.id = "utilise le nouveau id, OU ALORS garde l'ancien"
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      specialite: specialite ?? this.specialite,
    );
  }

  // ========== GETTER : UNE PROPRIÉTÉ CALCULÉE ==========
  
  // get = propriété qu'on calcule à la volée (pas stockée)
  // nomComplet combine automatiquement prenom + nom
  // Tu peux l'utiliser comme une variable normale : redacteur.nomComplet
  // 
  // '$prenom $nom' = interpolation de chaîne
  // Si prenom = "Jean" et nom = "Dupont", ça donne "Jean Dupont"
  String get nomComplet => '$prenom $nom';
}