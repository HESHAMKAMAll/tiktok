import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/controllers/auth_controller.dart';
import '../../widgets/text_input_field.dart';

enum _Auth { signIn, signUp }

class Auth extends StatefulWidget {
  Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  _Auth _auth = _Auth.signUp;
  Uint8List? _image;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var check = _auth == _Auth.signIn;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(check ? "Log in to TikTok" : "Sign up for TikTok",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: buttonColor)),
              // Text(check?"Login":"Sign Up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 25),
              if (check) const SizedBox(height: 72),
              if (!check)
                Stack(
                  children: [
                    _image == null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: const AssetImage('assets/images/man.png'),
                            backgroundColor: buttonColor,
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: buttonColor,
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: Consumer<AuthController>(
                        builder: (context, value, child) => CupertinoButton(
                          onPressed: () async {
                            Uint8List im = await value.pickImage(ImageSource.gallery);
                            setState(() {
                              _image = im;
                            });
                          },
                          padding: EdgeInsets.zero,
                          // onPressed: () => authController.pickImage(),
                          child: const Icon(Icons.add_a_photo, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              if (!check) const SizedBox(height: 15),
              if (!check)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextInputField(
                    controller: _usernameController,
                    hintText: "User Name",
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.text,
                  ),
                ),
              if (!check) const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  keyboardType: TextInputType.text,
                  isObscure: true,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Consumer<AuthController>(
                  builder: (context, value, child) {
                    if (context.read<AuthController>().isLoading) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: CupertinoButton(
                          onPressed: () {},
                          color: buttonColor,
                          child: const Text("Loading...", style: TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                      );
                    }
                    return CupertinoButton(
                      onPressed: () async {
                        setState(() {});
                        if (!check && _image != null) {
                          await value.signUp(_usernameController.text, _emailController.text, _passwordController.text, _image!, context);
                        } else if (check) {
                          await value.signIn(_emailController.text, _passwordController.text, context);
                        } else {
                          Get.snackbar('No Image', 'Please select an image');
                        }
                      },
                      color: buttonColor,
                      child: Text(check ? "Sign In" : "Sign Up", style: const TextStyle(color: Colors.white, fontSize: 20)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ), // signIn
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 100, child: Divider()),
              Text(" OR "),
              SizedBox(width: 100, child: Divider()),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<AuthController>(
                builder: (context, value, child) => CupertinoButton(
                  onPressed: () async {
                    try {
                      await value.signInWithGoogle();
                    } catch (e) {
                      Get.snackbar('Google', e.toString());
                    }
                  },
                  padding: EdgeInsets.zero,
                  // color: Colors.blue,
                  child: Image.asset("assets/images/google.png", height: 40),
                ),
              ),
              const SizedBox(width: 90),
              CupertinoButton(
                onPressed: () async {
                  // try {
                  //   await signInWithGoogle();
                  //   // ignore: use_build_context_synchronously
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
                  // } catch (error) {
                  //   // print("حدث خطأ أثناء تسجيل الدخول باستخدام Google: $error");
                  // }
                },
                padding: EdgeInsets.zero,
                // color: Colors.blue,
                child: const Icon(Icons.facebook, color: Colors.blue, size: 42),
              ),
            ],
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(check ? "Don't have an account? " : "Do have an account? ", style: const TextStyle(fontSize: 16)),
              CupertinoButton(
                onPressed: () {
                  setState(() {
                    if (check) {
                      _auth = _Auth.signUp;
                    } else {
                      _auth = _Auth.signIn;
                    }
                  });
                },
                padding: EdgeInsets.zero,
                child: Text(check ? "Sign Up." : "Sign In.", style: TextStyle(fontSize: 16, color: buttonColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
