import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_users_app/pages/repositories/repositories.page.dart';
import 'package:http/http.dart' as http;
class UsersPage extends StatefulWidget {

  @override
  _UsersPageState createState()  => _UsersPageState();
}
class _UsersPageState extends State<UsersPage>{
  String query="";
  String URL="https://api.github.com/";
dynamic data=null;
int currentPage=0;
int totalPages=0;
int pageSize=20;
List<dynamic>items=[];
ScrollController scrollController=new ScrollController();
  TextEditingController queryTextEditingController=new TextEditingController();
  void _search (String q){
    print('entred');
    String SEARCH_URL= "https://api.github.com/search/users?q=${q}&per_page=$pageSize&page=$currentPage&size=$pageSize";
  print(SEARCH_URL);
    http.get(Uri.parse(SEARCH_URL)).then((response) {
    setState(() {
      data=json.decode(response.body);
items.addAll(data['items']);
      if(data['total_count']%pageSize==0){
        totalPages=data['total_count']~/pageSize;
      }
      else
        totalPages=(data['total_count']/pageSize).floor()+1;


    });

    print(data);
  }).catchError((err){
    print(err);
  });
  }
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        print("entrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrd");
        if(currentPage<totalPages-1)
        setState(() {
          print(currentPage);
          currentPage++;
          print("paaaaaaaaaaaaaaaage$currentPage");
          _search(query);
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Users => ${query} => ${currentPage+1}/ $totalPages"),
      ),

      body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: queryTextEditingController,
                          onChanged: (value){
                            setState(() {
                              query=queryTextEditingController.text;
                            });

                          },
                          decoration: InputDecoration(

                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.deepOrange)
                              )
                          ),
                        )
                    ),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      items=[];
                      currentPage=0;
                      query=queryTextEditingController.text;
                      _search(query);
                    });

                  }, icon: Icon(Icons.search,color: Colors.deepOrange,))
                ],
              ),
             Expanded(child:
             ListView.separated(
               separatorBuilder: (context, index) => Divider(height: 5,color: Colors.deepOrange),
               itemCount:items.length,
               controller: scrollController,
               itemBuilder: (context,index){
                 return ListTile(
                   onTap:() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GitRepositoriesPage(
                                  items[index]['login'],items[index]['avatar_url'])));
                  },
                     title:Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Row(
                           children: [
                             CircleAvatar(
                               backgroundImage: NetworkImage("${items[index]['avatar_url']}"),
                               radius: 40,
                             ),
                             SizedBox(width: 20,),
                             Text("${items[index]['login']}"),

                           ],
                         ),
                         CircleAvatar(
                           child: Text("${items[index]['score']}"),
                         ),
                       ],

                     )
                 );
               },
             )

             )
            ],
          )
        //Text('Users',style: Theme.of(context).textTheme.headline2,),
      ),
    );
  }

}
