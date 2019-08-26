import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fun_android/model/article.dart';
import 'package:fun_android/model/tree.dart';
import 'package:fun_android/ui/page/favourite_list_page.dart';
import 'package:fun_android/ui/page/article_list_page.dart';
import 'package:fun_android/ui/page/setting_page.dart';
import 'package:fun_android/ui/page/tab/home_second_floor_page.dart';
import 'package:fun_android/ui/page/user/login_page.dart';
import 'package:fun_android/ui/page/splash.dart';
import 'package:fun_android/ui/page/tab/tab_navigator.dart';
import 'package:fun_android/ui/page/article_detail_page.dart';
import 'package:fun_android/ui/page/user/register_page.dart';
import 'package:fun_android/ui/widget/page_route_anim.dart';

class RouteName {
  static const String splash = 'splash';
  static const String tab = '/';
  static const String homeSecondFloor = 'homeSecondFloor';
  static const String login = 'login';
  static const String register = 'register';
  static const String articleDetail = 'articleDetail';
  static const String treeList = 'treeList';
  static const String collectionList = 'collectionList';
  static const String setting = 'setting';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.tab:
        return NoAnimRouteBuilder(TabNavigator());
      case RouteName.homeSecondFloor:
        return SlideTopRouteBuilder(MyBlogPage());
      case RouteName.login:
        return CupertinoPageRoute(
            fullscreenDialog: true, builder: (_) => LoginPage());
      case RouteName.register:
        return CupertinoPageRoute(builder: (_) => RegisterPage());
      case RouteName.articleDetail:
        var article = settings.arguments as Article;
        return CupertinoPageRoute(
            builder: (_) => ArticleDetailPage(
                  article: article,
                ));
      case RouteName.treeList:
        var list = settings.arguments as List;
        Tree tree = list[0] as Tree;
        int index = list[1];
        return CupertinoPageRoute(
            builder: (_) => ArticleCategoryTabPage(tree, index));
      case RouteName.collectionList:
        return CupertinoPageRoute(builder: (_) => FavouriteListPage());
      case RouteName.setting:
        return CupertinoPageRoute(builder: (_) => SettingPage());
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
