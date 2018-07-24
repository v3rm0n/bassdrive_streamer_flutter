import 'package:bassdrive_streamer/loader.dart';
import 'package:bassdrive_streamer/show.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class DayItem {
  final String name;
  final String href;

  const DayItem(this.name, this.href);
}

class Day extends StatelessWidget {
  final String day;
  final String url;
  final List<DayItem> items;

  const Day({this.items, this.day, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(day)),
      body: SafeArea(
        child: ListView(
            children: items.map<Widget>((item) {
          return ListTile(
              leading: Icon(Icons.queue_music),
              title: Text(item.name),
              onTap: () {
                if (item.href == '/') {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    debugPrint('Showing show: $url/${item.href}');
                    return FutureBuilder<http.Response>(
                      future: http.get('$url/${item.href}'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loader(name: item.name);
                        }
                        final response = snapshot.data;
                        final document = parse(response.body);
                        final list = document.getElementsByTagName('ul')[0];
                        return Show(
                            show: item.name,
                            url: '$url/${item.href}',
                            items: list.children
                                .map<ShowItem>((e) {
                                  if (e.text.trim() == 'Parent Directory') {
                                    return null;
                                  }
                                  return ShowItem(
                                      e.text, e.firstChild.attributes['href']);
                                })
                                .where((e) => e != null)
                                .toList());
                      },
                    );
                  }));
                }
              });
        }).toList()),
      ),
    );
  }
}
