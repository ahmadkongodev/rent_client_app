import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:open/models/location.dart';
import 'package:open/services/product_service.dart';

import 'constantes.dart';
import 'home_page.dart';
import 'models/api_response.dart';
import 'models/product.dart';
import 'models/produit_panier.dart';

class Baches extends StatefulWidget {
  const Baches({super.key});

  @override
  State<Baches> createState() => _BachesState();
}

class _BachesState extends State<Baches> {
  List<dynamic> listeBaches = [];
  bool like = false;
  int _quantiteLouer = 1;
  Future<void> _getBaches() async {
    ApiResponse response = await getBaches();
    if (response.error == null) {
      setState(() {
        listeBaches = response.data as List<dynamic>;
      });
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
    _getBaches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Baches"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Color.fromARGB(255, 229, 222, 222),
      body: ListView.builder(
        itemCount: listeBaches.length,
        itemBuilder: (BuildContext context, int index) {
          Product bache = listeBaches[index];
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
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: const BoxDecoration(
                            color: Colors.black12,
                          ),
                          child: Image.network(
                            "${bache.image} ",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                like = !like;
                                if (like) {
                                  if (!favoriteProduts.contains(bache)) {
                                    favoriteProduts.add(bache);
                                  }
                                } else {
                                  try {
                                    if (favoriteProduts.contains(bache)) {
                                      favoriteProduts.remove(bache);
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              });
                            },
                           icon: favoriteProduts.contains(bache)
                                ? const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: 40.0,
                                  )
                                : const Icon(
                                    Icons.star_border,
                                    color: Colors.yellow,
                                    size: 40.0,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 5,
                          child: Text(
                            "${bache.prix} FCFA",
                            style: const TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: SpinBox(
                          min: 1,
                          max: 100,
                          value: 1,
                          onChanged: (value) {
                            setState(() {
                              _quantiteLouer = value.toInt();
                            });
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          listeProduitPanier.add(
                            ProductBasket(
                                id_produit: bache.id,
                                image: bache.image,
                                nom: bache.nom,
                                quantite_louer: _quantiteLouer,
                                prix: bache.prix, 
                                total: bache.prix!*_quantiteLouer, 
                                quantite_initial: bache.quantite,
                                ),
                          );
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            (route) => false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'product added successfully to the basket'),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width * 0.71,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: const Text(
                          "Ajouter au panier",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
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
