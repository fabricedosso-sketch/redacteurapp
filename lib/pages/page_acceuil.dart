import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/pages/page_liste_redacteur.dart';
import 'package:redacteurapp/pages/page_ajout_redacteur.dart';
import '../widgets/partie_titre.dart';
import '../widgets/partie_texte.dart';
import '../widgets/partie_icone.dart';
import '../widgets/partie_rubrique.dart';

class PageAcceuil extends StatelessWidget {
  const PageAcceuil({super.key});

// Déclaration d'une fonction build() qui se subtitue à la classe mère et retourne le widget Scaffold qui contient tous les elements visibles de la page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title:  Text(
          'Magazine Infos',
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
            color : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
            ),
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink,
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.edit,
                color: Colors.pink,
                ),
              title: Text(
                'Ajouter un rédacteur',
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                  )
                )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AjoutRedacteurPage())
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.pink,
                ),
              title: Text(
                'Liste des rédacteurs',
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                  ),
                ), 
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RedacteurInfoPage()),
                );
              },
            ),
          ],
        ),
      ),
      
      // Declaration d'un widget pour l'affichage du contenu principale de l'app avec des propriétés enfants comme une image dans notre cas et les autres blocs de notre page d'acceuil.
      // Le widget body regroupe tous les propriétés du corps principal de l'app
      body: SingleChildScrollView(
        child:  Column(
        children: [
          Image(
          image: AssetImage('assets/images/img3.jpg')),
          PartieTitre(),
          PartieTexte(),
          PartieIcone(),
          PartieRubrique(),
        ],
      )
      ),
    );
  }
}






