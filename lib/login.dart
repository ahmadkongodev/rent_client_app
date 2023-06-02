import 'package:flutter/material.dart';
import 'package:open/models/client.dart';
import 'package:open/services/client_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constantes.dart';
import 'home_page.dart';
import 'models/api_response.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool hideSick = true;
  void _loginClient() async {
    ApiResponse response =
        await loginClient(txtUsername.text, txtPassword.text);
    if (response.error == null) {
      _savedAndRedirectToHome(response.data as Client);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _savedAndRedirectToHome(Client client) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('clientId', client.id ?? "");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: const Icon(
              Icons.account_circle_rounded,
              size: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: txtUsername,
                    validator: (value) => value!.isEmpty
                        ? "Le nom d'utilisateur is required"
                        : null,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.account_circle_rounded,
                      ),
                      labelText: "username",
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  TextFormField(
                    obscureText: hideSick,
                    controller: txtPassword,
                    validator: (value) =>
                        value!.length < 6 ? '6 caractere au minimum' : null,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                            hideSick ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            hideSick = !hideSick;
                          });
                        },
                      ),
                      labelText: "password",
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('loading... '),
                          ),
                        );
                        setState(() {
                          _loginClient();
                        });
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                         padding: const EdgeInsets.symmetric(vertical: 10)),
                    child: const Text(
                      "login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  kloginRegisterHint("Don't have an account?", 'Register', () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                        (route) => false);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
