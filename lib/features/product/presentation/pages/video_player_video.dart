import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/features/order/domain/entities/video_player_args.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart' as Get;

class VideoPlayerVideo extends StatefulWidget {
  static String routeName = "/pages/product/videoplayerpage";

  const VideoPlayerVideo({Key? key}) : super(key: key);

  @override
  _VideoPlayerVideoState createState() => _VideoPlayerVideoState();
}

class _VideoPlayerVideoState extends State<VideoPlayerVideo> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  final args = Get.Get.arguments as VideoPlayerArgs;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        args.videoUrl ?? 'https://greenthoob.com/public/clothSize.mp4');
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.setLooping(true);
    _controller!.setVolume(1.0);

    _controller!.play();

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: globalColor.scaffoldBackGroundGreyColor,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('video_player'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      //backgroundColor: globalColor.black,
      appBar: appBar,
      body: SafeArea(
        child: Container(
            width: width,
            height: height,
            child: Center(
              child: FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Stack(
                        children: [

                          AspectRatio(
                            aspectRatio: _controller!.value.aspectRatio,
                            child: VideoPlayer(_controller!),
                          ),
                          Positioned(
                            top: 0.h,
                            left: 0.w,
                            right: 0.w,
                            bottom: 0.h,
                            child: InkWell(
                              onTap: (){
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                              },
                              child: Icon(
                                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.green, size: 60.w,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }),
            )),
      ),
    );
  }
}
