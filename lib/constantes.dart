import 'package:flutter/material.dart';

import 'models/produit_panier.dart';

const baseURL = 'http://192.168.134.117:3000';
const productURL = '$baseURL/products';
const clientURL = '$baseURL/clients';
const locationURL = '$baseURL/locations';

List<dynamic> favoriteProduts = [];
List<ProductBasket> listeProduitPanier = [];
Row kloginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(
          label,
          style: const TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),
        ),
        onTap: () => onTap(),
      ),
    ],
  );
}

InputDecoration kInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: const EdgeInsets.all(10),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.black),
    ),
  );
}
