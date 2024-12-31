import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo/constants/flushbar.dart';
import 'package:todo/controller/auth_controller.dart';
import 'package:todo/view/screen_home_view.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authProvider.isLogin ? 'Login' : 'Sign up',
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Form(
          key: authProvider.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                authProvider.isLogin
                    ? const SizedBox()
                    : TextFormField(
                        controller: authProvider.name,
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Enter your name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: authProvider.emailAddress,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: authProvider.password,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Rounded borders
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                authProvider.isLogin
                    ? const SizedBox()
                    : TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters long.';
                          } else if (value != authProvider.password.text) {
                            return 'Enter same password';
                          }
                          return null;
                        },
                      ),
                Row(
                  mainAxisAlignment: authProvider.isLogin
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        authProvider.isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                        style: const TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        authProvider.changeScreen();
                        authProvider.clearValueinController();
                      },
                    ),
                    authProvider.isLogin
                        ? const SizedBox(
                            width: 15,
                          )
                        : const SizedBox(),
                    authProvider.isLogin
                        ? InkWell(
                            onTap: () async {
                              if (authProvider.emailAddress.text.isEmpty) {
                                showFlushbar(context,
                                    'Enter your email address to reset your password');
                              } else {
                                bool result =
                                    await authProvider.forgotPassword(context);
                                if (result) {
                                  showFlushbar(context,
                                      'You can reset your password by opening the link that is sent to your registered email ID');
                                }
                              }
                            },
                            child: const Text(
                              'Forgot password ?',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 03,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 20.0),
                    ),
                    child: authProvider.loading
                        ? const CupertinoActivityIndicator(color: Colors.black)
                        : Text(
                            authProvider.isLogin ? 'Login' : 'Sign Up',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                    onPressed: () async {
                      if (authProvider.formKey.currentState!.validate()) {
                        if (authProvider.isLogin) {
                          bool result = await authProvider.login(context);
                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenHomeView(
                                  index: 0,
                                ),
                              ),
                              (route) => false,
                            );
                            authProvider.clearValueinController();
                          }
                        } else {
                          bool result = await authProvider.userSigup(context);
                          if (result) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScreenHomeView(
                                  index: 0,
                                ),
                              ),
                              (route) => false,
                            );
                            authProvider.clearValueinController();
                            authProvider.changeScreen();
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
