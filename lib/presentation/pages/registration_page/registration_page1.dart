import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

class RegistrationScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD8ECFF),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              const SizedBox(height: 60),
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
                        const Text("Регистрация",
                            style: TextStyle(
                                fontSize: 31,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(
                          height: 40,
                        ),
                        TextField(
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                          height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                               EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
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
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                          height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
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
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                          height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                               EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
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
                        const SizedBox(height: 10),
                        TextField(
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                         height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
                            hintText: '   Логин',
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
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15), //Уменьшил padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const SizedBox(
                            width: 250, // Укажите максимальную ширину
                            child: AutoSizeText(
                              'Зарегистрироваться',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF313131),
                                fontWeight: FontWeight.w700,
                              ),
                              minFontSize: 12,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
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
      ),
    );
  }
}
