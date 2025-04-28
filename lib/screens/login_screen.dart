import 'dart:developer';

import 'package:fin_track/components/my_text_form_field.dart';
import 'package:fin_track/main.dart';
import 'package:fin_track/screens/register_screen.dart';
import 'package:fin_track/services/auth_services.dart';
import 'package:fin_track/utils/app_validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AppValidator appValidator = AppValidator();
  bool isLoading = false;

  final AuthServices _authServices = AuthServices();

  Future<void> _submitForm(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_formKey.currentState!.validate()) {
        var data = {
          'email': _emailController.text,
          'password': _passwordController.text,
        };

        await _authServices.logInUser(data, context);
      }
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
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
                        "Login Now!",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50),
                      MyTextFormField(
                        controller: _emailController,
                        validator: appValidator.validateEmail,
                        description: 'e-Mail',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      MyTextFormField(
                        controller: _passwordController,
                        validator: appValidator.validatePassword,
                        description: 'Password',
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      // Forgot Password
                      Padding(
                        padding: EdgeInsets.only(left: mq.width * .47),
                        child: const Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mq.width * .05,
                        ),
                        child: SizedBox(
                          height: 50,
                          width: mq.width,
                          child: ElevatedButton(
                            onPressed: () {
                              _submitForm(context);
                            },
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
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Not a member?",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Register now.",
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
