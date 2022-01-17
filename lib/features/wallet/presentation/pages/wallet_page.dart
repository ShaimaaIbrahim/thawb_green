import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/arrow_back_button_widget.dart';
import 'package:ojos_app/core/ui/list/build_list_wallet_transactions.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/features/wallet/model/wallet_model.dart';
import 'package:ojos_app/features/wallet/services/wallet_api.dart';

class WalletPage extends StatefulWidget {
  static const routeName = '/wallet/pages/WalletPage';

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  WalletPageApi walletApi = WalletPageApi();

  @override
  void initState() {
    walletApi.fetchWalletData();
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _cancelToken = CancelToken();

  @override
  Widget build(BuildContext context) {
    //=========================================================================

    AppBar appBar = AppBar(
      backgroundColor: globalColor.appBar,
      brightness: Brightness.light,
      elevation: 0,
      leading: ArrowIconButtonWidget(
        iconColor: globalColor.black,
      ),
      title: Text(
        Translations.of(context).translate('wallet_drawer'),
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
        body: FutureBuilder(
          future: walletApi.fetchWalletData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              var walletModel = snapshot.data as WalletResponse;
              return walletModel.data.length == 0 ?  Center(
               child: Text(Translations.of(context).translate('no_wallet')),
              ):Container(
                  height: height,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      // child: Column(
                      //   children: [
                      //     // VerticalPadding(
                      //     //   percentage: 2.0,
                      //     // ),
                      //     // Container(
                      //     //     padding: const EdgeInsets.only(
                      //     //         left: EdgeMargin.min, right: EdgeMargin.min),
                      //     //     child: _buildCoponTextWidget(
                      //     //         context: context, width: width, height: 63.h)),
                      //     // VerticalPadding(
                      //     //   percentage: 2.0,
                      //     // ),
                      //     // Container(
                      //     //     padding: const EdgeInsets.only(
                      //     //         left: EdgeMargin.min, right: EdgeMargin.min),
                      //     //     child: _buildPayMethodTextWidget(
                      //     //         context: context, width: width, height: 41.h)),
                      //     //
                      //     // VerticalPadding(
                      //     //   percentage: 2.0,
                      //     // ),
                      //
                      //     _buildProcessOnWalletList(
                      //         context: context, width: width, height: 41.h),
                      //
                      //     VerticalPadding(
                      //       percentage: 4.0,
                      //     ),
                      //   ],
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: ListView.separated(
                            physics: NeverScrollableScrollPhysics( ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => buildChatItem(walletModel.data[index]),
                            separatorBuilder: (context, index) => SizedBox(
                              height: 15.h
                            ),
                            itemCount: walletModel.data.length),
                      ),
                    ),
                  ));
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );

        }
        ));
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
  }*/

  _buildProcessOnWalletList(
      {required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: EdgeMargin.small, right: EdgeMargin.small),
            child: TitleWithViewAllWidget(
              width: width,
              style: textStyle.smallTSBasic.copyWith(
                  color: globalColor.black, fontWeight: FontWeight.w600),
              title: Translations.of(context)
                  .translate('latest_wallet_operations'),
              onClickView: () {},
              hideSeeAll: true,
              strViewAll: Translations.of(context).translate('view_all'),
            ),
          ),
          Container(
            child: BuildListWalletTransactionsWidget(
              isScrollList: false,
              isEnablePagination: false,
              isEnableRefresh: false,
              cancelToken: _cancelToken,
              params: {},
              itemWidth: width,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }
}
Row buildChatItem(WalletDataBean wallet) {
  return Row(
    children: [
      CircleAvatar(
        backgroundImage: AssetImage("assets/images/logo/logo_icon.png"),
        radius: 30,
      ),
      SizedBox(
        width: 10,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wallet?.productName[0]??"",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'مزيد من المعلومات عن نص الرساله',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Text(
                  '20:37',
                )
              ],
            )
          ],
        ),
      )
    ],
  );
}

