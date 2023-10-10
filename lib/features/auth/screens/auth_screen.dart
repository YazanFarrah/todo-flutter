import 'package:flutter/material.dart';
import 'package:todo_flutter/features/auth/services/auth.dart';
import 'package:todo_flutter/common/widgets/custom_button.dart';
import 'package:todo_flutter/common/widgets/custom_textfield.dart';
import 'package:todo_flutter/constants/global_variables.dart';

enum Auth { signIn, signUp }

class AuthScreen extends StatefulWidget {
  static const routName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;
  bool _showPassword = true;

  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthServices authServices = AuthServices();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void signUpUser() {
    authServices.signUpUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text);
  }

  void signInUser() {
    authServices.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:
              const BoxDecoration(gradient: GlobalVariables.appBarGradient),
        ),
        centerTitle: true,
        title: const Text(
          'Todo by Yaz',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        tileColor: _auth == Auth.signUp
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        title: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Create account. ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'New to Todo?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: Radio(
                            activeColor: GlobalVariables.secondaryColor,
                            value: Auth.signUp,
                            groupValue: _auth,
                            onChanged: (Auth? val) {
                              setState(() {
                                _auth = val!;
                                _showPassword = true;
                              });
                            }),
                      ),
                      if (_auth == Auth.signUp)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: GlobalVariables.backgroundColor,
                          child: Form(
                            key: _signUpFormKey,
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _nameController,
                                  hintText: 'Name',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  isPass: _showPassword,
                                  suffixIcon: IconButton(
                                    icon: _showPassword
                                        ? const Icon(Icons.visibility_off,
                                            color: GlobalVariables
                                                .greyBackgroundColor)
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                    text: 'Sign Up',
                                    onTap: () {
                                      if (_signUpFormKey.currentState!
                                          .validate()) {
                                        signUpUser();
                                      }
                                    })
                              ],
                            ),
                          ),
                        ),
                      ListTile(
                        tileColor: _auth == Auth.signIn
                            ? GlobalVariables.backgroundColor
                            : GlobalVariables.greyBackgroundColor,
                        title: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sign in. ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Already on Todo?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        leading: Radio(
                          activeColor: GlobalVariables.secondaryColor,
                          value: Auth.signIn,
                          groupValue: _auth,
                          onChanged: (Auth? val) {
                            setState(() {
                              _auth = val!;
                              _showPassword = true;
                            });
                          },
                        ),
                      ),
                      if (_auth == Auth.signIn)
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: GlobalVariables.backgroundColor,
                          child: Form(
                            key: _signInFormKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: 'Email',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  isPass: _showPassword,
                                  suffixIcon: IconButton(
                                    icon: _showPassword
                                        ? const Icon(Icons.visibility_off,
                                            color: GlobalVariables
                                                .greyBackgroundColor)
                                        : const Icon(
                                            Icons.visibility,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                    text: 'Sign In',
                                    onTap: () {
                                      if (_signInFormKey.currentState!
                                          .validate()) {
                                        signInUser();
                                      }
                                    })
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        indent: 10,
                        thickness: 1.5,
                        endIndent: 10,
                      ),
                      const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Conditions of Use',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'Privacy Notice',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'Help',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '1996-2023, Test.com, Inc, or its affiliates',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
