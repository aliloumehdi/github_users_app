
import 'package:flutter/material.dart';
import 'package:github_users_app/pages/users/users.page.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: Icon(
                Icons.search,
              ),
              title: const Text('Utilisateurs github'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context,"/users");
              },
            ),

          ],
        ),
      ),
      body: Center(
        child: Text('Home'),
      ),
    );
  }

}

