import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


/* Déclaration et initialisation de la classe qui va nous permettre de créer le quatrième bloc de la page
 La classe PartieIcone est un autre Widget Stateless qui représente un bloc de type conteneur. 
 Elle définit un conteneur contenant un element enfant de type ligne qui englobe aussi trois elements enfants de type conteneur
  qui eux à leur tour contiennent chacun un element enfant. Chaque element enfant contient lui aussi des elements enfants qui sonht de type icone, texte et box avec leur propriétés distinctes. */
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row( 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
        children: [ Container( 
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
              const Icon(
                Icons.phone, 
                color: Colors.pink,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(height: 5),
              Text(
                "Tel".toUpperCase(),
                style:  GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                  color: Colors.pink
                  ),
                ),
              ),
            ],
            ),
            
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.mail, 
                  fontWeight: FontWeight.w900,
                  color: Colors.pink
                ),
                const SizedBox(height: 5),
                Text(
                  "Tel".toUpperCase(),
                  style:  GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.pink
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
              const Icon(
                Icons.share, 
                fontWeight: FontWeight.w900,
                color: Colors.pink
              ),
              const SizedBox(height: 5),
              Text(
                "Partage".toUpperCase(),
                style:  GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.pink
                  ),
                ),
              ),
            ],
            ),
          ),
       ],
      ),
    );
  }
}