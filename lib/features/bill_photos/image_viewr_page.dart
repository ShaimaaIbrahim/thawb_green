import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/features/bill_photos/data/response/invoices_response.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart' as Get;

class ImageViewrPage extends StatefulWidget {
  static String routeName = "/pages/billphotos/imgaviewr";
  const ImageViewrPage({Key? key}) : super(key: key);

  @override
  _ImageViewrPageState createState() => _ImageViewrPageState();

}


class _ImageViewrPageState extends State<ImageViewrPage> {
  List<String> imageList = [

  ];

  @override
  void initState() {
    var args = Get.Get.arguments as List<Data>;
    for(int i =0 ; i< args.length; i++){
      imageList.add(args[i].invoice!);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('image_viewr'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    return Scaffold(
     // backgroundColor: globalColor.black,
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300.h,
                color: Colors.grey[200],
                child: PhotoViewGallery.builder(
                  itemCount: imageList.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(
                        imageList[index],
                        scale: 100,
                      ),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    );
                  },
                  scrollPhysics: BouncingScrollPhysics(),
                  backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  loadingBuilder: (_, c) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(height: 100.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: globalColor.black,
                      size: 30.w,
                    ),
                    SizedBox(width: 50.h),
                    Icon(
                      Icons.share,
                      color: globalColor.black,
                      size: 30.w,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h)
            ],
          ),
        ),
      ),
    );
  }
}

