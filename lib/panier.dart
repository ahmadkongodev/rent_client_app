import 'package:flutter/material.dart';
import 'package:open/constantes.dart';
import 'package:open/models/produit_panier.dart';
import 'package:open/services/client_service.dart';
import 'package:open/services/location_service.dart';

import 'home_page.dart';
import 'models/api_response.dart';
import 'services/product_service.dart';

class Panier extends StatefulWidget {
  const Panier({
    super.key,
  });
  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  int totalAPayer = 0;
  int total() {
    for (var i = 0; i < listeProduitPanier.length; i++) {
      totalAPayer = totalAPayer + listeProduitPanier[i].total!;
    }
    return totalAPayer;
  }

  @override
  void initState() {
    // TODO: implement initState
    total();
    super.initState();
  }

  void _insertLocation(String idProduit, int quantiteLouer) async {
    String idClient = await getClientId();
    ApiResponse response = await insertLocation(
        DateTime.now().add(Duration(days: 7)),
        idClient,
        idProduit,
        quantiteLouer);
    if (response.error == null) {
      print("ok");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  void _updateProduct(
    String idProduit,
    int quantiteInitial,
    int quantiteLouer,
  ) async {
    ApiResponse response =
        await updateProductQuantity(idProduit, quantiteInitial, quantiteLouer);
    if (response.error == null) {
      if (quantiteInitial - quantiteLouer < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("la quantite disponible n'est pas suffisante"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panier"),
      ),
      body: ListView.builder(
        itemCount: listeProduitPanier.length,
        itemBuilder: (BuildContext context, int index) {
          ProductBasket produit = listeProduitPanier[index];
          print(produit.total);
          return ListTile(
            leading: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                  ),
                  child: Image.network(
                    "${produit.image}",
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 2,
                  child: CircleAvatar(
                    radius: 11,
                    child: Text(
                      "${produit.quantite_louer} ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            title: Text("${produit.nom}"),
            subtitle: Text(" prix:${produit.prix} total: ${produit.total}"),
            trailing: IconButton(
                onPressed: () {
                  listeProduitPanier.remove(produit);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Panier()));
                },
                icon: const Icon(Icons.dangerous)),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Le Total A Payer est de: $totalAPayer FCFA"),
            ElevatedButton(
              onPressed: () async {
                try {
                  for (var i = 0; i < listeProduitPanier.length; i++) {
                    //on verifie si la quantite disponible est suffisante avant d'inserer la location
                    try {
                      _updateProduct(
                          listeProduitPanier[i].id_produit!,
                          listeProduitPanier[i].quantite_initial!,
                          listeProduitPanier[i].quantite_louer!);
                      _insertLocation(listeProduitPanier[i].id_produit!,
                          listeProduitPanier[i].quantite_louer!);
                    } catch (e) {
                      print(e);
                    }
                  }

                  listeProduitPanier = [];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Merci pour votre confiance, veuillez ramener les effets apres 7 jours'),
                    ),
                  );
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false);
                } catch (e) {}
              },
              child: const Text("Payer"),
            ),
          ],
        ),
      ),
    );
  }
}
