import 'package:flutter/material.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Watchlist"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.movie, color: Colors.grey, size: 40),
              title: Text("The Shawshank Redemption", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Added 2 days ago"),
              trailing: Icon(Icons.delete, color: Colors.red),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.movie, color: Colors.grey, size: 40),
              title: Text("The Godfather", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Added 2 days ago"),
              trailing: Icon(Icons.delete, color: Colors.red),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.movie, color: Colors.grey, size: 40),
              title: Text("Pulp Fiction", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Added 2 days ago"),
              trailing: Icon(Icons.delete, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}