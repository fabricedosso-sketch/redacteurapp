import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/database/redacteur_provider_riverpod.dart';
import 'package:redacteurapp/model/redacteur.dart';
import 'package:redacteurapp/pages/page_ajout_redacteur.dart';
import 'package:redacteurapp/pages/page_modif_redacteur.dart';
import 'package:redacteurapp/pages/page_supp_redacteur.dart';

class RedacteurInfoPage extends ConsumerWidget {
  const RedacteurInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redacteursAsync = ref.watch(redacteursStreamProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Liste des redacteurs',
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => AjoutRedacteurPage(),
            )
          );
        },
        backgroundColor: Colors.pink,
        child: Icon(
          Icons.add,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: redacteursAsync.when(
        data: (redacteurs) {
          if (redacteurs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.people_outline, 
                    size: 100, 
                    color: Colors.grey
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Aucun rédacteur trouvé',
                    style: GoogleFonts.dmSans(
                      textStyle: const TextStyle(
                      fontSize: 22, 
                      color: Colors.grey
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                   Text(
                    'Ajoutez votre premier rédacteur !',
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                      fontSize: 18, 
                      color: Colors.grey
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: redacteurs.length,
            itemBuilder: (context, index) {
              final redacteur = redacteurs[index];
              return _RedacteurCard(redacteur: redacteur);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline, 
                size: 60, 
                color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Erreur: $error',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RedacteurCard extends StatelessWidget {
  final Redacteur redacteur;

  const _RedacteurCard({required this.redacteur});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 2,
      child: ListTile(
        contentPadding:  EdgeInsetsDirectional.only(
          start: 5, 
          end: 1
        ),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.pink,
          child: Text(
            '${redacteur.prenom[0]}${redacteur.nom[0]}',
            style: GoogleFonts.dmSans(
              textStyle: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Text(
          redacteur.nomComplet,
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              redacteur.email,
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              redacteur.specialite,
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit, 
                color: Colors.grey
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierRedacteurPage(
                      redacteurId: redacteur.id,
                      redacteurData: redacteur,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.delete, 
                color: Colors.red
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupprimerRedacteurPage(
                      redacteurId: redacteur.id,
                      redacteurData: redacteur,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}