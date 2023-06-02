import 'package:flutter/material.dart';
import 'package:open/services/product_service.dart';
import 'package:flutter_spinbox/material.dart';

import 'constantes.dart';
import 'home_page.dart';
import 'models/api_response.dart';
import 'models/product.dart';
import 'models/produit_panier.dart';

class Chaises extends StatefulWidget {
  const Chaises({super.key});

  @override
  State<Chaises> createState() => _ChaisesState();
}

class _ChaisesState extends State<Chaises> {
  List<dynamic> listeChaises = [];

  bool like = false;
  int _quantiteLouer = 1;
  Future<void> _getChairs() async {
    ApiResponse response = await getChairs();
    if (response.error == null) {
      setState(() {
        listeChaises = response.data as List<dynamic>;
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
    _getChairs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("chaises"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Color.fromARGB(255, 229, 222, 222),
      body: ListView.builder(
        itemCount: listeChaises.length,
        itemBuilder: (BuildContext context, int index) {
          Product chaise = listeChaises[index];
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
                            "${chaise.image}",
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
                                  if (!favoriteProduts.contains(chaise)) {
                                    favoriteProduts.add(chaise);
                                  }
                                } else {
                                  try {
                                    if (favoriteProduts.contains(chaise)) {
                                      favoriteProduts.remove(chaise);
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              });
                            },
                            icon:  favoriteProduts.contains(chaise)
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
                            "${chaise.prix} FCFA",
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
                              id_produit: chaise.id,
                              image: chaise.image,
                              nom: chaise.nom,
                              quantite_louer: _quantiteLouer,
                              prix: chaise.prix,
                              total: chaise.prix! * _quantiteLouer,
                              quantite_initial: chaise.quantite,
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
                        color: Colors.blueGrey,
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
