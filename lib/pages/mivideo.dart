import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MiVidePlayer extends StatefulWidget {
  var url;
  MiVidePlayer({@required this.url});

  @override
  _MiVidePlayerState createState() => _MiVidePlayerState();
}

class _MiVidePlayerState extends State<MiVidePlayer> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url);
    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if(_state.todosDEteneido == true)
    // _controller.puase();

    return FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                        setState(() {});
                      } else {
                        _controller.play();
                        setState(() {});
                      }
                    },
                    child: Container(
                      // height: double.infinity,
                      // color: Colors.indigo,
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.grey[600],
            ));
        });
  }
}
