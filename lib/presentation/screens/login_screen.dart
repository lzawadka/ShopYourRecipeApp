import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/api_response.dart';
import '../blocs/auth_provider.dart';
import '../widgets/text_form_widget.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName =  '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  GlobalKey<FormFieldState<String>> _emailKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _passwordKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _confirmPasswordKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _firstNameKey = GlobalKey<FormFieldState<String>>();
  GlobalKey<FormFieldState<String>> _lastNamePasswordKey = GlobalKey<FormFieldState<String>>();

  bool _isSignUp = false;

  SizedBox sizedBoxBig = const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _isSignUp ? const Text("S'inscrire") : const Text('Se connecter')),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            sizedBoxBig,
            if (_isSignUp)
              TextFormField(
                key: _firstNameKey,
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nom requis';
                  }
                  return null;
                },
              ),
            sizedBoxBig,
            if (_isSignUp)
              TextFormField(

                key: _lastNamePasswordKey,
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Prénom requis';
                  }
                  return null;
                },
              ),
            sizedBoxBig,
            TextFormField(
              key: _emailKey,
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email requis';
                }
                return null;
              },
            ),
            sizedBoxBig,
            TextFormField(
              key: _passwordKey,
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password requis';
                }
                return null;
              },
            ),
            sizedBoxBig,
            if (_isSignUp)
              TextFormField(
                key: _confirmPasswordKey,
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmation de mot de passe requis';
                  } else if (value != _passwordController.text) {
                    return 'Les mots de passe no correspondent pas';
                  }
                  return null;
                },
              ),
            sizedBoxBig,
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_isSignUp) {
                    // Sign up
                    try {
                      final bool result = await context
                          .read<AuthProvider>()
                          .signUp(_firstNameController.text, _lastNameController.text, _emailController.text, _passwordController.text);

                      if (result) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                          content: Text("Cet utilisateur existe déjà"),
                        ));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Une erreur est survenue"),
                          )
                      );
                    }
                  } else {
                    // Sign in
                    try {
                      final isSuccess = await context.read<AuthProvider>().signIn(_emailController.text, _passwordController.text);

                      if (isSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email ou mot de passe incorrect'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur : $e'),
                        ),
                      );
                    }
                  }
                }
              },
              child: Text(_isSignUp ? "S'inscrire" : 'Se connecter'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp = !_isSignUp;
                });
              },
              child: Text(_isSignUp
                  ? 'Déjà un compte ? Connecte toi ! '
                  : "Pas encore de compte ? Inscris toi ! "),
            ),
          ],
        ),
      ),
    );
  }
}