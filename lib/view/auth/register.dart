import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodapp_freelance/main.dart';
import 'package:foodapp_freelance/view/auth/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: height * .25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/topImage.png'),
                      fit: BoxFit.cover,
                    ),
                  )),
              Center(
                child: Lottie.asset('assets/food.json'),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "WELCOME TO \nHEALTHY FOODS",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: emailController,
                        decoration: customInputDecoration("E-mail"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: passwordController,
                        decoration: customInputDecoration("Password"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: TextButton(
                            onPressed: () {
                              signUp();
                            },
                            child: Container(
                              height: 50,
                              width: 120,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.purple.shade400),
                              child: const Center(
                                child: Text(
                                  "SıgnUp",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                              ),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: FloatingActionButton.extended(
                      backgroundColor: Colors.purple.shade400,
                      onPressed: () {
                        googleLogin();
                      },
                      label: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.google,
                          ),
                          const Text("  Sign with Google"),
                        ],
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: buildHaveAccount(context)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration customInputDecoration(String hintText) {
    return InputDecoration(
      hintStyle: const TextStyle(color: Colors.white),
      hintText: hintText,
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
        color: Colors.grey,
      )),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
        color: Colors.grey,
      )),
    );
  }

  RichText buildHaveAccount(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(color: Colors.purple, fontSize: 16),
            text: "Have Account? ",
            children: [
          TextSpan(
              // hesabın olmaması burda
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
              text: 'Sign In',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.white,
              )),
        ]));
  }

  Future signUp() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<UserCredential> googleLogin() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
