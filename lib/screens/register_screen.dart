import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fin_track/components/my_text_form_field.dart';
import 'package:fin_track/main.dart';
import 'package:fin_track/models/users.dart';
import 'package:fin_track/screens/login_screen.dart';
import 'package:fin_track/services/auth_services.dart';
import 'package:fin_track/utils/app_validator.dart';
import 'package:fin_track/widgets/auth_gate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AppValidator appValidator = AppValidator();

  final AuthServices _authServices = AuthServices();

  bool isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _submitForm(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Register user with Firebase Auth (email & password)
        UserCredential userCredential = await _authServices.createUser(
            _emailController.text, _passwordController.text, context);

        // Ensure UID is valid
        String uid = userCredential.user?.uid ?? '';
        if (uid.isEmpty) {
          throw Exception("User UID is invalid.");
        }

        // Create a UserModel instance
        Users newUser = Users(
          uid: uid,
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          password: _passwordController.text,
        );

        // Save user data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(newUser.toMap());

        // Navigate or show success message
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Successful")));
      } catch (e) {
        // Handle errors (e.g., email already in use, weak password)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
      } finally {
        setState(() {
          isLoading = false;

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const AuthGate()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffad0c4),
                  Color(0xffffd1ff),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 40,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      SizedBox(
                        height: mq.height * .04,
                      ),
                      const Text(
                        "Register Now!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 40),
                      MyTextFormField(
                        controller: _nameController,
                        validator: appValidator.validateUserName,
                        description: 'User name',
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      MyTextFormField(
                        controller: _emailController,
                        description: 'e-Mail',
                        validator: appValidator.validateEmail,
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      MyTextFormField(
                        controller: _phoneNumberController,
                        description: 'Phone Number',
                        validator: appValidator.validatePhoneNumber,
                        obscureText: false,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      MyTextFormField(
                        controller: _passwordController,
                        description: 'Password',
                        validator: appValidator.validatePassword,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * .05,
                        ),
                        child: SizedBox(
                          height: 50,
                          width: mq.width,
                          child: ElevatedButton(
                            onPressed: () => _submitForm(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade200,
                              foregroundColor: Colors.black,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : const Text(
                                    "Submit",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already a member.",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login now.",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
