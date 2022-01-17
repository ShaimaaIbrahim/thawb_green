import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/bloc/application_state.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/entities/category_entity.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/providers/app_provider.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/edge_margin.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/horizontal_padding.dart';
import 'package:ojos_app/core/res/screen/vertical_padding.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/button/icon_button_widget.dart';
import 'package:ojos_app/core/ui/dailog/confirm_dialog.dart';
import 'package:ojos_app/core/ui/dailog/language_dailog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/dailog/soon_dailog.dart';
import 'package:ojos_app/core/ui/tab_bar/tab_bar.dart';
import 'package:ojos_app/core/ui/widget/network/network_widget.dart';
import 'package:ojos_app/core/ui/widget/title_with_view_all_widget.dart';
import 'package:ojos_app/features/home/data/models/product_model.dart';
import 'package:ojos_app/features/home/domain/model/category_model.dart';
import 'package:ojos_app/features/home/domain/model/product_model.dart';
import 'package:ojos_app/features/home/domain/services/home_api.dart';
import 'package:ojos_app/features/home/presentation/args/products_view_all_args.dart';
import 'package:ojos_app/features/home/presentation/blocs/offer_bloc.dart';
import 'package:ojos_app/features/home/presentation/pages/products_view_all_page.dart';
import 'package:ojos_app/features/home/presentation/widget/item_offer_widget.dart';
import 'package:ojos_app/features/home/presentation/widget/product_list_view.dart';
import 'package:ojos_app/features/notification/presentation/pages/notification_page.dart';
import 'package:ojos_app/features/order/presentation/pages/attripute.dart';
import 'package:ojos_app/features/others/domain/entity/about_app_result.dart';
import 'package:ojos_app/features/others/domain/usecases/get_about_app.dart';
import 'package:ojos_app/features/others/presentation/pages/favorite_page.dart';
import 'package:ojos_app/features/others/presentation/pages/offers_page.dart';
import 'package:ojos_app/features/others/presentation/pages/settings_page.dart';
import 'package:ojos_app/features/others/presentation/pages/sub_pages/terms_condetion.dart';
import 'package:ojos_app/features/others/presentation/pages/sub_pages/use_policy_page.dart';
import 'package:ojos_app/features/product/data/models/product_model.dart';
import 'package:ojos_app/features/profile/presentation/pages/profile_page.dart';
import 'package:ojos_app/features/reviews/presentation/pages/reviews_page.dart';
import 'package:ojos_app/features/search/presentation/pages/filter_search_page.dart';
import 'package:ojos_app/features/search/presentation/pages/search_page.dart';
import 'package:ojos_app/features/section/presentation/blocs/section_home_bloc.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/pages/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home/pages/HomePage';

  final TabController? tabController;

  const HomePage({this.tabController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<String> list = [
    AppAssets.slider_image_png,
    AppAssets.slider_image_png,
    AppAssets.slider_image_png,
    AppAssets.slider_image_png,
  ];

  int ind = 0;
  bool selected = false;
  Widget? rightChild, leftChild;
  PageController controller =
      PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
  var currentPageValue = 0;

  int? _styleSelected;
  GlobalKey _key = GlobalKey();

  //GlobalKey _keySection = GlobalKey();

  List<ProductModel>? listOfProduct;
  List<ProductModel>? listOfMenProduct;

  var _cancelToken = CancelToken();
  var _offerBloc = OfferBloc();
  var _sectionHomeBloc = SectionHomeBloc();

  List<CategoryEntity>? _listOfCategory;
  CategoryEntity? _category1;
  CategoryEntity? _category2;
  CategoryEntity? _category3;
  CategoryEntity? _category4;
  bool _isCategoryEmpty = false;
  var _listKey = GlobalKey();

  List<Widget> _coulumnSection = [];

  bool? isAuth;

  HomePageApi homePageApi = HomePageApi();

  loadCard(index) async {
    print(index);
    homePageApi.feachProduct(index)!.then((res) async {
      homePageApi.productController!.add(res);
      return res;
    });
  }

  List<Tab> _tabs(List<CategoryResult> categories) {
    List<Tab> tabs = [];
    tabs.add(Tab(
      child: Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
            //color: ind == 0 ? globalColor.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: globalColor.primaryColor, width: 1)),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "الكل",
            style: textStyle.subBigTSBasic.copyWith(fontSize: 10.sp),
            maxLines: 1,
          ),
        ),
      ),
    ));
    for (CategoryResult category in categories) {
      int i = 1;
      tabs.add(Tab(
        child: Container(
          width: 70,
          height: 30,
          decoration: BoxDecoration(
              //color: ind == i ? globalColor.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: globalColor.primaryColor, width: 1)),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              category.name,
              style: textStyle.subBigTSBasic.copyWith(fontSize: 10.sp),
              maxLines: 1,
            ),
          ),
        ),
      ));
      i++;
    }
    return tabs;
  }

  void launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    Share.share(url(), subject: message);

    // if (await canLaunch(url())) {
    //   await launch(url());
    // } else {
    //   throw 'Could not launch ${url()}';
    // }
  }

  @override
  void initState() {
    super.initState();

    homePageApi.productController = StreamController();

    loadCard(0);

    _offerBloc.add(SetupOfferEvent(cancelToken: _cancelToken));
    _sectionHomeBloc.add(GetSectionHomeEvent(cancelToken: _cancelToken));
    _listOfCategory = [];
    _category1 = null;
    _category2 = null;
    _category3 = null;
    _category4 = null;
  }

  bool isLanguageArabic() {
    print(
        "this language is isLanguageArabic ${Provider.of<AppProvider>(context, listen: false).lang} ");

    return Provider.of<AppProvider>(context, listen: false).lang == LANG_AR;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    //=========================================================================
    isAuth =
        BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
            BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;
    AppBar appBar({height, state}) => AppBar(
          backgroundColor: globalColor.appBar,
          brightness: Brightness.light,
          elevation: 0,
          title: Container(
            child: Image.asset(
              AppAssets.appbar_logo,
              // width: 100,
              height: 140,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButtonWidget(
              icon: SvgPicture.asset(
                AppAssets.search,
                width: 20,
                height: 20,
                color: globalColor.primaryColor,
                fit: BoxFit.scaleDown,
              ),
              onTap: () async {
                Get.Get.toNamed(SearchPage.routeName);
              },
            ),
            HorizontalPadding(
              percentage: 2.5,
            ),
            IconButtonWidget(
              icon: SvgPicture.asset(
                AppAssets.notification,
                width: 25,
                height: 25,
              ),
              onTap: () async {
                if (await UserRepository.hasToken && isAuth!) {
                  Get.Get.toNamed(NotificationPage.routeName);
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => LoginFirstDialog(),
                  );
                }
              },
            ),
            HorizontalPadding(
              percentage: 2.5,
            )
          ],
        );

    double width = globalSize.setWidthPercentage(100, context);
    double height = globalSize.setHeightPercentage(100, context) -
        appBar().preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    return BlocBuilder<ApplicationBloc, ApplicationState>(
        bloc: BlocProvider.of<ApplicationBloc>(context),
        builder: (context, state) {
          return FutureBuilder(
              future: homePageApi.feachCategory(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var categoryModel = snapshot.data as GeneralCategoryModel;
                  tabController = TabController(
                    length: categoryModel.result.length + 1,
                    vsync: this,
                    initialIndex: 0,
                  );

                  return Scaffold(
                      backgroundColor: globalColor.scaffoldBackGroundGreyColor,
                      appBar: AppBar(
                        backgroundColor: globalColor.appBar,
                        brightness: Brightness.light,
                        elevation: 0,
                        title: Container(
                          width: 120,
                          height: 100,
                          child: Image.asset(
                            AppAssets.appbar_logo,
                            width: 80,
                            height: 100,
                          ),
                        ),
                        centerTitle: true,
                        actions: [
                          IconButtonWidget(
                            icon: SvgPicture.asset(
                              AppAssets.search,
                              width: 20,
                              height: 20,
                              color: globalColor.primaryColor,
                              fit: BoxFit.scaleDown,
                            ),
                            onTap: () async {
                              Get.Get.toNamed(SearchPage.routeName);
                            },
                          ),
                          HorizontalPadding(
                            percentage: 2.5,
                          ),
                          HorizontalPadding(
                            percentage: 2.5,
                          )
                        ],
                        bottom: TabBar(
                          controller: tabController,
                          isScrollable: true,
                          unselectedLabelColor: globalColor.primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: globalColor.primaryColor),
                          indicatorPadding: EdgeInsets.symmetric(vertical: 10),
                          labelPadding: EdgeInsets.symmetric(horizontal: 5),
                          tabs: _tabs(categoryModel.result),
                          onTap: (index) {
                            loadCard(categoryModel.result[index].id);
                          },
                        ),
                      ),
                      body: StreamBuilder(
                        stream: homePageApi.productController!.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var productModel =
                                snapshot.data as GeneralProductModel;
                            print(
                                "productModel ----------------------*---------------- $productModel");
                            return Container(
                                height: height,
                                key: _listKey,
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    setState(() {
                                      _listKey = GlobalKey();
                                    });
                                    return null;
                                  },
                                  child: SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          _buildTopAds(
                                              productModel: productModel,
                                              context: context,
                                              width: width,
                                              height: height),
                                          // VerticalPadding(
                                          //   percentage: 2,
                                          // ),
                                          // Container(
                                          //   color: Colors.grey.withOpacity(.2),
                                          //   child: Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.start,
                                          //     children: [
                                          //       Padding(
                                          //         padding:
                                          //             const EdgeInsets.all(8.0),
                                          //         child: Text(
                                          //           Translations.of(context)
                                          //               .translate('fasel'),
                                          //           style: textStyle
                                          //               .smallTSBasic
                                          //               .copyWith(
                                          //             color: Colors.black,
                                          //             fontWeight:
                                          //                 FontWeight.w600,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment
                                          //                 .spaceAround,
                                          //         children: [
                                          //           HorizontalPadding(
                                          //               percentage: 2),
                                          //           Expanded(
                                          //             child: OutlineButton(
                                          //               disabledBorderColor:
                                          //                   globalColor.black,
                                          //               borderSide: BorderSide(
                                          //                 width: .5,
                                          //                 color: Colors.black,
                                          //                 style:
                                          //                     BorderStyle.solid,
                                          //               ),
                                          //               shape:
                                          //                   RoundedRectangleBorder(
                                          //                       borderRadius:
                                          //                           BorderRadius
                                          //                               .circular(
                                          //                                   8)),
                                          //               onPressed: () {
                                          //                 Navigator.push(
                                          //                     context,
                                          //                     MaterialPageRoute(
                                          //                       builder:
                                          //                           (context) =>
                                          //                               TabBarDemo(),
                                          //                     ));
                                          //               },
                                          //               child: Text(
                                          //                 Translations.of(
                                          //                         context)
                                          //                     .translate(
                                          //                         'online'),
                                          //                 style: textStyle
                                          //                     .smallTSBasic
                                          //                     .copyWith(
                                          //                   color: globalColor
                                          //                       .grey,
                                          //                   fontWeight:
                                          //                       FontWeight.w600,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           HorizontalPadding(
                                          //               percentage: 2),
                                          //           Expanded(
                                          //             child: OutlineButton(
                                          //               borderSide: BorderSide(
                                          //                 width: .5,
                                          //                 color: Colors.black,
                                          //                 style:
                                          //                     BorderStyle.solid,
                                          //               ),
                                          //               shape:
                                          //                   RoundedRectangleBorder(
                                          //                       borderRadius:
                                          //                           BorderRadius
                                          //                               .circular(
                                          //                                   8)),
                                          //               onPressed: () {
                                          //                 launchWhatsApp(
                                          //                     phone:
                                          //                         "+966555845631",
                                          //                     message:
                                          //                         "مرحبا اريد تفصيل ثوب");
                                          //               },
                                          //               child: Row(
                                          //                 mainAxisAlignment:
                                          //                     MainAxisAlignment
                                          //                         .center,
                                          //                 children: [
                                          //                   Text(
                                          //                     Translations.of(
                                          //                             context)
                                          //                         .translate(
                                          //                             'near'),
                                          //                     style: textStyle
                                          //                         .middleTSBasic
                                          //                         .copyWith(
                                          //                       fontSize: 16,
                                          //                       color:
                                          //                           globalColor
                                          //                               .grey,
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w600,
                                          //                     ),
                                          //                   ),
                                          //                   SizedBox(width: 4),
                                          //                   Image.asset(
                                          //                     'assets/images/icons/png/whats.png',
                                          //                     height: 20,
                                          //                     width: 20,
                                          //                   )
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ),
                                          //           HorizontalPadding(
                                          //               percentage: 2),
                                          //         ],
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          VerticalPadding(
                                            percentage: 2,
                                          ),
                                          _buildMostSold(
                                              productModel: productModel
                                                  .result.Weekly_Offers,
                                              context: context,
                                              width: width,
                                              height: height,
                                              title: "Weekly_Offers"),
                                          VerticalPadding(
                                            percentage: 2,
                                          ),
                                          _buildMostSold(
                                              productModel: productModel
                                                  .result.Offers_and_discounts,
                                              context: context,
                                              width: width,
                                              height: height,
                                              title: "Offers_and_discounts"),
                                          VerticalPadding(
                                            percentage: 2,
                                          ),
                                          _buildMostSold(
                                              productModel: productModel
                                                  .result.best_seller,
                                              context: context,
                                              width: width,
                                              height: height,
                                              title: "best_seller"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ));
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              });
          // );
        });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _offerBloc.close();
    _sectionHomeBloc.close();
    //_menuController.dispose();
    super.dispose();
  }

  ///Lis-t of interview questions.
  Widget getListItem(
    Color color,
    String iconPath,
    String title,
  ) {
    return GestureDetector(
      key: title == 'Behavioural Based' ? Key('item') : null,
      child: Container(
        color: color,
        height: 300.0,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: iconPath,
              child: Image.asset(
                iconPath,
                width: 80.0,
                height: 80.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: globalColor.white,
                    fontSize: 10,
                    fontFamily: 'Cairo',
                  ),
              textAlign: TextAlign.center,
            )
          ],
        )),
      ),
      onTap: () {},
    );
  }

  Card getMaterialResideMenuItem(String drawerMenuTitle, String? drawerMenuIcon,
      {MenuSpecItem? state,
      bool ishideArrow = true,
      tralingfunc,
      leadingWidget}) {
    return Card(
      child: new InkWell(
        onTap: () {
          if (state == null)
            tralingfunc();
          else {
            //  _menuController.closeMenu();
            _onItemMenuPress(state);
          }
        },
        child: Container(
            margin: EdgeInsets.only(
              right: isRtl(context) ? 10.0 : 0.0,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        drawerMenuIcon ?? AppAssets.home_nav_bar,
                        color: globalColor.primaryColor,
                        width: 20,
                      ),
                      Container(
                        width: 30,
                      ),
                      Text(
                        Translations.of(context).translate(drawerMenuTitle),
                        style: textStyle.normalTSBasic
                            .copyWith(color: globalColor.black),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 12.0, top: 5, bottom: 5),
                ),
                Padding(
                  child: ishideArrow
                      ? Container()
                      : Container(
                          child: leadingWidget == null
                              ? Icon(
                                  utils.getLang() == 'ar'
                                      ? Icons.keyboard_arrow_left
                                      : Icons.keyboard_arrow_right,
                                  color: globalColor.primaryColor,
                                  size: 25,
                                )
                              : leadingWidget,
                        ),
                  padding: EdgeInsets.only(right: 0),
                )
              ],
            )),
      ),
    );
  }

  Widget getMaterialResideMenuItem2(
      String drawerMenuTitle, String drawerMenuIcon,
      {required MenuSpecItem state,
      bool ishideArrow = true,
      tralingfunc,
      leadingWidget}) {
    return new InkWell(
      onTap: () {
        if (state == null)
          tralingfunc();
        else {
          //_menuController.closeMenu();
          _onItemMenuPress(state);
        }
      },
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: globalColor.primaryColor,
              ),
              borderRadius: BorderRadius.circular(6)),
          margin: EdgeInsets.only(
            right: isRtl(context) ? 10.0 : 0.0,
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      Translations.of(context).translate(drawerMenuTitle),
                      style: textStyle.normalTSBasic.copyWith(
                        color: globalColor.primaryColor,
                      ),
                    )
                  ],
                ),
                margin:
                    EdgeInsets.only(left: 12.0, top: 1, bottom: 1, right: 12),
              ),
            ],
          )),
    );
  }

  _onItemMenuPress(MenuSpecItem state) async {
    switch (state) {
      case MenuSpecItem.HomePage:
        break;
      case MenuSpecItem.ProfilePage:
        if (await UserRepository.hasToken && isAuth!) {
          Get.Get.toNamed(ProfilePage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.BrandPage:
        widget.tabController!.animateTo(1);
        break;
      case MenuSpecItem.OrderPage:
        widget.tabController!.animateTo(4);
        break;
      case MenuSpecItem.SectionPage:
        widget.tabController!.animateTo(3);
        break;
      case MenuSpecItem.WalletPage:
        showDialog(
          context: context,
          builder: (ctx) => SoonDialog(),
        );

        break;
      case MenuSpecItem.FavoritePage:
        if (await UserRepository.hasToken && isAuth!) {
          Get.Get.toNamed(FavoritePage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.ReviewsPage:
        if (await UserRepository.hasToken && isAuth!) {
          Get.Get.toNamed(ReviewPage.routeName);
        } else {
          showDialog(
            context: context,
            builder: (ctx) => LoginFirstDialog(),
          );
        }

        break;
      case MenuSpecItem.OffersPage:
        Get.Get.toNamed(OffersPage.routeName);
        break;
      case MenuSpecItem.SettingsPage:
        Get.Get.toNamed(SettingsPage.routeName);
        break;
      case MenuSpecItem.SignInPage:
        Get.Get.toNamed(SignInPage.routeName);
        break;
      case MenuSpecItem.SignOut:
        showDialog(
          context: context,
          builder: (ctx) => ConfirmDialog(
            title: Translations.of(context).translate('logout'),
            confirmMessage:
                Translations.of(context).translate('are_you_sure_logout'),
            actionYes: () {
              // logoutFromFacebookIfLoggedIn();
              BlocProvider.of<ApplicationBloc>(context).add(UserLogoutEvent());
              Get.Get.back();
            },
            actionNo: () {
              setState(() {
                Get.Get.back();
              });
            },
          ),
        );
        break;
      default:
        break;
    }
  }

  bool isRtl(context) => TextDirection.rtl == Directionality.of(context);

  getHeaderText(String userName) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Translations.of(context).translate('welcome'),
            style: textStyle.normalTSBasic.copyWith(color: globalColor.black),
          ),
          Text(
            userName,
            maxLines: 1,
            style: textStyle.normalTSBasic.copyWith(color: globalColor.black),
          ),
        ],
      ),
    );
  }

  void _lunchSocialMediaAction(BuildContext context, String link) async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      onError(context);
    }
  }

  onError(BuildContext context) {
    Fluttertoast.showToast(
      msg: Translations.of(context).translate('err_unexpected'),
      gravity: ToastGravity.BOTTOM,
    );
  }

  List<Widget> getListMaterialResideMenuItem1(ApplicationState state) {
    return [
      getMaterialResideMenuItem(
          'edit_profile_drawer', AppAssets.profile_nav_bar,
          state: MenuSpecItem.ProfilePage),

      getMaterialResideMenuItem('application_language', AppAssets.worldLang,
          tralingfunc: () {
        return showDialog(
          context: context,
          builder: (_) => LanguageDialog(),
        );
      },
          ishideArrow: false,
          leadingWidget: Row(
            children: [
              Text(
                utils.getLang() == 'ar' ? 'العربية' : 'English',
                style: textStyle.minTSBasic.copyWith(
                    color: Color(0xff227987),
                    decoration: TextDecoration.underline),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Color(0xff227987),
              ),
              SizedBox(
                width: 2,
              ),
            ],
          )),

      IconButtonWidget(
        icon: SvgPicture.asset(
          AppAssets.notification,
          width: 25,
          height: 25,
        ),
        onTap: () async {
          if (await UserRepository.hasToken && isAuth!) {
            Get.Get.toNamed(NotificationPage.routeName);
          } else {
            showDialog(
              context: context,
              builder: (ctx) => LoginFirstDialog(),
            );
          }
        },
      ),

      getMaterialResideMenuItem('offers_drawer', AppAssets.sales,
          state: MenuSpecItem.OffersPage),

      InkWell(
        onTap: () {
          Get.Get.toNamed(UsePolicyPage.routeName);
        },
        child: getMaterialResideMenuItem('use_policy', AppAssets.use_policy,
            tralingfunc: () {
          Get.Get.toNamed(UsePolicyPage.routeName);
        },
            leadingWidget: Container(
              width: 2000,
            )),
      ),

      getMaterialResideMenuItem('wallet_drawer', AppAssets.wallet_drawer,
          state: MenuSpecItem.WalletPage),

      getMaterialResideMenuItem('favorite_drawer', AppAssets.love,
          state: MenuSpecItem.FavoritePage),

      InkWell(
        onTap: () {
          Get.Get.toNamed(TermsCondetion.routeName);
        },
        child: getMaterialResideMenuItem(
            'Terms and Conditions', AppAssets.user_privacy, tralingfunc: () {
          Get.Get.toNamed(TermsCondetion.routeName);
        },
            leadingWidget: Container(
              width: 2000,
            )),
      ),

      // getMaterialResideMenuItem('settings', AppAssets.settings_drawer,
      //     state: MenuSpecItem.SettingsPage),
      // Divider(
      //   height: 1,
      //   color: globalColor.grey.withOpacity(0.5),
      // ),
      Container(
        height: 50,
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NetworkWidget(
            builder: (BuildContext context, AboutAppResult aboutAppResult) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _lunchSocialMediaAction(context, aboutAppResult.twitter!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SvgPicture.asset(AppAssets.twitter,
                                  color: Colors.white),
                            ),
                            backgroundColor: globalColor.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _lunchSocialMediaAction(
                          context, aboutAppResult.instagram!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SvgPicture.asset(AppAssets.instagram,
                              color: Colors.white),
                        ),
                        /* child: Icon(
                          FontAwesome.twitter,
                          color: globalColor.white,
                        ),*/
                        backgroundColor: globalColor.primaryColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String configEmail =
                          'mailto:${aboutAppResult.email ?? "email@gmail.com"}'
                          '?subject=Email about $APP_NAME   &'
                          'body=Thank you for a such great App';
                      _lunchSocialMediaAction(context, configEmail);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        child: Icon(Icons.email_outlined,
                            color: globalColor.white),
                        backgroundColor: globalColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              );
            },
            loadingWidgetBuilder: (BuildContext context) {
              return Container(
                  // width: 60,
                  // height: 60,
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            globalColor.primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            globalColor.primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            globalColor.primaryColor),
                      ),
                    ),
                  ),
                ],
              ));
            },
            fetcher: () {
              return GetAboutApp(locator<CoreRepository>())(
                GetAboutAppParams(
                  cancelToken: _cancelToken,
                ),
              );
            },
          ),
          (state.isUserAuthenticated || state.isUserVerified)
              ? getMaterialResideMenuItem2('logout', AppAssets.logout_svg,
                  state: MenuSpecItem.SignOut, ishideArrow: true)
              : getMaterialResideMenuItem2('login', AppAssets.login_svg,
                  state: MenuSpecItem.SignInPage, ishideArrow: true),
        ],
      ),
    ];
  }

  _buildPageIndicator2({double? width, int? count}) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: width,
      child: SmoothPageIndicator(
          controller: controller, //// PageController
          count: count!,
          effect: WormEffect(
            spacing: 8.0,
            radius: 9.0,
            dotWidth: 8.0,
            dotHeight: 8.0,
            dotColor: Colors.white,
            paintStyle: PaintingStyle.fill,
            strokeWidth: 2,
            activeDotColor: globalColor.primaryColor,
          ), // your preferred effect
          onDotClicked: (index) {}),
    );
  }

  _buildTopAds(
      {required GeneralProductModel productModel,
      required BuildContext context,
      required double width,
      required double height}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // color: Colors.green,
      width: width,
      height: 150.h,
      child: Stack(
        children: [
          PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            children: productModel.result.adds
                .map((item) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ItemOfferWidget(
                        offerItem: item,
                        width: width,
                      ),
                    ))
                .toList(),
          ),
          Positioned(
              bottom: 8,
              right: 0,
              left: 0,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: _buildPageIndicator2(
                      width: width, count: productModel.result.adds.length)))
        ],
      ),
    );
  }

  _buildMostSold(
      {List<OffersAndDiscount>? productModel,
      BuildContext? context,
      double? width,
      double? height,
      title}) {
    return Container(
      child: productModel!.length == 0
          ? Container()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: EdgeMargin.small, right: EdgeMargin.small),
                  child: TitleWithViewAllWidget(
                    width: width!,
                    title: Translations.of(context!).translate(title),
                    onClickView: () {
                      Get.Get.toNamed(
                        ProductsVeiwAllPage.routeName,
                      );
                    },
                    strViewAll: Translations.of(context).translate('view_all'),
                  ),
                ),
                Container(
                  height: globalSize.setWidthPercentage(60, context),
                  child: ListView.builder(
                      itemCount: productModel.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => CustomProductItemWidget(
                            height: globalSize.setWidthPercentage(60, context),
                            width: globalSize.setWidthPercentage(45, context),
                            product: productModel.elementAt(index),
                          )),
                ),
              ],
            ),
    );
  }
}

class GetDrawer extends StatelessWidget {
  final state;
  final height;
  Function getListMaterialResideMenuItem;

  GetDrawer(this.state, this.height, this.getListMaterialResideMenuItem);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.of(context).translate("menuAppBar"),
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: new Container(
        padding: new EdgeInsets.only(left: 5, right: 5),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                new ListView(
                  physics: const BouncingScrollPhysics(),
                  // itemExtent: 40.0,
                  shrinkWrap: true,
                  children: getListMaterialResideMenuItem(state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum MenuSpecItem {
  HomePage,
  ProfilePage,
  BrandPage,
  OrderPage,
  SectionPage,
  WalletPage,
  FavoritePage,
  ReviewsPage,
  OffersPage,
  SettingsPage,
  SignInPage,
  SignOut
}
