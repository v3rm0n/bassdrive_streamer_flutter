import 'package:bassdrive_streamer/player.dart';
import 'package:flutter/material.dart';

class ShowItem {
  final String name;
  final String href;

  const ShowItem(this.name, this.href);
}

class Show extends StatelessWidget {
  final String show;
  final String url;
  final List<ShowItem> items;

  const Show({this.show, this.items, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(show)),
      body: SafeArea(
        child: ListView(
            children: items.map<Widget>((item) {
          return ListTile(
              leading: Icon(Icons.music_note),
              title: Text(item.name),
              onTap: () {
                if (item.href == '/') {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Container(
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new NetworkImage(
                              'https://i1.sndcdn.com/avatars-000193850344-9tgor1-t500x500.jpg'),
                          fit: BoxFit.scaleDown,
                          colorFilter: new ColorFilter.mode(
                            Colors.black54,
                            BlendMode.overlay,
                          ),
                        ),
                      ),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          title: Text(item.name),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.only(bottom: 48.0),
                          child: Player(
                            url: '$url${item.href}',
                            title: item.name,
                          ),
                        ),
                      ),
                    );
                  }));
                }
              });
        }).toList()),
      ),
    );
  }
}
