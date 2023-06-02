import 'package:flutter/material.dart';
import 'package:open/home_page.dart';
import 'package:open/services/client_service.dart';

import 'constantes.dart';
import 'models/api_response.dart';
import 'models/client.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  //bool loading = false;
  Client? client;

  void _showClientProfile() async {
    ApiResponse response = await showClient();
    if (response.error == null) {
      setState(() {
        client = response.data as Client;
        nomController.text = client!.nom.toString();
        prenomController.text = client!.prenom.toString();
        usernameController.text = client!.username.toString();
        phoneController.text = client!.numero.toString();
        addressController.text = client!.address.toString();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _updateClient() async {
    ApiResponse response = await updateClient(
        nomController.text,
        prenomController.text,
        usernameController.text,
        phoneController.text,
        addressController.text);
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated Successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    _showClientProfile();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
        const Icon(
          Icons.account_circle_rounded,
          size: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: nomController,
                  validator: (value) =>
                      value!.isEmpty ? 'le nom est requis' : null,
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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: addressController,
                  validator: (value) =>
                      value!.isEmpty ? "l'addresse est requise" : null,
                  decoration: kInputDecoration('address'),
                ),
                 const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      setState(() {
                        _updateClient();
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(15)),
                  child: const Text(
                    "update Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
