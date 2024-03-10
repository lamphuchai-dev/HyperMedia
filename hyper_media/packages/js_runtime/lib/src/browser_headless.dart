// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:html/parser.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:uuid/uuid.dart';

import '../utils/logger.dart';

class BrowserHeadless {
  final _logger = Logger("BrowserHeadless");
  HeadlessInAppWebView? _browserHeadless;
  InAppWebViewController? _webController;
  String? _userAgent;
  var uuid = const Uuid();
  // Map<String, HeadlessInAppWebView> mapBrowserHeadless = {};
  final Map<String, Tmp> _map = {};

  // List<String> _urls = [];

  // List<String> get getUrls => _urls;

  // dùng để mở web theo url và lấy url fetchRequest trong web đó theo điều kiện regex
  /* 

  final result = await _browserHeadless.launchFetchBlock(
      url:"https://motchillzzz.tv/xem-phim-7-escape-tap-1-2d47",
      regex: ".*?/api/play/get33*?",
      timeout: 10);
  print(result);

  */

  // Future<void> closeByKey(String key) async {
  //   if (mapBrowserHeadless.containsKey(key)) {
  //     await mapBrowserHeadless[key]!.dispose();
  //     mapBrowserHeadless.remove(key);
  //     _logger.log("closeByKey", name: "dispose");
  //   }
  // }

  Future<void> closeByKey(String key) async {
    if (_map.containsKey(key)) {
      final tmp = _map[key]!;
      if (tmp.headlessInAppWebView.isRunning()) {
        await tmp.headlessInAppWebView.dispose();
        if (tmp.timer.isActive) {
          tmp.timer.cancel();
        }
      }
      // print(tmp.headlessInAppWebView.id);
      // print(tmp.headlessInAppWebView.isRunning());

      _map.remove(key);
      _logger.log("closeByKey", name: "dispose");
    }
  }

  void setUserAgent(String userAgent) {
    _userAgent = userAgent;
  }

