import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:open/home_page.dart';
import 'package:open/login.dart';
import 'package:open/models/client.dart';
import 'package:open/services/client_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constantes.dart';
import 'models/api_response.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //bool loading = false;

  void _registerClient() async {
    ApiResponse response = await registerClient(
        nomController.text,
        prenomController.text,
        usernameController.text,
        passwordController.text,
        phoneController.text,
        addressController.text);
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
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [
            TextFormField(
              controller: nomController,
              validator: (value) => value!.isEmpty ? 'le nom est requis' : null,
              decoration: kInputDecoration('nom'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: prenomController,
              validator: (value) =>
                  value!.isEmpty ? 'le prenom est requis' : null,
              decoration: kInputDecoration('prenom'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: usernameController,
              validator: (value) =>
                  value!.isEmpty ? "le nom d'utilisateur est requis" : null,
              decoration: kInputDecoration('username'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: phoneController,
              validator: (value) =>
                  value!.isEmpty ? 'Le numero est requis' : null,
              decoration: kInputDecoration('phone'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: true,
              controller: passwordController,
              validator: (value) =>
                  value!.length < 6 ? '6 caracteres au minimum ' : null,
              decoration: kInputDecoration('password'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: addressController,
              validator: (value) =>
                  value!.isEmpty ? "l'addresse est requise" : null,
              decoration: kInputDecoration('address'),
            ),
            TextButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  setState(() {
                    _registerClient();
                  });
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor:Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 10)),
              child: const Text(
                "register",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            kloginRegisterHint("Already have an account?", 'Login', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false);
            }),
          ],
        ),
      ),
    );
  }
}
