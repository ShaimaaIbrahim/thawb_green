import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as Get;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ojos_app/core/bloc/application_bloc.dart';
import 'package:ojos_app/core/bloc/application_events.dart';
import 'package:ojos_app/core/bloc/application_state.dart';
import 'package:ojos_app/core/bloc/root_page_bloc.dart';
import 'package:ojos_app/core/constants.dart';
import 'package:ojos_app/core/localization/translations.dart';
import 'package:ojos_app/core/notification/notifications_service.dart';
import 'package:ojos_app/core/repositories/core_repository.dart';
import 'package:ojos_app/core/res/app_assets.dart';
import 'package:ojos_app/core/res/global_color.dart';
import 'package:ojos_app/core/res/screen/screen_helper.dart';
import 'package:ojos_app/core/res/text_style.dart';
import 'package:ojos_app/core/res/utils.dart';
import 'package:ojos_app/core/res/width_height.dart';
import 'package:ojos_app/core/ui/dailog/confirm_dialog.dart';
import 'package:ojos_app/core/ui/dailog/language_dailog.dart';
import 'package:ojos_app/core/ui/dailog/login_first_dialog.dart';
import 'package:ojos_app/core/ui/dailog/soon_dailog.dart';
import 'package:ojos_app/core/ui/widget/network/network_widget.dart';
import 'package:ojos_app/features/brand/presentation/pages/brand_page.dart';
import 'package:ojos_app/features/cart/domin/entities/cart_attribute_entity.dart';
import 'package:ojos_app/features/cart/presentation/pages/cart_attribute_page.dart';
import 'package:ojos_app/features/cart/presentation/pages/cart_page.dart';
import 'package:ojos_app/features/home/presentation/pages/products_view_all_page.dart';
import 'package:ojos_app/features/order/presentation/pages/my_order_page.dart';
import 'package:ojos_app/features/profile/presentation/pages/profile_page.dart';
import 'package:ojos_app/features/reviews/presentation/pages/reviews_page.dart';
import 'package:ojos_app/features/section/presentation/pages/section_page.dart';
import 'package:ojos_app/features/user_management/domain/repositories/user_repository.dart';
import 'package:ojos_app/features/user_management/presentation/pages/sign_in_page.dart';
import 'package:ojos_app/features/wallet/presentation/pages/wallet_page.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'bill_photos/bill_photos.dart';
import 'home/presentation/pages/home_page.dart';
import 'notification/presentation/pages/notification_page.dart';
import 'order/presentation/pages/custom_order.dart';
import 'others/domain/entity/about_app_result.dart';
import 'others/domain/usecases/get_about_app.dart';
import 'others/presentation/pages/favorite_page.dart';
import 'others/presentation/pages/offers_page.dart';
import 'others/presentation/pages/settings_page.dart';
import 'others/presentation/pages/sub_pages/terms_condetion.dart';
import 'others/presentation/pages/sub_pages/use_policy_page.dart';

var _cancelToken = CancelToken();

BuildContext? testContext;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final notificationsService = NotificationsService();

class MainRootPage extends StatefulWidget {
  static const routeName = '/features/MainRootPage';
  final BuildContext? menuScreenContext;

  MainRootPage({this.menuScreenContext});

  @override
  _MainRootPageState createState() => _MainRootPageState();
}

