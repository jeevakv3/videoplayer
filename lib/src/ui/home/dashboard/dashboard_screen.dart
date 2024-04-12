import '../../../../allpackages.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _showOverlay = false;
  IconData _overlayIcon = Icons.fast_forward;
  String _overlayText = "+10";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..addListener(() {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      });
    stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fastForward() {
    setState(() {
      _showOverlay = true;
      _overlayIcon = Icons.fast_forward;
      _overlayText = "+10";
    });
    _controller.seekTo(_controller.value.position + Duration(seconds: 10));
    _hideOverlay();
  }

  void _rewind() {
    setState(() {
      _showOverlay = true;
      _overlayIcon = Icons.fast_rewind;
      _overlayText = "-10";
    });
    _controller.seekTo(_controller.value.position - Duration(seconds: 10));
    _hideOverlay();
  }

  void stop() {
    setState(() {
      _showOverlay = true;
      print('show ${_controller.value.isPlaying}');
      _overlayIcon =
          _controller.value.isPlaying ? Icons.play_arrow : Icons.pause;
      _overlayText = _controller.value.isPlaying ? "Pause" : "";
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
    _hideOverlay();
  }

  void _hideOverlay() {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        if (_controller.value.isPlaying == false &&
            _overlayText != "-10" &&
            _overlayText != "+10") {
          _showOverlay = true;
        } else {
          _showOverlay = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: GestureDetector(
        onTap: () {
          setState(() {
            stop();
          });
        },
        onDoubleTapDown: (details) {
          final double screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 2) {
            _rewind();
          } else {
            _fastForward();
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            _buildOverlay(context),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: false,
              padding: EdgeInsets.only(top: 175.0),
              colors: VideoProgressColors(
                playedColor: Colors.red,
                backgroundColor: Colors.grey,
                bufferedColor: Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    if (true)
      return Stack(
        children: [
          Positioned(
            top: 200,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.red, size: 30),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      );
    if (!_showOverlay) return const SizedBox.shrink();
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_overlayIcon, size: 50, color: Colors.white),
            Text(_overlayText,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
