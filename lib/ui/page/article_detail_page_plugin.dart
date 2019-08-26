import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fun_android/provider/provider_widget.dart';
import 'package:fun_android/ui/helper/favourite_helper.dart';
import 'package:fun_android/model/article.dart';
import 'package:fun_android/utils/string_utils.dart';
import 'package:fun_android/view_model/favourite_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  ArticleDetailPage({this.article});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<ArticleDetailPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  Completer<bool> _finishedCompleter = Completer();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      debugPrint('onStateChanged: ${state.type} ${state.url}');
      if (!_finishedCompleter.isCompleted &&
          state.type == WebViewState.finishLoad) {
        _finishedCompleter.complete(true);
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.article.link,
      withOverviewMode: false,
      appBar: AppBar(
        title: WebViewTitle(
          title: widget.article.title,
          future: _finishedCompleter.future,
        ),
        actions: <Widget>[
          IconButton(
//            tooltip: '用浏览器打开',
            icon: Icon(Icons.language),
            onPressed: () {
              launch(widget.article.link, forceSafariVC: false);
            },
          ),
          IconButton(
//            tooltip: '分享',
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(widget.article.link, subject: widget.article.title);
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
            ProviderWidget<FavouriteModel>(
              model: FavouriteModel(widget.article),
              builder: (context, model, child) => IconButton(
                icon: Icon(
                  model.article.collect ?? true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.redAccent[100],
                ),
                onPressed: () async {
                  await addFavourites(context, model, 'detail',
                      playAnim: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewTitle extends StatelessWidget {
  final String title;
  final Future<bool> future;

  WebViewTitle({this.title, this.future});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        FutureBuilder<bool>(
          future: future,
          initialData: false,
          builder: (context, snapshot) {
            return Offstage(
              offstage: snapshot.data,
              child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: CupertinoActivityIndicator()),
            );
          },
        ),
        Expanded(
            child: Text(
          //移除html标签
          StringUtils.removeHtmlLabel(title),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16),
        ))
      ],
    );
  }
}
