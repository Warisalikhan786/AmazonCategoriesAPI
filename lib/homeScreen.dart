// ignore_for_file: file_names, avoid_unnecessary_containers, unused_import, unused_local_variable, avoid_print, empty_catches, prefer_const_constructors, duplicate_ignore

import 'dart:convert';

import 'package:amazon_api/constant.dart';
import 'package:amazon_api/subcategory_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "$baseURL?api_key=$kAPIKEY&domain=amazon.com&type=standard";

  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];

  Future getAmazonCategory() async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          categoryMap = jsonDecode(response.body);
          cateList = categoryMap['categories'];
        });
        print(cateList[0]['name'].toString());
      }
    } catch (e) {
      return Text("Error $e");
    }
    return cateList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Amazon API"),
          centerTitle: true,
        ),
        body: Container(
          // ignore: prefer_const_constructors
          child: ListView.builder(
            itemCount: cateList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CategoryScreen(
                        name: cateList[index]['name'],
                        id: cateList[index]['id'],
                      );
                    },
                  ));
                },
                child: ListTile(
                  title: Text("${cateList[index]['name']}"),
                  subtitle: Text("${cateList[index]['id']}"),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // isExtended: true,
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () async {
            await getAmazonCategory();
          },
        ),
      ),
    );
  }
}
