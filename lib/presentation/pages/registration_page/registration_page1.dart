import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD8ECFF),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 450,
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
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Регистрация",
                            style: TextStyle(
                                fontSize: 31,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(
                          height: 70,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            hintText: '   Email',
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
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
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
                        const SizedBox(height: 10),
                         TextField(
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 20.0),
                            hintText: '   Повторите пароль',
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
                          onPressed: () {},
                          child: const Text('Логин',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xFF313131),
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
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
