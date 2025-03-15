import 'package:event_horizon/presentation/pages/profile_page/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

void CreateUserWithLoginEmailAndPassword({required String email,required String password, required BuildContext context,}) async 
{
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
      
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Пользователь зарегестрирован успешно!')),
    );

    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));

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
                        const SizedBox(height: 40),
                        TextField(
<<<<<<< HEAD
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
=======
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                          height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                               EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
>>>>>>> 516deb1511c8698d08ab3910a2b5b51f4d2e8f07
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
<<<<<<< HEAD
                          controller: _passwordController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
=======
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                          height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
>>>>>>> 516deb1511c8698d08ab3910a2b5b51f4d2e8f07
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
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 10),
                        TextField(
<<<<<<< HEAD
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
=======
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                          height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                               EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
>>>>>>> 516deb1511c8698d08ab3910a2b5b51f4d2e8f07
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
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        const SizedBox(height: 10),
                        TextField(
<<<<<<< HEAD
                          controller: _loginController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0),
=======
                           cursorHeight: 25, // Высота курсора
                          strutStyle: const StrutStyle(
                         height: 2.5, // Высота строки
                        ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
>>>>>>> 516deb1511c8698d08ab3910a2b5b51f4d2e8f07
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
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword = _confirmPasswordController.text.trim();
                            final login = _loginController.text.trim();

                            if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || login.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Пожалуйста, заполните все поля')),
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Пароли не совпадает')),
                              );
                              return;
                            }

                            CreateUserWithLoginEmailAndPassword(
                              email: email,
                              password: password,
                              context: context,
                            );
                          },
                          child: const SizedBox(
                            width: 250,
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
