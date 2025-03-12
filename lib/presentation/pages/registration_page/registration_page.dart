import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
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
                      const SizedBox(
                        height: 40,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: '   Email/логин',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Рамка, когда поле не в фокусе
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // Рамка, когда поле в фокусе
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          hintText: '   Пароль',
                          hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            // Рамка, когда поле не в фокусе
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            // Рамка, когда поле в фокусе
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Цвет фона
                          padding: const EdgeInsets.symmetric(
                              horizontal: 91, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/menu');
                        },
                        child: const Text('Войти',
                            style: TextStyle(
                                fontSize: 19,
                                color: Color(0xFF313131),
                                fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          // Действие при нажатии
                        },
                        child: const Text(
                          'Забыли пароль?',
                          style: TextStyle(
                              color: Colors.white, // Цвет текста
                              fontWeight: FontWeight.w700,
                              decoration:
                                  TextDecoration.underline, // Подчеркивание
                              fontSize: 20,
                              decorationColor: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 40),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context,
                              '/registration1'); // Действие при нажатии
                        },
                        child: const Text(
                          'Регистрация',
                          style: TextStyle(
                              color: Colors.white, // Цвет текста
                              fontWeight: FontWeight.w700,
                              decoration:
                                  TextDecoration.underline, // Подчеркивание
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
