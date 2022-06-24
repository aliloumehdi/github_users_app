
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class _GitRepositoriesPageState extends State<GitRepositoriesPage>{

  String URL="https://api.github.com/";
  dynamic dataRepositories=[];
@override
  void initState() {

    super.initState();
    _loadRepositories();
}
 void _loadRepositories() async{
   http.Response response=await http.get(Uri.parse("${URL}users/${widget.login}/repos"));
    if(response.statusCode==200){
setState(() {
  dataRepositories=json.decode(response.body);
});
    }
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Repositories ${widget.login}"),
        actions: [
          CircleAvatar(backgroundImage: NetworkImage(widget.avatarURL),)
        ],
      ),

      body: Center(
        child: ListView.separated(itemBuilder: (context, index) => ListTile(
          title: Text("${dataRepositories[index]['name']}"),
        ),
            separatorBuilder: (context, index) => Divider(
                height: 2,
                color: Colors.deepOrange),
            itemCount: dataRepositories.length),
      ),
    );
  }

}

class GitRepositoriesPage extends StatefulWidget {
  String  login;
  String  avatarURL;
  GitRepositoriesPage(this.login,this.avatarURL);
  @override
  _GitRepositoriesPageState createState()  => _GitRepositoriesPageState();
}