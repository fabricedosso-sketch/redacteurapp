import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/* Déclaration et initialisation de la classe qui va nous permettre de créer le seconde bloc de la page
 La classe PartieTitre est un autre Widget Stateless qui représente un bloc de type conteneur. 
 Elle définit un conteneur contenant un element enfant de type colonne qui englobe aussi deux elements enfanst de type texte. */

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Creation d'une marge interieur de tous les côtés de l'element
      padding: const EdgeInsets.all(20),
      // Création d'un element enfant de type colonne avec un alignement horizontalement 
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Création de deux éléments enfants de type texte avec une propriété style appliquant une taille et une mise en forme de police.
        children: [
          Text(
            "Bienvenue au Magazine Infos", 
            style: GoogleFonts.dmSans(
              textStyle : TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            "Votre Magazine numérique, votre source d'inspiration", 
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
