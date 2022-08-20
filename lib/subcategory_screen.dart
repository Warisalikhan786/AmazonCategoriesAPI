// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable, avoid_print, prefer_const_constructors, prefer_is_empty

import 'dart:convert';

import 'package:amazon_api/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  String? name;
  String? id;
  CategoryScreen({Key? key, this.name, this.id}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Map<String, dynamic> categoryMap = {};
  List<dynamic> cateList = [];

  Future getAmazonCategory() async {
    String url =
        "$baseURL?api_key=$kAPIKEY&domain=amazon.com&type=standard&parent_id=${widget.id}";
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
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getAmazonCategory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${widget.name}"),
        ),
        body: cateList.length > 0
            ? ListView.builder(
                itemCount: cateList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${cateList[index]['name']}"),
                    subtitle: Text("${cateList[index]['id']}"),
                  );
                })
            : Center(
                child: CupertinoActivityIndicator(radius: 20.0),
              ),
      ),
    );
  }
}
