import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  WebViewScreen({Key? key, required this.title, required this.url})
      : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.title,
        ),
        body: Container(
          child: WebView(
            initialUrl: widget.url,
            gestureNavigationEnabled: true,
          ),
        ),
      ),
    );
  }
}
