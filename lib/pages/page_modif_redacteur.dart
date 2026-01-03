import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/database/redacteur_provider_riverpod.dart';
import 'package:redacteurapp/model/redacteur.dart';

/// Page de modification d'un rédacteur existant.
/// 
/// Reçoit les données du rédacteur en paramètre pour pré-remplir le formulaire.
/// Utilise ConsumerStatefulWidget pour combiner state management local et Riverpod.
class ModifierRedacteurPage extends ConsumerStatefulWidget {
  final String redacteurId;
  final Redacteur redacteurData;

  const ModifierRedacteurPage({
    super.key,
    required this.redacteurId,
    required this.redacteurData,
  });

  @override
  ConsumerState<ModifierRedacteurPage> createState() =>
      _ModifierRedacteurPageState();
}

class _ModifierRedacteurPageState extends ConsumerState<ModifierRedacteurPage> {
  final _formKey = GlobalKey<FormState>();
  
  // late = initialisés dans initState avec les données existantes
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _specialiteController;
  bool _isLoading = false;

  /// Initialise les controllers avec les valeurs actuelles du rédacteur.
  /// Permet à l'utilisateur de voir et modifier les données existantes.
  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.redacteurData.nom);
    _prenomController =
        TextEditingController(text: widget.redacteurData.prenom);
    _emailController = TextEditingController(text: widget.redacteurData.email);
    _specialiteController =
        TextEditingController(text: widget.redacteurData.specialite);
  }

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

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  /// Soumet les modifications au repository Firebase.
  /// 
  /// Flow: validation → loader → update Firebase → dialog succès → double pop
  /// Le double pop retire la page de modification ET le dialog
  Future<void> _enregistrerModifications() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final repository = ref.read(redacteurRepositoryProvider);
        await repository.modifierRedacteur(
          id: widget.redacteurId,
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          specialite: _specialiteController.text.trim(),
        );

        if (mounted) {
          showDialog(
            context: context,
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
                      'Youpi, les modifications ont été enregistrées avec succès !',
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
                    // Double pop : ferme le dialog puis retourne à la liste
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
                'Erreur lors de la modification: $e',
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
        if (mounted) {
          setState(() => _isLoading = false);
        }
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
          'Modifier le Rédacteur',
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
      
      // Formulaire identique à AjoutRedacteurPage mais pré-rempli
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.edit, 
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
              
              // Champ Email avec validation de format
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
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un email';
                  }
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
              ElevatedButton(
                onPressed: _isLoading ? null : _enregistrerModifications,
                style: styleBouton,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                      'Enregistrer', 
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