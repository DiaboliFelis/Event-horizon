import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> SignInWithEmailAndPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushNamed(context, '/menu');
    } on FirebaseAuthException catch (e) {
    String errorMessage = 'Произошла ошибка. Пожалуйста, повоторите позднее.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8ECFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 500,
              width: 301,
              decoration: BoxDecoration(
                color: Color(0xA64F81A3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text("Event Horizon",
                          style: TextStyle(
                              fontSize: 31,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        cursorHeight: 30, // Высота курсора
                        strutStyle: const StrutStyle(
                          height: 2.0, // Высота строки
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                          hintText: 'Email/логин',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                         controller: _passwordController,
                          obscureText: true, 
                         cursorHeight: 30, // Высота курсора
                        strutStyle: const StrutStyle(
                          height: 2.0, // Высота строки
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                          hintText: 'Пароль',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 91, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Пожалуйста, заполните все поля.')),
                            );
                            return;
                          }

                          await SignInWithEmailAndPassword(
                            email: email,
                            password: password,
                            context: context,
                          );
                        },
                        child: const Text('Войти',
                            style: TextStyle(
                                fontSize: 19,
                                color: Color(0xFF313131),
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        //TODO
                        onTap: ()  { 
                        },
                        child: const Text(
                          'Забыли пароль?',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              decorationColor: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/registration1');
                        },
                        child: const Text(
                          'Регистрация',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              decorationColor: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}