  Future<String?> launchFetchBlock(
      {required String url, required String regex, int timeout = 20000}) async {
    final completer = Completer<String?>.sync();
    final regexp = RegExp(regex);
    final key = uuid.v1();

    final browserHeadless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(url),
      ),
      initialSettings: InAppWebViewSettings(
          useShouldInterceptFetchRequest: true, userAgent: _getUserAgent),
      onWebViewCreated: (controller) async {
        final uri = await controller.getUrl();
        _logger.log(uri.toString(), name: "onWebViewCreated launchFetchBlock");
      },
      shouldInterceptFetchRequest: (controller, fetchRequest) async {
        String urlFetch = fetchRequest.url.toString();

        _logger.log(urlFetch,
            name: "shouldInterceptFetchRequest launchFetchBlock");
        final match = regexp.firstMatch(urlFetch);
        if (match != null) {
          if (!urlFetch.startsWith("http")) {
            final source = Uri.parse(url);
            urlFetch = "${source.scheme}://${source.host}$urlFetch";
          }
          completer.complete(urlFetch);
          closeByKey(key);
        }
        return fetchRequest;
      },
    );
    await browserHeadless.run();
    Timer timer = Timer(Duration(milliseconds: timeout), () {
      if (!completer.isCompleted) {
        completer.complete(null);
        closeByKey(key);
      }
    });
    _map[key] = Tmp(headlessInAppWebView: browserHeadless, timer: timer);
    return completer.future;
  }

  String get _getUserAgent {
    if (_userAgent != null) return _userAgent!;

    if (Platform.isAndroid) {
      return "Mozilla/5.0 (Linux; Android 13; Pixel 7 Pro) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36";
    } else if (Platform.isIOS) {
      return "Mozilla/5.0 (iPhone14,3; U; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/19A346 Safari/602.1";
    }

    return "Mozilla/5.0 (Linux; Android 13; SM-S901B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36";
  }

  // Mở web theo url , kết thúc tải trang trả lại html;
  Future<String?> launch({required String url, int timeout = 20000}) async {
    if (_browserHeadless != null) {
      await _browserHeadless?.dispose();
    }
    final completer = Completer<String?>.sync();

    _browserHeadless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
          useShouldInterceptAjaxRequest: true,
          useShouldInterceptFetchRequest: true,
          userAgent: _getUserAgent,
          useOnLoadResource: true),
      onWebViewCreated: (controller) async {
        final uri = await controller.getUrl();
        _logger.log(uri.toString(), name: "launch onWebViewCreated");
        _webController = controller;
      },
      onLoadStop: (controller, url) async {
        final html = await controller.getHtml();
        if (!completer.isCompleted) {
          completer.complete(html);
        }
      },
      onReceivedError: (controller, request, error) {
        // if (!completer.isCompleted) {
        //   completer.complete(null);
        // }
      },
    );
    await _browserHeadless?.run();
    Timer(Duration(milliseconds: timeout), () {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });
    return completer.future;
  }

  Future<void> callJs({required String source, required int timer}) async {
    Timer(Duration(milliseconds: timer), () {
      if (_webController != null) {
        _logger.log("callJs");
        _webController?.evaluateJavascript(source: source);
      }
    });
  }

  Future<List<String>> waitUrl(
      {required String url, int timeout = 15000}) async {
    if (_browserHeadless != null && _browserHeadless!.isRunning()) {
      final regexp = RegExp(url);
      List<String> urls = [];
      final completer = Completer<List<String>>.sync();

      _browserHeadless?.platform.params.onLoadResource =
          (controller, resource) {
        String urlFetch = resource.url.toString();
        final match = regexp.firstMatch(urlFetch);
        if (match != null && !completer.isCompleted) {
          urls.add(urlFetch);
        }
      };
      Timer(Duration(milliseconds: timeout), () {
        if (!completer.isCompleted) {
          completer.complete(urls);
        }
      });
      return completer.future;
    }
    return [];
  }

  Future<String?> launchXhrBlock(
      {required String url, required String regex, int timeout = 20000}) async {
    final completer = Completer<String?>.sync();
    final key = uuid.v1();

    final regexp = RegExp(regex);
    final browserHeadless = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(url),
      ),
      initialSettings: InAppWebViewSettings(
          useShouldInterceptAjaxRequest: true, userAgent: _getUserAgent),
      onWebViewCreated: (controller) async {
        final uri = await controller.getUrl();
        _logger.log(uri.toString(), name: "onWebViewCreated launchXhrBlock");
      },
      shouldInterceptAjaxRequest: (controller, ajaxRequest) async {
        String urlFetch = ajaxRequest.url.toString();
        final match = regexp.firstMatch(urlFetch);
        if (match != null) {
          if (!urlFetch.startsWith("http")) {
            final source = Uri.parse(url);
            urlFetch = "${source.scheme}://${source.host}$urlFetch";
          }
          _logger.log(urlFetch, name: "launchXhrBlock");
          await closeByKey(key);
          completer.complete(urlFetch);
        }
        return ajaxRequest;
      },
    );
    await browserHeadless.run();

    Timer timer = Timer(Duration(milliseconds: timeout), () async {
      if (!completer.isCompleted) {
        await closeByKey(key);
        completer.complete(null);
      }
    });
    _map[key] = Tmp(headlessInAppWebView: browserHeadless, timer: timer);

    return completer.future;
  }

  Future<Map<String, dynamic>?> waitUrlAjaxResponse(
      {required String url, int timeout = 15000}) async {
    if (_browserHeadless != null && _browserHeadless!.isRunning()) {
      final regexp = RegExp(url);
      final completer = Completer<Map<String, dynamic>?>.sync();
      _browserHeadless?.platform.params.onAjaxReadyStateChange =
          (controller, ajaxRequest) async {
        String urlFetch = ajaxRequest.url.toString();
        final match = regexp.firstMatch(urlFetch);
        if (match != null &&
            !completer.isCompleted &&
            ajaxRequest.responseText != null &&
            ajaxRequest.responseText != "") {
          try {
            if (!completer.isCompleted) {
              final text = json.decode(ajaxRequest.responseText!);
              completer.complete({"url": urlFetch, "response": text});
            }
          } catch (error) {
            // print("error");
            //
          }
        }
        return AjaxRequestAction.PROCEED;
      };
      Timer(Duration(milliseconds: timeout), () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      });
      return completer.future;
    }
    return null;
  }

  // Ajax

  Future<void> loadUrl(String url) async {
    return _webController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  Future<String?> getHtml() async {
    final content = await _webController?.getHtml();
    final doc = parse(content);
    return doc.outerHtml;
  }

  Future<void> dispose() async {
    _logger.log("dispose browser", name: "dispose");
    if (_browserHeadless != null && _browserHeadless!.isRunning()) {
      await _browserHeadless?.dispose();
      _webController?.dispose();
    }
  }

  Future<void> clear() async {
    _map.clear();
  }
}

class Tmp {
  final HeadlessInAppWebView headlessInAppWebView;
  final Timer timer;
  Tmp({
    required this.headlessInAppWebView,
    required this.timer,
  });
}
