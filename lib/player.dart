import 'package:bassdrive_streamer/music_player.dart';
import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final String url;
  final String title;

  const Player({this.url, this.title});

  @override
  build(BuildContext context) {
    debugPrint('Launching player with url: $url');
    return new MusicPlayer(
      onError: (e) {
        Scaffold.of(context).showSnackBar(
              new SnackBar(
                content: new Text(e),
              ),
            );
      },
      onSkipPrevious: () {},
      onSkipNext: () {},
      onCompleted: () {},
      textColor: Colors.white,
      url: url,
      title: Text(
        title,
        textAlign: TextAlign.center,
        textScaleFactor: 1.5,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
