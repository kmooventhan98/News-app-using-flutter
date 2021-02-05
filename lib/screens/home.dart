import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:news_app/screens/countries.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _defaultCountryCode = "in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NEWS 27'),
        leading: Icon(Icons.book_rounded),
        elevation: 0.0,
        actions: [
          FlatButton(
            onPressed: () async {
              var countrycode =
                  await Navigator.of(context).pushNamed(Countries.router);
              if (countrycode.toString().isNotEmpty) {
                setState(() {
                  _defaultCountryCode = countrycode;
                });
              }
            },
            child: Text(
              'COUNTRY',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: http.get(
            'http://newsapi.org/v2/top-headlines?country=$_defaultCountryCode&category=business&apiKey=f06f63add28947b7a3a91290b28863f7'),
        builder: (context, newsData) => newsData.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: json.decode(newsData.data.body)['articles'].length,
                itemBuilder: (context, index) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.network(
                            json.decode(newsData.data.body)['articles'][index]
                                    ['urlToImage'] ??
                                'https://icon2.cleanpng.com/20180605/ijl/kisspng-computer-icons-image-file-formats-no-image-5b16ff0d2414b5.0787389815282337411478.jpg',
                            loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 200.0,
                            width: double.infinity,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                          progress.expectedTotalBytes
                                      : null),
                            ),
                          );
                        }),
                        SizedBox(height: 15.0),
                        Text(
                          json.decode(newsData.data.body)['articles'][index]
                              ['title'],
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
