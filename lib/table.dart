import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:open/models/product.dart';
import 'package:open/services/product_service.dart';

import 'constantes.dart';
import 'home_page.dart';
import 'models/api_response.dart';
import 'models/produit_panier.dart';

class Tables extends StatefulWidget {
  const Tables({super.key});

  @override
  State<Tables> createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  List<dynamic> listeTables = [];
  int _quantiteLouer = 1;
  bool like = false;
  Future<void> _getTables() async {
    ApiResponse response = await getTables();
    if (response.error == null) {
      setState(() {
        listeTables = response.data as List<dynamic>;
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
    _getTables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tables'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: const Color.fromARGB(255, 229, 222, 222),
      body: ListView.builder(
        itemCount: listeTables.length,
        itemBuilder: (BuildContext context, int index) {
          Product table = listeTables[index];
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
                            "${table.image}",
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
                                  if (!favoriteProduts.contains(table)) {
                                    favoriteProduts.add(table);
                                  }
                                } else {
                                  try {
                                    if (favoriteProduts.contains(table)) {
                                      favoriteProduts.remove(table);
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              });
                            },
                           icon: favoriteProduts.contains(table)
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
                            "${table.prix} FCFA",
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
                const SizedBox(
                  width: 20,
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
                              id_produit: table.id,
                              image: table.image,
                              nom: table.nom,
                              quantite_louer: _quantiteLouer,
                              prix: table.prix,
                              total: table.prix! * _quantiteLouer,
                              quantite_initial: table.quantite,
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
