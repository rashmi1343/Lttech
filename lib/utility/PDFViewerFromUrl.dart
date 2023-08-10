import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../presenter/Lttechprovider.dart';
import 'ColorTheme.dart';
import 'SizeConfig.dart';
import 'StatefulWrapper.dart';
import 'appbarWidget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFViewerFromUrl extends StatelessWidget {
  PDFViewerFromUrl({Key? key, required this.url}) : super(key: key);
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  final String url;

  int _stackToView = 1;
  InAppWebViewController? _webViewController;
  final GlobalKey webViewKey = GlobalKey();

  void _handleLoad() {
    _stackToView = 0;
  }

  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StatefulWrapper(
      onInit: () {
        print("url:$url");
        Future.delayed(Duration.zero, () {
          final pdfProvider =
              Provider.of<Lttechprovider>(context, listen: false);
          pdfProvider.loadFile(url);
        });
      },
      child: Scaffold(
        appBar: defaultAppBar(),
        body: Consumer<Lttechprovider>(
          builder: (context, provider, child) {
            return IndexedStack(
              index: _stackToView,
              children: [
                // Platform.isIOS
                //   ?
                Column(
                  children: <Widget>[
                    Expanded(
                      child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest: URLRequest(url: Uri.parse(url)),
                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                              supportZoom: true,
                              preferredContentMode:
                                  UserPreferredContentMode.MOBILE),
                        ),
                        onWebViewCreated: (InAppWebViewController controller) {
                          _webViewController = controller;
                        },
                        onLoadStart: (controller, url) {},
                        onLoadStop: (controller, url) {
                          Future.delayed(Duration.zero, () {
                            _handleLoad();
                            provider.setUpdateView = true;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // : provider.fileUrl.toLowerCase().endsWith('.pdf')
                //     ? Container(
                //         height: Platform.isIOS
                //             ? SizeConfig.safeBlockVertical * 75
                //             : SizeConfig.safeBlockVertical * 74,
                //         child:
                //
                //
                //         PDFView(
                //           filePath: provider.fileUrl,
                //           onViewCreated:
                //               (PDFViewController pdfViewController) {
                //             _controller.complete(pdfViewController);
                //           },
                //         ),
                //       )
                //     : provider.fileUrl.toLowerCase().endsWith('.png') ||
                //             provider.fileUrl
                //                 .toLowerCase()
                //                 .endsWith('.jpg') ||
                //             provider.fileUrl.toLowerCase().endsWith('.jpeg')
                //         ? Container(
                //             height: Platform.isIOS
                //                 ? SizeConfig.safeBlockVertical * 75
                //                 : SizeConfig.safeBlockVertical * 74,
                //             child: Center(
                //                 child: Image.network(provider.fileUrl)))
                //         : Container(
                //             child: Center(child: Text("PDF not available")),
                //           );
                Center(
                  child: CircularProgressIndicator(
                    color: ThemeColor.themeGreenColor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
