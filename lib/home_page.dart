import 'package:flutter/material.dart';
import 'package:open/home.dart';
import 'package:open/login.dart';
import 'package:open/settings.dart';
import 'favorites.dart';
import 'services/client_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Rent App"),
            IconButton(
                onPressed: () async{
                  await deleteClientId();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        backgroundColor: Colors.black87,
      ),
      body: current == 0
          ? const Home()
          : current == 1
              ? const Favorites()
              : const Settings(),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoris",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
            ),
          ],
          currentIndex: current,
          onTap: (value) {
            setState(() {
              current = value;
            });
          },
        ),
      ),
    );
  }
}
