import 'package:flutter/material.dart';

/* Déclaration et initialisation de la classe qui va nous permettre de créer le troisième bloc de la page
 La classe PartieRubrique est un autre Widget Stateless qui représente un bloc de type conteneur. 
 Elle définit un conteneur contenant un element enfant de type ligne qui englobe deux elements enfants de type d'arrondi de cadre qui eux à leur tour contiennent chacun enfant de type image. */
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ajout d'une marge interieur des côtés horizontaux seulement.
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // Ajout d'une ligne dans son widget parent
      child: Row(
        // Alignement horizontal des widgets enfants
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // Ajout de deux cadres rectangulaire aux côtés arrondis dans le widget parent
        children: [
          // Ajout d'un cadre rectangulaire aux côtés arrondis dans le widget parent
          ClipRRect(
            // Ajout d'une bordure circulaire de 8 pixels aux extremités du cadre rectangulaire
            borderRadius: BorderRadius.circular(8),
            // Ajout d'une image dans le cadre comme widget enfant
            child: const Image(
              width: 150,
              image: AssetImage(
                'assets/images/img4.jpeg')
            ),
          ),
          // Ajout d'un cadre rectangulaire aux côtés arrondis dans le widget parent
          ClipRRect(
            // Ajout d'une bordure circulaire de 8 pixels aux extremités du cadre rectangulaire
            borderRadius: BorderRadius.circular(8),
            // Ajout d'une image dans le cadre comme widget enfant
            child: const Image(
              width: 150,
              image: AssetImage(
                'assets/images/img5.jpeg')
            ),
          ),
        ],
      ),
    );
  }
}
