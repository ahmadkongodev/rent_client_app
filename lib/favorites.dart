import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'constantes.dart';
import 'models/product.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteProduts.isEmpty
          ? const Center(
              child: Text(
                  "You dont't mark a product as your favorite for the moment"),
            )
          : ListView.builder(
              itemCount: favoriteProduts.length,
              itemBuilder: (BuildContext context, int index) {
                Product produit = favoriteProduts[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
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
                                right: 5,
                                child: Text(
                                  "${produit.prix} FCFA",
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 5,
                                child: IconButton(
                                    onPressed: () {
                                      favoriteProduts.remove(produit);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Favorites()),
                                      );
                                    },
                                    icon: const Icon(Icons.dangerous)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
