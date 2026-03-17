import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover Movies"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              const TextField(
                decoration: InputDecoration(
                  hintText: "Search for a movie...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20), // Spacing

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Box 1
                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Dune")),
                  ),

                  // Box 2
                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Batman")),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Box 3
                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Spider-Man")),
                  ),

                  Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300],
                    child: const Center(child: Text("Joker")),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}