import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/* Déclaration et initialisation de la classe qui va nous permettre de créer le troisième bloc de la page
 La classe PartieTexte est un autre Widget Stateless qui représente un bloc de type conteneur. 
 Elle définit un conteneur contenant un element enfant de type texte avec une propriété style appliquant une taille de police. */
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ajout d'une marge interieur des côtés horizontaux seulement.
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // Création d'un element enfant de type texte avec une propriété style appliquant une taille de police.
      child: Text(
        "Magazine Infos est bien plus qu'un magazine d'informations. C'est votre passerelle vers le monde, une source inestimable de connaissances et d'actualités soigneusement selectionnées pour vous éclairer sur les enjeux mondiaux, la culture, la science, et voir même le divertissement (le jeux).", 
        style: GoogleFonts.dmSans(
          textStyle: TextStyle(
            fontSize: 14
          ),
        ),
      ),
    );
  }
}