import 'package:bassdrive_streamer/day.dart';
import 'package:bassdrive_streamer/loader.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';

class Home extends StatelessWidget {
  final String title;

  const Home({this.title});

  _listItem(BuildContext context, String day, String nr) => ListTile(
        leading: Icon(Icons.folder),
        title: Text(day),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            final base = 'https://archives.bassdrivearchive.com/$nr%20-%20$day';
            debugPrint('Showing day: $base');
            return FutureBuilder<Response>(
              future: get(base),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loader(name: day);
                }
                final response = snapshot.data;
                final document = parse(response.body);
                final list = document.getElementsByTagName('ul')[0];
                return Day(
                    day: day,
                    url: base,
                    items: list.children
                        .map<DayItem>((e) {
                          if (e.text.trim() == 'Parent Directory') {
                            return null;
                          } else {
                            return DayItem(
                                e.text.substring(0, e.text.length - 1),
                                e.firstChild.attributes['href']);
                          }
                        })
                        .where((e) => e != null)
                        .toList());
              },
            );
          }));
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SafeArea(
            child: ListView(
          children: <Widget>[
            _listItem(context, 'Monday', '1'),
            _listItem(context, 'Tuesday', '2'),
            _listItem(context, 'Wednesday', '3'),
            _listItem(context, 'Thursday', '4'),
            _listItem(context, 'Friday', '5'),
            _listItem(context, 'Saturday', '6'),
            _listItem(context, 'Sunday', '7'),
          ],
        )));
  }
}
