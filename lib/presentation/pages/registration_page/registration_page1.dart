import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:event_horizon/presentation/pages/profile_page/profile_page.dart';

// Функция для регистрации нового пользователя с логином и паролем
Future<void> CreateUserWithLoginEmailAndPassword({
  required String email,
  required String password,
  required String login,
  required BuildContext context,
}) async {
  try {
    // Создание пользователя с email и паролем
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Сохраняем логин и email в Firestore после регистрации
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'login': login,
      'email': email,
      'name': '', // Имя, которое пользователь может изменить позже
    });

    // Уведомление о успешной регистрации
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Пользователь зарегистрирован успешно!')),
    );

    // Переход на страницу профиля после регистрации
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  } on FirebaseAuthException catch (e) {
    // Обработка ошибок регистрации
    String errorMessage = 'Произошла ошибка. Пожалуйста, повторите позднее.';
    if (e.code == 'weak-password') {
      errorMessage = 'Слишком простой пароль.';
    } else if (e.code == 'email-already-in-use') {
      errorMessage = 'Аккаунт с такой почтой уже существует.';
    }

    // Отображение ошибки пользователю
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    // Обработка неожиданной ошибки
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Неожиданная ошибка.')),
    );
  }
}

// Страница регистрации
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

// Экран регистрации с формой
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
                          final login = _loginController.text.trim();

                          // Проверка на пустые поля
                          if (email.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty ||
                              login.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Пожалуйста, заполните все поля')),
                            );
                            return;
                          }

                          // Проверка валидности email
                          if (!EmailValidator.validate(email)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Введите валидный адрес электронной почты')),
                            );
                            return;
                          }

                          // Проверка на совпадение паролей
                          if (password != confirmPassword) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Пароли не совпадают')),
                            );
                            return;
                          }

                          // Создание пользователя
                          CreateUserWithLoginEmailAndPassword(
                            email: email,
                            password: password,
                            login: login,
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
