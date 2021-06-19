import 'package:core_tune/page/Home.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerAudio extends StatefulWidget {
  @override
  _PlayerAudioState createState() => _PlayerAudioState();
}

class _PlayerAudioState extends State<PlayerAudio> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  double screenWidth = 0;
  double screenHeight = 0;
  @override
  void initState() {
    super.initState();
    setupPlaylist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget audioImage(RealtimePlayingInfos realtimePlayingInfos) {
    return Container(
        height: screenWidth * 0.8,
        width: screenWidth * 0.8,
        child: Material(
          elevation: 18.0,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.network(
              realtimePlayingInfos.current!.audio.audio.metas.image!.path,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  Widget titleBar(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        realtimePlayingInfos.current!.audio.audio.metas.title!,
        style: TextStyle(
            fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Icon(
        Icons.favorite,
        color: Color(0xffe3eb6b),
      ),
    ]);
  }

  Widget artistText(RealtimePlayingInfos realtimePlayingInfos) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        realtimePlayingInfos.current!.audio.audio.metas.artist!,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget slider(RealtimePlayingInfos realtimePlayingInfos) {
    return SliderTheme(
        data: SliderThemeData(
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
        ),
        child: Slider.adaptive(
            value: realtimePlayingInfos.currentPosition.inSeconds.toDouble(),
            max: realtimePlayingInfos.duration.inSeconds.toDouble(),
            activeColor: Color(0xffe3eb6b),
            inactiveColor: Colors.grey[850],
            onChanged: (value) {
              audioPlayer.seek(Duration(seconds: value.toInt()));
            }));
  }

  Widget timestamps(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          transformString(realtimePlayingInfos.currentPosition.inSeconds),
          style: TextStyle(color: Colors.grey[600]),
        ),
        Text(
          transformString(realtimePlayingInfos.duration.inSeconds),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  void setupPlaylist() async {
    await audioPlayer.open(
        Playlist(audios: [
          Audio(
            'assets/audios/Teardrops.mp3',
            metas: Metas(
              title: 'Teardrops',
              artist: 'Bring Me The Horizon',
              album: 'Post-Human',
              image: MetasImage.network(
                  'https://upload.wikimedia.org/wikipedia/en/0/0a/Bring_Me_the_Horizon_Post_Human_Survival_Horror_Cover_Art_2020.jpg'),
            ),
          ),
          Audio(
            'assets/audios/Enough.mp3',
            metas: Metas(
              title: 'Enough',
              artist: 'Normandie',
              album: 'Enough',
              image: MetasImage.network(
                  'https://img.discogs.com/ri2qYdlc3OKzZIqlPBAQ6CWV0QY=/fit-in/600x591/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-12940615-1544978507-5482.jpeg.jpg'),
            ),
          ),
          Audio(
            'assets/audios/texas.mp3',
            metas: Metas(
              title: 'Texas Is Forever',
              artist: 'Pierce The Veil',
              album: 'Misadventure',
              image: MetasImage.network(
                  'https://upload.wikimedia.org/wikipedia/en/4/48/Misadventures.jpg'),
            ),
          )
        ]),
        autoStart: false,
        loopMode: LoopMode.playlist);
  }

  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
  }

  Widget playBar(RealtimePlayingInfos realtimePlayingInfos) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.compare_arrows_rounded),
          onPressed: () {},
          iconSize: screenHeight * 0.03,
          color: Colors.grey,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.fast_rewind_rounded),
          onPressed: () => audioPlayer.previous(),
          iconSize: screenHeight * 0.03,
          color: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(realtimePlayingInfos.isPlaying
              ? Icons.pause_circle_filled_rounded
              : Icons.play_circle_fill_rounded),
          onPressed: () => audioPlayer.playOrPause(),
          iconSize: screenHeight * 0.1,
          color: Color(0xffe3eb6b),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.fast_forward_rounded),
          onPressed: () => audioPlayer.next(),
          iconSize: screenHeight * 0.03,
          color: Colors.grey,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        IconButton(
          icon: Icon(Icons.autorenew_rounded),
          onPressed: () {},
          iconSize: screenHeight * 0.03,
          color: Colors.grey,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FabCircularMenu(children: <Widget>[
        IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Home();
              }));
            }),
        IconButton(
            icon: Icon(Icons.playlist_play),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PlayerAudio();
              }));
            }),
      ]),
      backgroundColor: Color(0xff121212),
      body: audioPlayer.builderRealtimePlayingInfos(
          builder: (context, realtimePlayingInfos) {
        // ignore: unnecessary_null_comparison
        if (realtimePlayingInfos != null) {
          return Stack(
            children: [
              Container(
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffcbfd96), Color(0xffe3eb6b)])),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.1, right: screenWidth * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      audioImage(realtimePlayingInfos),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      titleBar(realtimePlayingInfos),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      artistText(realtimePlayingInfos),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      slider(
                        realtimePlayingInfos,
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      timestamps(realtimePlayingInfos),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      playBar(realtimePlayingInfos),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                    ],
                  )),
            ],
          );
        } else {
          return Column();
        }
      }),
    );
  }
}

class CustomTrackShape extends RoundedRectRangeSliderTrackShape {
  Rect getPreferredrect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
