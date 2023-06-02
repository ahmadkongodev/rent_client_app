import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:open/services/product_service.dart';

import 'constantes.dart';
import 'home_page.dart';
import 'models/api_response.dart';
import 'models/product.dart';
import 'models/produit_panier.dart';

class Podium extends StatefulWidget {
  const Podium({super.key});

  @override
  State<Podium> createState() => _PodiumState();
}

class _PodiumState extends State<Podium> {
  List<dynamic> listePodiums = [];
  int _quantiteLouer = 1;
    bool like = false;

  Future<void> _getPodiums() async {
    ApiResponse response = await getPodiums();
    if (response.error == null) {
      setState(() {
        listePodiums = response.data as List<dynamic>;
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
    _getPodiums();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Podiums"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Color.fromARGB(255, 229, 222, 222),
      body: ListView.builder(
        itemCount: listePodiums.length,
        itemBuilder: (BuildContext context, int index) {
          Product podium = listePodiums[index];
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
                            "${podium.image}",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                 like = false;
                                like = !like;

                                if (like) {
                                  if (!favoriteProduts.contains(podium)) {
                                    favoriteProduts.add(podium);
                                  }
                                } else {
                                  try {
                                    if (favoriteProduts.contains(podium)) {
                                      favoriteProduts.remove(podium);
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              });
                            },
                           icon: favoriteProduts.contains(podium)
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
                            "${podium.prix} FCFA",
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
                              id_produit: podium.id,
                              image: podium.image,
                              nom: podium.nom,
                              quantite_louer: _quantiteLouer,
                              prix: podium.prix,
                              total: podium.prix! * _quantiteLouer,
                              quantite_initial: podium.quantite,
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
