import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';
import 'login.dart';
import 'signup.dart';
import 'favorites.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Future<Map<String, dynamic>> _fetchUserProfile(String token) async {
    final url = Uri.parse("https://pokemonsapi.herokuapp.com/profile");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    bool isLoggedIn = authProvider.token != null;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          isLoggedIn
              ? FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserProfile(authProvider.token!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const UserAccountsDrawerHeader(
                  accountEmail: Text("Loading..."),
                  accountName: Text("Loading..."),
                  currentAccountPicture: CircleAvatar(),
                );
              } else if (snapshot.hasError) {
                return const UserAccountsDrawerHeader(
                  accountEmail: Text("Error loading profile"),
                  accountName: Text("Error"),
                  currentAccountPicture: CircleAvatar(),
                );
              } else if (snapshot.hasData) {
                final profile = snapshot.data!;
                return UserAccountsDrawerHeader(
                  accountEmail: Text(profile['email'] ?? 'No email'),
                  accountName: const Text(''),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      profile['imgURL'] ?? 'https://www.example.com/default-avatar.png',
                    ),
                  ),
                );
              } else {
                return const UserAccountsDrawerHeader(
                  accountEmail: Text("No data found"),
                  accountName: Text(""),
                  currentAccountPicture: CircleAvatar(),
                );
              }
            },
          )
              : const UserAccountsDrawerHeader(
            accountEmail: Text(""),
            accountName: Text(""),
            currentAccountPicture: CircleAvatar(),
          ),
          ListTile(
            title: const Text('Home'),
            selected: true,
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          if (isLoggedIn) ...[
            ListTile(
              title: const Text('Favorites'),
              leading: const Icon(Icons.favorite),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Favorites()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () {
                authProvider.logout();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              },
            ),
          ] else ...[
            ListTile(
              title: const Text('Login'),
              leading: const Icon(Icons.login),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Login()));
              },
            ),
            ListTile(
              title: const Text('Signup'),
              leading: const Icon(Icons.person_add),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Signup()));
              },
            ),
          ],
        ],
      ),
    );
  }
}
