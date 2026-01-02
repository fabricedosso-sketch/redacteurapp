class Redacteur {
  final String id;
  final String nom;
  final String prenom;
  final String email;
  final String specialite;

  Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.specialite,
  });

  // Conversion depuis Firestore
  factory Redacteur.fromFirestore(Map<String, dynamic> data, String id) {
    return Redacteur(
      id: id,
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      email: data['email'] ?? '',
      specialite: data['specialite'] ?? '',
    );
  }

  // Conversion vers Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'specialite': specialite,
    };
  }

  // CopyWith pour faciliter les modifications
  Redacteur copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? email,
    String? specialite,
  }) {
    return Redacteur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      email: email ?? this.email,
      specialite: specialite ?? this.specialite,
    );
  }

  String get nomComplet => '$prenom $nom';
}