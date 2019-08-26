import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fun_android/generated/i18n.dart';
import 'package:fun_android/ui/helper/favourite_helper.dart';
import 'package:fun_android/config/resource_mananger.dart';
import 'package:fun_android/config/router_config.dart';
import 'package:fun_android/model/article.dart';
import 'package:fun_android/provider/provider_widget.dart';
import 'package:fun_android/view_model/favourite_model.dart';

import 'animated_provider.dart';
import 'favourite_animation.dart';
import 'article_tag.dart';

class ArticleItemWidget extends StatelessWidget {
  final Article article;
  final int index;
  final GestureTapCallback onTap;

  /// 首页置顶
  final bool top;

  ArticleItemWidget(this.article, {this.index, this.onTap, this.top: false})
      : super(key: ValueKey(article.id));

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Stack(
      children: <Widget>[
        Material(
          color: top
              ? Theme.of(context).accentColor.withAlpha(10)
              : backgroundColor,
          child: InkWell(
            onTap: onTap ??
                () {
                  Navigator.of(context)
                      .pushNamed(RouteName.articleDetail, arguments: article);
                },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  border: Border(
                bottom: Divider.createBorderSide(context, width: 0.7),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: ImageHelper.randomUrl(
                              key: article.author, width: 20, height: 20),
                          placeholder: (_, __) =>
                              ImageHelper.placeHolder(width: 20, height: 20),
                          errorWidget: (_, __, ___) =>
                              ImageHelper.error(width: 20, height: 20),
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          article.author,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Expanded(
                        child: SizedBox.shrink(),
                      ),
                      Text(article.niceDate,
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                  if (article.envelopePic.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: ArticleTitleWidget(article.title),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ArticleTitleWidget(article.title),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                article.desc,
                                style: Theme.of(context).textTheme.caption,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CachedNetworkImage(
                          imageUrl: article.envelopePic,
                          height: 60,
                          width: 60,
                          placeholder: (_, __) =>
                              ImageHelper.placeHolder(width: 60, height: 60),
                          errorWidget: (_, __, ___) =>
                              ImageHelper.error(width: 60, height: 60),
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                  Row(
                    children: <Widget>[
                      if (top) ArticleTag(S.of(context).article_tag_top),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          (article.superChapterName != null
                                  ? article.superChapterName + ' · '
                                  : '') +
                              (article.chapterName ?? ''),
                          style: Theme.of(context).textTheme.overline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: article.collect == null
              ? SizedBox.shrink()
              : ArticleFavouriteWidget(article),
        )
      ],
    );
  }
}

class ArticleTitleWidget extends StatelessWidget {
  final String title;

  ArticleTitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Html(
      padding: EdgeInsets.symmetric(vertical: 5),
      useRichText: false,
      data: title,
      defaultTextStyle: Theme.of(context).textTheme.subtitle,
    );
  }
}

/// 收藏按钮
class ArticleFavouriteWidget extends StatelessWidget {
  final Article article;

  ArticleFavouriteWidget(this.article);

  @override
  Widget build(BuildContext context) {
    ///位移动画的tag
    var uniqueKey = UniqueKey();
    return ProviderWidget<FavouriteModel>(
      model: FavouriteModel(article),
      builder: (_, model, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque, //否则padding的区域点击无效
          onTap: () async {
            if (!model.busy) {
              addFavourites(context, model, uniqueKey);
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Hero(
              tag: uniqueKey,
              child: ScaleAnimatedSwitcher(
                child: model.busy
                    ? SizedBox.shrink()
//                  ? SizedBox(
//                      height: 24,
//                      width: 24,
//                      child: CupertinoActivityIndicator(radius: 8),
//                    )
                    : Icon(
                        model.article.collect
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.redAccent[100]),
              ),
            ),
          ),
        );
      },
    );
  }
}
