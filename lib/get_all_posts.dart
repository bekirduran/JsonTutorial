import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_tutorial/model/Post.dart';

class GetAllPost extends StatefulWidget {
  @override
  _GetAllPostState createState() => _GetAllPostState();
}

class _GetAllPostState extends State<GetAllPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Post"),
      ),
      body: FutureBuilder(
          future: getAllPostFunc(),
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var posts = snapshot.data[index];

                  return ExpansionTile(
                    leading: CircleAvatar(
                      child: Text(posts.id.toString()),
                    ),
                    title: Text(posts.title),
                    trailing: Icon((Icons.arrow_circle_down)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          subtitle: Text(posts.body),
                        ),
                      )
                    ],
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  // Function fetching all posts data.
  Future<List<Post>> getAllPostFunc() async {
    var response = await http.get("https://jsonplaceholder.typicode.com/posts");
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => Post.fromJsonMap(e))
          .toList();
    } else {
      throw Exception("Failed with Code : ${response.statusCode}");
    }
  }
}
