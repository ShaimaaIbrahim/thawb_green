import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/list/build_list_notifications.dart';
import 'package:ojos_app/features/notification/data/models/notification_model.dart';

class NotificationPage extends StatefulWidget {
  static const routeName = '/notification/pages/NotificationPage';

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel>? _list;
  initList() {
    _list = [
      NotificationModel(
          title: 'الملف الشخصي',
          image: AppAssets.profile_nav_bar,
          subTitle: 'لديك بيانات غير مدخلة في ملفك الشخصي'),
      NotificationModel(
          title: 'المفضلة',
          image: AppAssets.love,
          subTitle: 'تم إضافة نظارة لوكس الشمسية للمفضلة'),
      NotificationModel(
          title: 'الأقسام',
          image: AppAssets.section_nav_bar,
          subTitle: 'تم إضافة اقسام جديدة '),
      NotificationModel(
          title: 'المحفظة',
          image: AppAssets.wallet_drawer,
          subTitle: 'تم إضافة مبلغ 500 ريال لحسابك'),
      NotificationModel(
          title: 'التقييمات',
          image: AppAssets.review_drawer,
          subTitle: 'تم ارسال التقييم الخاص بك بنجاح'),
      NotificationModel(
          title: 'العروض',
          image: AppAssets.sales_svg,
          subTitle: 'تم نشر العديد من العروض الجديدة '),
      NotificationModel(
          title: 'الدعم الفني',
          image: AppAssets.supported_team_svg,
          subTitle: 'اذا عندك أي استفسارات تواصل معنا'),
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _globalKey = GlobalKey();
  var _cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    initList();
    //=========================================================================

    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('notifications'),
        style: textStyle.middleTSBasic.copyWith(color: globalColor.black),
      ),
      centerTitle: true,
    );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar.preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return Scaffold(
        appBar: appBar,
        key: _scaffoldKey,
        backgroundColor: globalColor.scaffoldBackGroundGreyColor,
        body: Container(
            key: _globalKey,
            height: height,
            child: BuildListNotificationsWidget(
              cancelToken: _cancelToken,
              onUpdate: _onUpdate,
              isEnablePagination: true,
              isEnableRefresh: true,
              params: {},
              itemWidth: width,
            )));
  }

  _onUpdate() {
    _globalKey = GlobalKey();
    if (mounted) setState(() {});
  }
/*  _buildCoponTextWidget({
    BuildContext context,
    double width,
    double height,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        // border:
        // Border.all(color: globalColor.primaryColor.withOpacity(0.3), width: 0.5),
      ),
      //   margin: const EdgeInsets.only(left: EdgeMargin.verySub,),
      height: height,
      width: width,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Container(
                  width: 32,
                  height: 32,
                  color: globalColor.goldColor,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      AppAssets.wallet_drawer,
                      width: 10.w,
                      color: globalColor.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'اجمالي الرصيد',
                    style: textStyle.middleTSBasic.copyWith(
                        color: globalColor.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '360',
                    style: textStyle.bigTSBasic.copyWith(
                        color: globalColor.goldColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${Translations.of(context).translate('rail')}',
                    style: textStyle.middleTSBasic.copyWith(
                        color: globalColor.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: globalColor.white,
                      borderRadius: BorderRadius.circular(12.0.w),
                      border: Border.all(
                          color: globalColor.grey.withOpacity(0.3),
                          width: 0.5)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(EdgeMargin.sub,
                        EdgeMargin.sub, EdgeMargin.sub, EdgeMargin.sub),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          'طرق الدفع',
                          style: textStyle.minTSBasic.copyWith(
                            color: globalColor.black,
                          ),
                        ),
                        Icon(
                          utils.getLang()=='ar' ? MaterialIcons.keyboard_arrow_left : MaterialIcons.keyboard_arrow_right,
                          color: globalColor.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildPayMethodTextWidget({
    BuildContext context,
    double width,
    double height,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: globalColor.white,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
        // border:
        // Border.all(color: globalColor.primaryColor.withOpacity(0.3), width: 0.5),
      ),
      padding: const EdgeInsets.only(
        left: EdgeMargin.subMin,
        right: EdgeMargin.subMin,
      ),
      height: height,
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              'شحن رصيد بالمحفظة',
              style: textStyle.smallTSBasic.copyWith(
                  color: globalColor.black, fontWeight: FontWeight.w600),
            ),
          ),
          Icon(
            utils.getLang()=='ar' ? MaterialIcons.keyboard_arrow_left : MaterialIcons.keyboard_arrow_right,
            color: globalColor.black,
          ),
        ],
      ),
    );
  }

  _buildProcessOnWalletList({BuildContext context, double width, double height}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              style: textStyle.smallTSBasic.copyWith(
                color: globalColor.black,
                fontWeight: FontWeight.w600
              ),
              title: Translations.of(context).translate('latest_wallet_operations'),
              onClickView: () {},
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),

          Container(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context,index){
                return Container(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.min, right: EdgeMargin.min),
                  child: Card(
                    color: globalColor.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0.w))
                      ),
                    child:  Container(
                      width: width,
                      padding: const EdgeInsets.only(
                          left: EdgeMargin.min, right: EdgeMargin.min,bottom:EdgeMargin.min,top: EdgeMargin.min ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Center(
                              child: Container(
                                width: 32,
                                height: 32,
                                color: globalColor.scaffoldBackGroundGreyColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: SvgPicture.asset(
                                    AppAssets.wallet_drawer,
                                    width: 10.w,
                                    color: globalColor.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          HorizontalPadding(
                            percentage: 2.5,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'شراء نظارة كلاس اصلية',
                                  style: textStyle.smallTSBasic.copyWith(
                                      color: globalColor.black, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                                RichText(
                                  overflow: TextOverflow.ellipsis,maxLines: 1,
                                  text:  TextSpan(
                                    text: 'تم إضافة مبلغ',
                                    style: textStyle.minTSBasic.copyWith(
                                        color: globalColor.black),
                                    children: <
                                        TextSpan>[
                                      new TextSpan(
                                          text: '  500 ${Translations.of(context).translate('rail')}',
                                          style: textStyle.minTSBasic.copyWith(
                                              color: globalColor
                                                  .primaryColor,
                                          fontWeight: FontWeight.w600
                                          )),
                                      new TextSpan(
                                          text: ' لحسابك ',
                                          style: textStyle.minTSBasic.copyWith(
                                              color: globalColor
                                                  .black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: globalColor.white,
                                    borderRadius: BorderRadius.circular(12.0.w),
                                    border: Border.all(
                                        color: globalColor.grey.withOpacity(0.3),
                                        width: 0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(EdgeMargin.sub,
                                      EdgeMargin.sub, EdgeMargin.sub, EdgeMargin.sub),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Text(
                                        'عرض',
                                        style: textStyle.minTSBasic.copyWith(
                                          color: globalColor.black,
                                        ),
                                      ),
                                      Icon(
                                        utils.getLang()=='ar' ? MaterialIcons.keyboard_arrow_left : MaterialIcons.keyboard_arrow_right,
                                        color: globalColor.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )


                  ),
                );
              },
            ) ,
          ),
        ],
      ),
    );
  }*/

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
