import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class MusicPlayer extends StatefulWidget {
  /// The URL of the audio file to play.
  final String url;

  /// The title of the song being currently played.
  final Widget title;

  /// Passed to [AudioPlayer].
  final bool isLocal;

  /// The color to paint the icons, text, and slider with.
  final Color textColor;

  /// The volume to play the file at.
  final double volume;

  /// Called when an error occurs.
  final Function(String) onError;

  /// Playback event handlers.
  final Function() onCompleted, onSkipPrevious, onSkipNext;

  /// The minimum amount of time allowed to pass before pressing the `skip_previous` button will
  /// restart the current song, rather than skipping back to a previous one.
  ///
  /// Default: `3 seconds`.
  final Duration minRestartDuration;

  final Key key;

  const MusicPlayer(
      {@required this.onError,
      @required this.onCompleted,
      @required this.onSkipPrevious,
      @required this.onSkipNext,
      @required this.url,
      @required this.title,
      this.minRestartDuration: const Duration(seconds: 3),
      this.textColor,
      this.isLocal: false,
      this.volume: 1.0,
      this.key});

  @override
  State<StatefulWidget> createState() {
    return new MusicPlayerState();
  }
}

class MusicPlayerState extends State<MusicPlayer> {
  AudioPlayer audioPlayer;
  bool isPlaying = true;
  Duration duration, position;
  double value;

  @override
  initState() {
    super.initState();
    audioPlayer = new AudioPlayer();
    audioPlayer
      ..play(
        widget.url,
        isLocal: widget.isLocal,
        volume: widget.volume,
      )
      ..completionHandler = widget.onCompleted
      ..errorHandler = widget.onError
      ..durationHandler = (duration) {
        setState(() {
          this.duration = duration;

          if (position != null) {
            this.value = (position.inSeconds / duration.inSeconds);
          }
        });
      }
      ..positionHandler = (position) {
        setState(() {
          this.position = position;

          if (duration != null) {
            this.value = (position.inSeconds / duration.inSeconds);
          }
        });
      };
  }

  @override
  deactivate() {
    audioPlayer.stop();
    super.deactivate();
  }

  String _durationToString(Duration d) {
    var parts = <int>[];

    // Add seconds
    parts.add(d.inSeconds % 60);

    // Add minutes
    if (d.inMinutes >= 1)
      parts.add(d.inMinutes % 60);
    else
      parts.add(0);

    // Hours?
    if (d.inHours >= 1) parts.add(d.inHours);

    return parts.reversed
        .map((p) {
          if (p < 10) return '0$p';
          return p.toString();
        })
        .join(':')
        .toString();
  }

  Widget _time(BuildContext context) {
    if (duration == null || position == null) {
      return const Divider(
        height: 16.0,
        color: Colors.transparent,
      );
    }

    var style = new TextStyle(color: widget.textColor);
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          _durationToString(position),
          style: style,
        ),
        new Text(
          _durationToString(duration),
          style: style,
        ),
      ],
    );
  }

  List<Widget> _hud(BuildContext context) {
    return [
      widget.title,
      const Divider(color: Colors.transparent),
      const Divider(
        color: Colors.transparent,
        height: 32.0,
      ),
      new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new IconButton(
              onPressed: () {
                if (position == null || position < widget.minRestartDuration)
                  widget.onSkipPrevious();
                else
                  audioPlayer.seek(Duration());
              },
              icon: new Icon(
                Icons.skip_previous,
                size: 32.0,
                color: widget.textColor,
              ),
            ),
            new IconButton(
              onPressed: () {
                if (isPlaying)
                  audioPlayer.pause();
                else {
                  audioPlayer.play(
                    widget.url,
                    isLocal: widget.isLocal,
                    volume: widget.volume,
                  );
                }

                setState(() => isPlaying = !isPlaying);
              },
              padding: const EdgeInsets.all(0.0),
              icon: new Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 48.0,
                color: widget.textColor,
              ),
            ),
            new IconButton(
              onPressed: widget.onSkipNext,
              icon: new Icon(
                Icons.skip_next,
                size: 32.0,
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ),
      new Slider(
        onChanged: (value) {
          if (duration != null) {
            var seconds = duration.inSeconds * value;
            audioPlayer.seek(Duration(seconds: seconds.toInt()));
          }
        },
        value: value ?? 0.0,
        activeColor: widget.textColor,
      ),
      new Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: _time(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: _hud(context),
    );
  }
}
