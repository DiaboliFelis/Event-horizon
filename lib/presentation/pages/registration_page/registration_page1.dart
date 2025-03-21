import 'package:event_horizon/presentation/pages/profile_page/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD8ECFF),
      ),
      body: RegistrationScreen1(),
    );
  }
}

void CreateUserWithLoginEmailAndPassword({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Пользователь зарегистрирован успешно!')),
    );

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Произошла ошибка. Пожалуйста, повторите позднее.';
    if (e.code == 'weak-password') {
      errorMessage = 'Слишком простой пароль.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'Аккаунт с такой почтой уже существует.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Неожиданная ошибка.')),
    );
  }
}

class RegistrationScreen1 extends StatefulWidget {
  @override
  _RegistrationScreen1State createState() => _RegistrationScreen1State();
}

class _RegistrationScreen1State extends State<RegistrationScreen1> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _loginController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8ECFF),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Container(
                height: 600,
                width: 320,
                decoration: BoxDecoration(
                  color: const Color(0xA64F81A3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Регистрация",
                        style: TextStyle(
                          fontSize: 31,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        cursorHeight: 25,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Пароль',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _confirmPasswordController,
                        cursorHeight: 25,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Повторите пароль',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _loginController,
                        cursorHeight: 25,
                        decoration: InputDecoration(
                          hintText: 'Логин',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final confirmPassword =
                              _confirmPasswordController.text.trim();

                          if (email.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Пожалуйста, заполните все поля')),
                            );
                            return;
                          }

                          if (!EmailValidator.validate(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Введите валидный адрес электронной почты')),
                            );
                            return;
                          }

                          if (password != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Пароли не совпадают')),
                            );
                            return;
                          }

                          CreateUserWithLoginEmailAndPassword(
                            email: email,
                            password: password,
                            context: context,
                          );
                        },
                        child: const Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
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
