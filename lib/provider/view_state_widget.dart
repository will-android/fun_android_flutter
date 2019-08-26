import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fun_android/config/resource_mananger.dart';
import 'package:fun_android/generated/i18n.dart';
import 'package:shimmer/shimmer.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  ViewStateWidget(
      {Key key,
      this.image,
      this.message,
      this.buttonText,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image ?? Icon(IconFonts.pageError, size: 80, color: Colors.grey[500]),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 150),
            child: Text(
              message ?? S.of(context).pageStateError,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Colors.grey),
            ),
          ),
          ViewStateButton(
            child: buttonText,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  const ViewStateEmptyWidget(
      {Key key,
      this.image,
      this.message,
      this.buttonText,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ??
          const Icon(
            IconFonts.pageEmpty,
            size: 100,
            color: Colors.grey,
          ),
      message: message ?? S.of(context).viewStateMessageEmpty,
      buttonText: buttonText ??
          Text(
            S.of(context).viewStateButtonRefresh,
            style: TextStyle(letterSpacing: 5),
          ),
    );
  }
}

/// 页面未授权
class ViewStateUnAuthWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  const ViewStateUnAuthWidget(
      {Key key,
      this.image,
      this.message,
      this.buttonText,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? ViewStateUnAuthImage(),
      message: message ?? S.of(context).viewStateMessageUnAuth,
      buttonText: buttonText ??
          Text(
            S.of(context).signIn,
            style: TextStyle(letterSpacing: 5),
          ),
    );
  }
}

/// 未授权图片
class ViewStateUnAuthImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'loginLogo',
      child: Image.asset(
        ImageHelper.wrapAssets('login_logo.png'),
        width: 130,
        height: 100,
        fit: BoxFit.fitWidth,
        color: Theme.of(context).accentColor,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const ViewStateButton({@required this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            S.of(context).pageStateRetry,
            style: TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}

/// 骨架屏
class ViewStateSkeletonList extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final int length;
  final IndexedWidgetBuilder builder;

  ViewStateSkeletonList(
      {this.length: 6, //一般屏幕长度够用
      this.padding = const EdgeInsets.all(7),
      @required this.builder});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool isDark = theme.brightness == Brightness.dark;
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Shimmer.fromColors(
        period: Duration(milliseconds: 1200),
        baseColor: isDark ? Colors.grey[700] : Colors.grey[350],
//        highlightColor: isDark ? Colors.grey[500] : Color.alphaBlend(
//          theme.accentColor.withAlpha(20), Colors.grey[100],),
        highlightColor: isDark ? Colors.grey[500] : Colors.grey[200],
        child: Padding(
          padding: padding,
          child: Column(
            children: List.generate(length, (index) => builder(context, index)),
          ),
        ),
      ),
    );
  }
}

/// 骨架屏 元素背景 ->形状及颜色
class SkeletonDecoration extends BoxDecoration {
  SkeletonDecoration({
    isCircle: false,
    isDark: false,
  }) : super(
          color: !isDark ? Colors.grey[350] : Colors.grey[700],
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        );
}
