import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redacteurapp/database/redacteur_provider_riverpod.dart';
import 'package:redacteurapp/pages/page_liste_redacteur.dart';

class AjoutRedacteurPage extends ConsumerStatefulWidget {
  const AjoutRedacteurPage({super.key});

  @override
  ConsumerState<AjoutRedacteurPage> createState() => _AjoutRedacteurPageState();
}

class _AjoutRedacteurPageState extends ConsumerState<AjoutRedacteurPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialiteController = TextEditingController();
  bool _isLoading = false;

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

  Future<void> _ajouterRedacteur() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final repository = ref.read(redacteurRepositoryProvider);
        await repository.ajouterRedacteur(
          nom: _nomController.text.trim(),
          prenom: _prenomController.text.trim(),
          email: _emailController.text.trim(),
          specialite: _specialiteController.text.trim(),
        );

        if (mounted) {
          _afficherSuccesDialog();
        }
      } catch (e) {
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
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.person_add, 
                size: 120, 
                color: Colors.pink
              ),
              const SizedBox(height: 5),
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
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
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