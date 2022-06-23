import 'package:flutter/material.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:vendor/widget/progress_indecator.dart';
class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  WebViewScreen({Key? key, required this.title, required this.url}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.title,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            WebView(
              initialUrl: widget.url,
              zoomEnabled: true,
              onPageFinished: (url) {
                isLoading = false;
                setState(() {});
              },
              gestureNavigationEnabled: true,
            ),
            isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: CircularLoader(),
                  )
                : SizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }
}
