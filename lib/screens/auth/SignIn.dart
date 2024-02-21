// import 'package:bai_3/Model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../model/UserModel.dart';
import '../../db/Auth_Firebase.dart';

final checkFormProvider = StateProvider<bool>((ref) => false);

class SignInPage extends ConsumerWidget {
  SignInPage({super.key});

  final form = FormGroup({
    'email': FormControl<String>(
        validators: [Validators.required, Validators.email]),
    'password': FormControl<String>(
      validators: [Validators.required],
    ),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                      decoration:
                          const BoxDecoration(color: Color(0xFF4880FF))),
                  const Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      )),
                  Positioned(
                    top: 60,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            // Bo góc bên trái trên
                            topRight: Radius.circular(20.0),
                          )),
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/signin.png',
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                              ),
                              singUp(context, ref, form),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

Widget singUp(BuildContext context, WidgetRef ref, FormGroup form) {
  final auth = Auth_Firebase();
  final check = ref.watch(checkFormProvider);
  return Column(
    children: [
      ReactiveFormBuilder(
        form: () => form,
        builder: (context, _, __) {
          return Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  form.valid
                      ? ref.read(checkFormProvider.notifier).state = true
                      : ref.read(checkFormProvider.notifier).state = false;
                },
                style: const TextStyle(fontSize: 18.0),
                validationMessages: {
                  'required': (error) => 'The email must not be empty',
                  'email': (error) => 'The email value must be a valid email'
                },
              ),
              const SizedBox(height: 20),
              ReactiveTextField<String>(
                formControlName: 'password',
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                style: const TextStyle(fontSize: 18.0),
                obscureText: true,
                onChanged: (value) {
                  form.valid
                      ? ref.read(checkFormProvider.notifier).state = true
                      : ref.read(checkFormProvider.notifier).state = false;
                },
                validationMessages: {
                  'required': (error) => 'The password must not be empty'
                },
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4880FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: check
                        ? () async {
                            if (form.valid) {
                              await auth
                                  .signInWithEmailAndPassword(
                                      context,
                                      UserModel(
                                          email: form.control('email').value,
                                          password: form.control('password').value))
                                  .then((value) => {
                                        if (value == true)
                                          {_showMyDialog(context)}
                                      });
                            }
                          }
                        : null,
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          );
        },
      ),
      InkWell(
        onTap: () {
          context.go('/SignUp');
        },
        child: RichText(
          text: const TextSpan(
            text: "Don't have userModel? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Sign Up!',
                style: TextStyle(
                    color: Color(0xFF4880FF), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Thông báo'),
        content: const SingleChildScrollView(
            child: Text('Tài khoản hoặc mật khẩu sai')),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
