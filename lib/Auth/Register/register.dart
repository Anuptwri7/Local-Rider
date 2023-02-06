
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {


  InAppWebViewController? _controller ;
  PullToRefreshController? _refreshController;
  late var url;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register for a Rider',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.red.shade50,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('http://167.71.233.139/register/rider')),
      )
    );
  }
}
