import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/database/redacteur_provider_riverpod.dart';
import 'package:redacteurapp/model/redacteur.dart';

/// Page de confirmation de suppression d'un rédacteur.
/// 
/// Affiche les informations du rédacteur à supprimer et demande une confirmation
/// explicite avant l'action destructive. Pattern UX critique pour éviter les
/// suppressions accidentelles.
class SupprimerRedacteurPage extends ConsumerStatefulWidget {
  final String redacteurId;
  final Redacteur redacteurData;

  const SupprimerRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurData,
  });

  @override
  ConsumerState<SupprimerRedacteurPage> createState() =>
      _SupprimerRedacteurPageState();
}

class _SupprimerRedacteurPageState
    extends ConsumerState<SupprimerRedacteurPage> {
  bool _isLoading = false;

  // Style pour le bouton d'annulation (outlined)
  final ButtonStyle styleBoutonAnnuler = OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      vertical: 15
    ),
    side: const BorderSide(
      color:Colors.pink,
      width: 2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(5)
    ),
    textStyle: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.bold
    ),
  );
 
  // Style pour le bouton de suppression (rouge = danger)
  final ButtonStyle styleBoutonSupp = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    padding: const EdgeInsets.symmetric( 
      vertical: 15
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(5)
    ),
    textStyle: TextStyle(
      fontSize: 24, 
      fontWeight: FontWeight.bold
    ),
  );

  /// Exécute la suppression du rédacteur dans Firebase.
  /// 
  /// barrierDismissible: false empêche la fermeture accidentelle du dialog
  /// de succès en cliquant à l'extérieur.
  Future<void> _supprimerRedacteur() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(redacteurRepositoryProvider);
      await repository.supprimerRedacteur(widget.redacteurId);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false, // Force l'utilisateur à cliquer sur OK
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Succès',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                   fontWeight: FontWeight.bold 
                  ),
                ),
              ),
              content: Column(
                mainAxisSize:MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/success-icon.png',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Youpi, le rédacteur a été supprimé avec succès !',
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le dialog
                    Navigator.of(context).pop(); // Retour à la liste
                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        color: Colors.pink,
                        fontSize: 20,
                        fontWeight: FontWeight.bold 
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur lors de la suppression: $e',
              style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold 
                  ),
                ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
        // Réinitialise le loader uniquement en cas d'erreur
        // (en cas de succès, on quitte la page donc pas besoin)
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title:  Text(
          'Supprimer le Rédacteur',
          style: GoogleFonts.dmSans(
            textStyle: TextStyle(
              color : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        centerTitle: true,
      ),
      
      // Interface de confirmation centrée avec avertissements visuels
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône d'avertissement pour signaler l'action dangereuse
            const Icon(
              Icons.warning_amber_rounded,
              size: 120,
              color: Colors.red,
            ),
            const SizedBox(height: 5),
            
            // Titre d'alerte en rouge
             Text(
              'Attention !',
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Message de confirmation
             Text(
              'Êtes-vous sûr de vouloir supprimer ce rédacteur ?',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                fontSize: 18
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Card affichant les détails du rédacteur à supprimer
            // Permet à l'utilisateur de vérifier qu'il supprime bien la bonne personne
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar avec initiales
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.pink,
                          child: Text(
                            '${widget.redacteurData.prenom[0]}${widget.redacteurData.nom[0]}',
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        
                        // Informations du rédacteur
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.redacteurData.nomComplet,
                                style: GoogleFonts.dmSans(
                                  textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                widget.redacteurData.email,
                                style: GoogleFonts.dmSans(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Text(
                                widget.redacteurData.specialite,
                                style: GoogleFonts.dmSans(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Avertissement final sur l'irréversibilité
             Text(
              'Cette action est irréversible !',
              style: GoogleFonts.dmSans(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Boutons d'action : Annuler (outlined) et Supprimer (rouge)
            // Disposition côte à côte avec poids égal (Expanded)
            Row(
              children: [
                // Bouton d'annulation - retour sans action
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    style: styleBoutonAnnuler,
                    child: Text(
                      'Annuler',
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                
                // Bouton de suppression - action destructive
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _supprimerRedacteur,
                    style: styleBoutonSupp,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Supprimer',
                            style: GoogleFonts.dmSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}