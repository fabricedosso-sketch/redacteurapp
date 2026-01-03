import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/pages/page_liste_redacteur.dart';
import 'package:redacteurapp/pages/page_ajout_redacteur.dart';
import 'package:redacteurapp/widgets/partie_titre.dart';
import 'package:redacteurapp/widgets/partie_texte.dart';
import 'package:redacteurapp/widgets/partie_icone.dart';
import 'package:redacteurapp/widgets/partie_rubrique.dart';

/// Page d'accueil principale avec navigation drawer et sections de contenu modulaires.
class PageAcceuil extends StatelessWidget {
  const PageAcceuil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar standard avec branding et icône de navigation
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
      
      // Menu latéral avec navigation vers les fonctionnalités CRUD
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header du drawer
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
            
            // Navigation vers la page de création
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
            
            // Navigation vers la page de listing
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
      
      // Contenu principal : image hero + sections de contenu empilées verticalement
      // SingleChildScrollView permet le défilement si le contenu dépasse la hauteur de l'écran
      body: SingleChildScrollView(
        child:  Column(
        children: [
          // Image d'en-tête (asset local)
          Image(
          image: AssetImage('assets/images/img3.jpg')),
          
          // Sections de contenu modulaires - peuvent être réorganisées ou supprimées
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