import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailBlogPage extends StatefulWidget {
  const DetailBlogPage(
      {super.key, this.url, this.head});

  final String? url;
  final String? head;

  @override
  State<DetailBlogPage> createState() => _DetailBlogPageState();
}

class _DetailBlogPageState extends State<DetailBlogPage> {
  WebViewController? _controller;

  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Gunakan URL kustom jika disediakan
            if (widget.url!.isNotEmpty) {
              return NavigationDecision.navigate;
            }

            if (request.url.startsWith('https://yatimmandiri.org/news/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url ?? 'https://yatimmandiri.org/news/'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: WebViewWidget(controller: _controller!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