class _MainRootPageState extends State<MainRootPage>
    with SingleTickerProviderStateMixin {
  PersistentTabController? _controller;
  bool? _hideNavBar;

  TabController? tabController;
  DateTime? currentBackPressTime;
  bool? isAuth;

  String stateLog = '';
  String? stateAsset;
  MenuSpecItem? stateMenu;
  Future<void>? _launched;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
    tabController!.addListener(() {
      if (tabController!.indexIsChanging) setState(() {});
    });
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
    notificationsService.selectNotificationSubject.listen((payload) {
      print('payload is : $payload');
      // if (notificationsService != null)
      //   notificationsService.onNotificationPressed(context, payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = globalSize.setHeightPercentage(100, context) -
        // appBar().preferredSize.height -
        MediaQuery.of(context).viewPadding.top;

    isAuth =
        BlocProvider.of<ApplicationBloc>(context).state.isUserAuthenticated ||
            BlocProvider.of<ApplicationBloc>(context).state.isUserVerified;

    if (isAuth!) {
      setState(() {
        stateLog = 'logout';
        stateAsset = AppAssets.logout_svg;
        stateMenu = MenuSpecItem.SignOut;
      });
    } else {
      setState(() {
        stateLog = 'login';
        stateAsset = AppAssets.login_svg;
        stateMenu = MenuSpecItem.SignInPage;
      });
    }

    return BlocListener<RootPageBloc, RootPageState>(
      listener: (context, state) {
        if (state is PageIndexState) {
          if (state.pageIndex != null) {
            tabController!.index = state.pageIndex;
            setState(() {});
          }
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<ApplicationBloc>(context),
        builder: (BuildContext context, state) => Scaffold(
          backgroundColor: globalColor.scaffoldBackGroundGreyColor,
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(14.w)),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 05.0, right: 5.0, bottom: 5.0),
                    color: globalColor.transparent,
                    child: Container(
                      height: 65.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14.w)),
                          color: globalColor.white),
                      child: TabBar(
                        controller: tabController,
                        indicatorColor: Colors.transparent,
                        indicatorPadding: EdgeInsets.all(0.0),
                        labelPadding: EdgeInsets.all(0.0),
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: <Widget>[
                          _buildTabItem(
                            Translations.of(context).translate('home'),
                            AppAssets.home,
                            PagesEnum.HOME_PAGE,
                          ),
                          _buildTabItem(
                              Translations.of(context)
                                  .translate('offers_drawer'),
                              AppAssets.offer,
                              PagesEnum.BRAND_PAGE),
                          Container(
                            width: 55.w,
                            height: 55.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: globalColor.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 10.0,
                                    // has the effect of softening the shadow
                                    spreadRadius: 3,
                                    offset: Offset(0,
                                        3), // has the effect of extending the shadow
                                  ),
                                ]),
                            child: Center(
                              child: Container(
                                width: 45.w,
                                height: 45.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: globalColor.primaryColor,
                                    border: Border.all(
                                        width: 1.0,
                                        color: globalColor.goldColor)),
                                child: Center(
                                  child:
                                      SvgPicture.asset(AppAssets.cart_btnv_svg),
                                ),
                              ),
                            ),
                          ),
                          _buildTabItem(
                              Translations.of(context)
                                  .translate('order_drawer'),
                              AppAssets.orders,
                              PagesEnum.ORDER_PAGE),
                          InkWell(
                            onTap: () {
                              Get.Get.to(GetDrawer(state, height,
                                  getListMaterialResideMenuItem1));
// Navigator.push(context, MaterialPageRoute(builder: (context) =>                           GetDrawer(),))                          print("aaaaaaa");
                            },
                            child: _buildTabItem(
                              Translations.of(context).translate('settings'),
                              AppAssets.settings,
                              PagesEnum.SettingsPage,
                            ),
                          ),

//                  if(!appSharedPrefs.isGuest)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: WillPopScope(
            onWillPop: _onWillPop,
            child: Container(
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  HomePage(
                    tabController: tabController,
                  ),
                  ProductsVeiwAllPage(
                    appBarTitle: "--",
                    fromHome: false,
                  ),
                  CartPage(
                    tabController: tabController,
                  ),
                  MyOrderPage(),
                  GetDrawer(state, height, getListMaterialResideMenuItem1),
                ],
              ),
            ),
          ),
        ),
      ),
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
            _onItemMenuPress(state);
          }
          //
        },
        child: Container(
            //
            // margin: EdgeInsets.only(
            //   right: isRtl(context) ? 10.0 : 0.0,
            // ),
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
        )

            // Rs.ResideMenuItem(
            //   titleStyle:
            //       textStyle.normalTSBasic.copyWith(color: globalColor.white),
            //   title: drawerMenuTitle,
            //   leftSpacing: 12.0,
            //   right: ishideArrow ? Container() :
            //   Container(
            //     child: Icon(
            //       utils.getLang() == 'ar'
            //           ? MaterialIcons.keyboard_arrow_left
            //           : MaterialIcons.keyboard_arrow_right,
            //       color: globalColor.primaryColor,
            //       size: 25,
            //     ),
            //   ),
            //   icon: SvgPicture.asset(
            //     drawerMenuIcon ?? AppAssets.home_nav_bar,
            //     color: globalColor.primaryColor,
            //     width: 20,
            //   ),
            // ),
            ),
      ),
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
        tabController!.animateTo(1);
        break;
      case MenuSpecItem.OrderPage:
        tabController!.animateTo(3);
        break;
      case MenuSpecItem.SectionPage:
        tabController!.animateTo(3);
        break;
      case MenuSpecItem.WalletPage:
        // if (await UserRepository.hasToken && isAuth) {
        //   Get.Get.toNamed(WalletPage.routeName);
        // }
        // else {
        //   showDialog(
        //     context: context,
        //     builder: (ctx) => LoginFirstDialog(),
        //   );
        // }
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
              setState(() {
                BlocProvider.of<ApplicationBloc>(context)
                    .add(UserLogoutEvent());
                isAuth = false;
              });
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

  Widget getMaterialResideMenuItem2(
      String drawerMenuTitle, String drawerMenuIcon,
      {MenuSpecItem? state,
      bool ishideArrow = true,
      tralingfunc,
      leadingWidget}) {
    return new InkWell(
      onTap: () {
        if (state == null)
          tralingfunc();
        else {
          // _menuController.closeMenu();
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
              // right: isRtl(context) ? 10.0 : 0.0,
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
              // Padding(
              //   child: ishideArrow
              //       ? Container()
              //       : Container(
              //           child: leadingWidget == null
              //               ? Icon(
              //                   utils.getLang() == 'ar'
              //                       ? MaterialIcons.keyboard_arrow_left
              //                       : MaterialIcons.keyboard_arrow_right,
              //                   color: globalColor.primaryColor,
              //                   size: 25,
              //                 )
              //               : leadingWidget,
              //         ),
              //   padding: EdgeInsets.only(right: 0),
              // )
            ],
          )

          // Rs.ResideMenuItem(
          //   titleStyle:
          //       textStyle.normalTSBasic.copyWith(color: globalColor.white),
          //   title: drawerMenuTitle,
          //   leftSpacing: 12.0,
          //   right: ishideArrow ? Container() :
          //   Container(
          //     child: Icon(
          //       utils.getLang() == 'ar'
          //           ? MaterialIcons.keyboard_arrow_left
          //           : MaterialIcons.keyboard_arrow_right,
          //       color: globalColor.primaryColor,
          //       size: 25,
          //     ),
          //   ),
          //   icon: SvgPicture.asset(
          //     drawerMenuIcon ?? AppAssets.home_nav_bar,
          //     color: globalColor.primaryColor,
          //     width: 20,
          //   ),
          // ),
          ),
    );
  }

  List<Widget> getListMaterialResideMenuItem1(ApplicationState state) {
    return [
      // getMaterialResideMenuItem(
      //    'home', AppAssets.home_nav_bar,
      //     state: MenuSpecItem.HomePage),

      getMaterialResideMenuItem(
          'edit_profile_drawer', AppAssets.profile_nav_bar, tralingfunc: () {
        Get.Get.toNamed(ProfilePage.routeName);
      }, state: MenuSpecItem.ProfilePage),

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

      getMaterialResideMenuItem(
        'notifications1',
        AppAssets.notification,
        tralingfunc: () async {
          if (await UserRepository.hasToken && isAuth!) {
            Get.Get.toNamed(NotificationPage.routeName);
          } else {
            showDialog(
              context: context,
              builder: (ctx) => LoginFirstDialog(),
            );
          }
        },
        ishideArrow: true,
      ),

//      getMaterialResideMenuItem(Translations.of(context).translate('messages'),
//          EvilIcons.envelope, 3),
//       getMaterialResideMenuItem('brand', AppAssets.brand_nav_bar,
//           state: MenuSpecItem.BrandPage),
//       getMaterialResideMenuItem(
//         'order_drawer',
//         AppAssets.order_drawer,
//         state: MenuSpecItem.OrderPage,
//       ),
//       getMaterialResideMenuItem(Translations.of(context).translate('section'),
//           AppAssets.section_nav_bar,
//           state: MenuSpecItem.SectionPage),

      getMaterialResideMenuItem('offers_drawer', AppAssets.sales,
          state: MenuSpecItem.OffersPage),

      //
      // getMaterialResideMenuItem('wallet_drawer', AppAssets.wallet_drawer,
      //     state: MenuSpecItem.WalletPage),

      InkWell(
        //////////////////////////////////////////////////////////// المحفظة سليم ////////////////////////////////////////////////////////////////////////
        onTap: () {
          Get.Get.to(WalletPage());
        },
        child: getMaterialResideMenuItem('Wallet', AppAssets.wallet_drawer,
            // state: MenuSpecItem.WalletPage,
            tralingfunc: () async{
              if (await UserRepository.hasToken && isAuth!) {
                Get.Get.toNamed(WalletPage.routeName);
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => LoginFirstDialog(),
                );
              }
        },
            leadingWidget: Container(
              width: 2000,
            )),
      ),

      getMaterialResideMenuItem('favorite_drawer', AppAssets.love,
          tralingfunc: () {
        Get.Get.toNamed(FavoritePage.routeName);
      }, state: MenuSpecItem.FavoritePage),

      InkWell(
        onTap: () {
          Get.Get.to(OnlineOrder());
        },
        child: getMaterialResideMenuItem('custom_order', AppAssets.order_drawer,
            tralingfunc: () {
          Get.Get.to(OnlineOrder());
        },
            leadingWidget: Container(
              width: 2000,
            )),
      ),
      InkWell(
        onTap: () {
          Get.Get.to(MyOrderPage());
        },
        child: getMaterialResideMenuItem(
            'Product_requests', AppAssets.order_drawer, tralingfunc: () {
          Get.Get.to(MyOrderPage());
        },
            leadingWidget: Container(
              width: 2000,
            )),
      ),

      //
      // getMaterialResideMenuItem('rated_drawer', AppAssets.review_drawer,
      //     state: MenuSpecItem.ReviewsPage),

      InkWell(
        // ******************************************************* صور الفواتير الفاتورة سليم *******************************************************
        onTap: () {
          Get.Get.toNamed(PillPhotosPage.routeName);
        },
        child: getMaterialResideMenuItem(
            'pill_photos', AppAssets.test_result_svg, tralingfunc: () {
          Get.Get.toNamed(PillPhotosPage.routeName);
        },
            leadingWidget: Container(
              width: 2000,
            )),
      ),

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

      // getMaterialResideMenuItem('settings', AppAssets.settings_drawer,
      //     state: MenuSpecItem.SettingsPage),
      // Divider(
      //   height: 1,
      //   color: globalColor.grey.withOpacity(0.5),
      // ),
      SizedBox(
        height: 5.h,
      ),
      Center(
          child: GestureDetector(
        onTap: () => setState(() {
          _launched = _launchInBrowser('https://greenthoob.com/');
        }),
        child: Image.asset(
          AppAssets.maroof,
          width: 100.w,
          height: 100.h,
        ),
      )),
      Container(
        height: 5.h,
      ),
      Row(
        children: [
          TextButton(
              onPressed: () {},
              child: Text(
                'تحتاج مساعدة ؟',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )),
        ],
      ),

      Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NetworkWidget(
              builder: (BuildContext context, AboutAppResult aboutAppResult) {
                return Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _lunchSocialMediaAction(
                              context, aboutAppResult.twitter!);
                        },
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 1, top: 3, bottom: 3, end: 1),
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(AppAssets.whats,
                                  color: Colors.white),
                            ),
                            backgroundColor: globalColor.primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _lunchSocialMediaAction(
                              context, aboutAppResult.twitter!);
                        },
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 1, top: 3, bottom: 3, end: 1),
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(AppAssets.twitter,
                                  color: Colors.white),
                            ),
                            backgroundColor: globalColor.primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _lunchSocialMediaAction(
                              context, aboutAppResult.instagram!);
                        },
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 1, top: 3, bottom: 3, end: 1),
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(AppAssets.snapchat,
                                  color: Colors.white),
                            ),
                            backgroundColor: globalColor.primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _lunchSocialMediaAction(
                              context, aboutAppResult.instagram!);
                        },
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 1, top: 3, bottom: 3, end: 1),
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(AppAssets.instagram,
                                  color: Colors.white),
                            ),
                            backgroundColor: globalColor.primaryColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _lunchSocialMediaAction(
                              context, aboutAppResult.instagram!);
                        },
                        child: Padding(
                          padding: const EdgeInsetsDirectional.only(
                              start: 1, top: 3, bottom: 3, end: 1),
                          child: CircleAvatar(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(AppAssets.tiktok,
                                  color: Colors.white),
                            ),
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
                          padding: const EdgeInsetsDirectional.only(
                              start: 1, top: 3, bottom: 3, end: 1),
                          child: CircleAvatar(
                            child: Icon(Icons.email_outlined,
                                color: globalColor.white),
                            backgroundColor: globalColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
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

          ],
        ),
      ),
      if (isAuth!) Center(
            child: StatefulBuilder(builder: (BuildContext context,
            void Function(void Function()) setState) {
        return InkWell(
            onTap: () {
              _onItemMenuPress(MenuSpecItem.SignOut);
            },
            child: Container(
              width: 200.w,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: globalColor.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(6)),
                margin: EdgeInsets.only(
                  // right: isRtl(context) ? 10.0 : 0.0,
                ),
                child: Text(
                  Translations.of(context)
                      .translate('logout'),
                  style: textStyle.normalTSBasic.copyWith(
                    color: globalColor.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                )),
        );
      }),
          ) else Center(
            child: StatefulBuilder(builder: (BuildContext context,
            void Function(void Function()) setState) {
        return InkWell(
            onTap: () {
              _onItemMenuPress(MenuSpecItem.SignInPage);
            },
            child: Container(
                width: 200.w,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: globalColor.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(6)),
                margin: EdgeInsets.only(
                  // right: isRtl(context) ? 10.0 : 0.0,
                ),
                child: Text(
                  Translations.of(context)
                      .translate('login'),
                  style: textStyle.normalTSBasic.copyWith(
                    color: globalColor.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )),
        );
      }),
          ),
      Container(
        height: 40.h,
      )
    ];
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

  @override
  void dispose() {
    tabController!.dispose();
    notificationsService.dispose();
    super.dispose();
  }

  Widget _buildTabItem(String text, String iconPath, PagesEnum page,
      [ispng = false, onTap]) {
    bool isSelected = (page.index == tabController!.index);

    final iconColor = isSelected ? globalColor.primaryColor : globalColor.black;
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: ScreensHelper.fromHeight(0.5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ispng
                ? AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    // width: ScreensHelper.fromWidth(isSelected ? 7.0 : 6.5),
                    // height: ScreensHelper.fromHeight(isSelected ? 7.0 : 6.5),
                    width: 25,
                    height: 25,
                    child: FittedBox(
                      child: Image.asset(
                        iconPath,
                        color: iconColor,
                      ),
                    ),
                  )
                : AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    width: 25,
                    height: 25,
                    // width: ScreensHelper.fromWidth(isSelected ? 6.0 : 5.5),
                    // height: ScreensHelper.fromHeight(isSelected ? 3.75 : 3.3),
                    child: FittedBox(
                      child: Image.asset(
                        iconPath,
                        color: iconColor,
                      ),
                    ),
                  ),
            Container(
              child: Text(
                text,
                style: textStyle.minTSBasic
                    .copyWith(color: iconColor, fontWeight: FontWeight.w200),
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (checkIndex()) return Future.value(false);

    if (tabController!.index != PagesEnum.HOME_PAGE.index) {
      BlocProvider.of<RootPageBloc>(context)
          .add(ChangePageEvent(PagesEnum.HOME_PAGE.index));
      return Future.value(false);
    }
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: Translations.of(context).translate('tab_to_exit'),
        backgroundColor: globalColor.primaryColor,
      );
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }

  bool checkIndex() {
    if (tabController!.index == 0) return false;
    // botNavBar.onTap(0);
    tabController!.animateTo(0);
    return true;
  }
}

enum PagesEnum {
  HOME_PAGE,
  BRAND_PAGE,
  CART_PAGE,
  ORDER_PAGE,
  SettingsPage,
}

Future<void> _launchInBrowser(String url) async {
  if (!await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
    headers: <String, String>{'my_header_key': 'my_header_value'},
  )) {
    throw 'Could not launch $url';
  }
}
