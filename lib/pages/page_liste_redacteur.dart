import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/database/redacteur_provider_riverpod.dart';
import 'package:redacteurapp/model/redacteur.dart';
import 'package:redacteurapp/pages/page_ajout_redacteur.dart';
import 'package:redacteurapp/pages/page_modif_redacteur.dart';
import 'package:redacteurapp/pages/page_supp_redacteur.dart';

/// Page d'affichage de la liste des rédacteurs avec gestion des états asyncrones.
/// 
/// Utilise ConsumerWidget pour écouter le StreamProvider et reconstruire
/// automatiquement l'UI lors des modifications Firebase en temps réel.
class RedacteurInfoPage extends ConsumerWidget {
  const RedacteurInfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Écoute le stream Firebase via Riverpod - reconstruction automatique lors des changements
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
      
      // FAB pour accès rapide à la création
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
      
      // Gestion des 3 états possibles du Stream : data, loading, error
      body: redacteursAsync.when(
        // État data : liste chargée avec succès
        data: (redacteurs) {
          // Empty state avec message d'encouragement
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

          // Liste scrollable des rédacteurs
          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: redacteurs.length,
            itemBuilder: (context, index) {
              final redacteur = redacteurs[index];
              return _RedacteurCard(redacteur: redacteur);
            },
          );
        },
        
        // État loading : affichage pendant le chargement initial
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.pink,
          ),
        ),
        
        // État error : affichage en cas d'échec de connexion Firebase
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

/// Widget représentant une carte individuelle de rédacteur.
/// 
/// Extrait dans un widget séparé pour :
/// - Améliorer la lisibilité du code
/// - Faciliter la réutilisation
/// - Optimiser les reconstructions (seule la carte modifiée est rebuildée)
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
        
        // Avatar circulaire avec initiales du rédacteur
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
        
        // Nom complet du rédacteur (utilise le getter nomComplet du modèle)
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
        
        // Informations secondaires : email et spécialité
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
        
        // Actions CRUD : édition et suppression
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton de modification - navigue vers la page d'édition
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
            
            // Bouton de suppression - navigue vers la page de confirmation
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