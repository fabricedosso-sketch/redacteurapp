import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/database/redacteur_provider_riverpod.dart';
import 'package:redacteurapp/pages/page_liste_redacteur.dart';

/// Page de création d'un nouveau rédacteur avec formulaire de validation.
/// 
/// Utilise ConsumerStatefulWidget pour accéder aux providers Riverpod
/// et gérer l'état local du formulaire (controllers, loading state).
class AjoutRedacteurPage extends ConsumerStatefulWidget {
  const AjoutRedacteurPage({super.key});

  @override
  ConsumerState<AjoutRedacteurPage> createState() => _AjoutRedacteurPageState();
}

class _AjoutRedacteurPageState extends ConsumerState<AjoutRedacteurPage> {
  // GlobalKey pour accéder et valider l'état du formulaire
  final _formKey = GlobalKey<FormState>();
  
  // Controllers pour gérer les valeurs saisies dans chaque champ
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialiteController = TextEditingController();
  
  // Flag pour désactiver le bouton pendant la soumission et afficher le loader
  bool _isLoading = false;

  // Style réutilisable pour le bouton d'ajout
  final ButtonStyle styleBouton = ElevatedButton.styleFrom(
    backgroundColor: Colors.pink,
    padding: const EdgeInsets.symmetric(
      horizontal: 40, 
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

  /// Libère les ressources des controllers pour éviter les fuites mémoire.
  /// Appelé automatiquement quand le widget est retiré de l'arbre.
  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  /// Soumission du formulaire avec validation et gestion d'erreurs.
  /// 
  /// Flow: validation → affichage loader → appel API → dialog succès ou snackbar erreur
  Future<void> _ajouterRedacteur() async {
    // Valide tous les champs du formulaire
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Récupère le repository via Riverpod et appelle la méthode d'ajout
        final repository = ref.read(redacteurRepositoryProvider);
        await repository.ajouterRedacteur(
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          specialite: _specialiteController.text.trim(),
        );

        // Vérifie que le widget est toujours monté avant d'afficher le dialog
        if (mounted) {
          _afficherSuccesDialog();
        }
      } catch (e) {
        // Affiche un snackbar d'erreur en cas d'échec
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erreur lors de l\'ajout: $e',
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
        }
      } finally {
        // Réinitialise le loader dans tous les cas (succès ou erreur)
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  /// Affiche un dialog de confirmation et navigue vers la liste des rédacteurs.
  /// 
  /// pushAndRemoveUntil efface toute la pile de navigation pour éviter
  /// de revenir sur le formulaire avec le bouton retour.
  void _afficherSuccesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
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
                'Youpi, le rédacteur a été ajouté avec succès !',
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
                // Navigue vers la liste et vide la pile de navigation
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RedacteurInfoPage()),
                  (route) => false
                );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text(
          'Ajouter un rédacteur',
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
      
      // Formulaire scrollable avec validation intégrée
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icône décorative
              const Icon(
                Icons.person_add, 
                size: 120, 
                color: Colors.pink
              ),
              const SizedBox(height: 5),
              
              // Champ Nom avec validation obligatoire
              Text(
                "Nom",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                ),
              ),
              TextFormField(
                controller: _nomController,
                decoration:  InputDecoration(
                  hintText: 'Doe',
                  hintStyle: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Colors.pink,
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Champ Prénom avec validation obligatoire
              Text(
                "Prénom(s)",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                ),
              ),
              TextFormField(
                controller: _prenomController,
                decoration:  InputDecoration(
                  hintText: 'John',
                  hintStyle: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.pink
                    )
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un ou des prénom(s)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Champ Email avec validation de format via regex
              Text(
                "Email",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'john.doe@example.com',
                  hintStyle: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.pink
                    )
                  ),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
                  // Regex pour valider le format email standard
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Champ Spécialité avec validation obligatoire
              Text(
                "Spécialité",
                style: GoogleFonts.dmSans(
                  textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                  )
                ),
              ),
              TextFormField(
                controller: _specialiteController,
                decoration: InputDecoration(
                  hintText: 'Techologie et IA',
                  hintStyle: GoogleFonts.dmSans(
                    textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.pink
                    )
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une spécialité';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              
              // Bouton de soumission avec loader conditionnel
              // Désactivé pendant le chargement pour éviter les doubles soumissions
              ElevatedButton(
                onPressed: _isLoading ? null : _ajouterRedacteur,
                style: styleBouton,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                      'Ajouter', 
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                        ),
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