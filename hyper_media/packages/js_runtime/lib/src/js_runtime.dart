import 'dart:async';
import 'dart:convert';

import 'package:dio_client/index.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:js_runtime/js_runtime.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../utils/logger.dart';
import 'browser_headless.dart';

class JsRuntime {
  JsRuntime({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();
  late JavascriptRuntime _runtime;

  final _logger = Logger("JsRuntime");
  final DioClient _dioClient;

  final BrowserHeadless _browserHeadless = BrowserHeadless();

  DioClient get getDioClient => _dioClient;

  final StreamController<dynamic> _streamController =
      StreamController.broadcast();

  Stream<dynamic> get log => _streamController.stream;

  Future<bool> initRuntime(
      {String pathSource = "assets/js/extension.js", String? dirCookie}) async {
    final jsExtension = await rootBundle.loadString(pathSource);
    if (dirCookie != null) {
      _dioClient.enableCookie(dir: dirCookie);
    }
    _runtime = getJavascriptRuntime();
    _runtime.onMessage('request', (dynamic args) async {
      _logger.log("request args ::: $args");
      try {
        final dataResponse = await _dioClient.request<String>(
          args[0],
          data: args[1]['formData'] != null
              ? FormData.fromMap(args[1]['formData'])
              : args[1]['data'],
          queryParameters: args[1]['queryParameters'] ?? {},
          options: Options(
            headers: args[1]['headers'] ?? {},
            method: args[1]['method'] ?? 'get',
          ),
        );
        return dataResponse;
      } catch (error) {
        return null;
      }
    });

    _runtime.onMessage('log', (dynamic args) {
      _logger.log(args, name: "LOG");
      _streamController.add(List<String>.from(args));
    });

    _runtime.onMessage('querySelector', (dynamic args) {
      try {
        final content = args[0];
        final selector = args[1];
        final fun = args[2];

        final doc = parse(content).querySelector(selector);
        switch (fun) {
          case 'text':
            return doc?.text ?? '';
          case 'outerHTML':
            return doc?.outerHtml ?? '';
          case 'innerHTML':
            return doc?.innerHtml ?? '';
          default:
            return doc?.outerHtml ?? '';
        }
      } catch (error) {
        rethrow;
      }
    });

    _runtime.onMessage('querySelectorAll', (dynamic args) async {
      try {
        final content = args[0];
        final selector = args[1];
        final doc = parse(content).querySelectorAll(selector);
        if (doc.isEmpty) return [];
        final elements = jsonEncode(doc.map((e) {
          return e.outerHtml;
        }).toList());
        return elements;
      } catch (error) {
        rethrow;
      }
    });

    _runtime.onMessage('getElementById', (dynamic args) async {
      final content = args[0];
      final id = args[1];
      final fun = args[2];
      final doc = parse(content).getElementById(id);
      switch (fun) {
        case 'text':
          return doc?.text ?? '';
        case 'outerHTML':
          return doc?.outerHtml ?? '';
        case 'innerHTML':
          return doc?.innerHtml ?? '';
        default:
          return doc?.outerHtml ?? '';
      }
    });

    _runtime.onMessage('getElementsByClassName', (dynamic args) async {
      final content = args[0];
      final className = args[1];
      final doc = parse(content).getElementsByClassName(className);
      if (doc.isEmpty) return [];
      final elements = jsonEncode(doc.map((e) {
        return e.outerHtml;
      }).toList());

      return elements;
    });

    _runtime.onMessage('queryXPath', (args) {
      final content = args[0];
      final selector = args[1];
      final fun = args[2];

      final xpath = HtmlXPath.html(content);
      final result = xpath.queryXPath(selector);

      switch (fun) {
        case 'attr':
          return result.attr ?? '';
        case 'attrs':
          return jsonEncode(result.attrs);
        case 'text':
          return result.node?.text;
        case 'allHTML':
          return result.nodes
              .map((e) => (e.node as Element).outerHtml)
              .toList();
        case 'outerHTML':
          return (result.node?.node as Element).outerHtml;
        default:
          return result.node?.text;
      }
    });

    _runtime.onMessage('removeSelector', (dynamic args) {
      final content = args[0];
      final selector = args[1];
      final doc = parse(content);
      doc.querySelectorAll(selector).forEach((element) {
        element.remove();
      });
      return doc.outerHtml;
    });

    _runtime.onMessage('getAttributeText', (args) {
      final content = args[0];
      final selector = args[1];
      final attr = args[2];
      final doc = parse(content).querySelector(selector);
      return doc?.attributes[attr];
    });

    _runtime.onMessage('base64', (args) {
      try {
        final content = args[0];
        final type = args[1];
        switch (type) {
          case "decode":
            return utf8.decode(base64.decode(content));
          case "encode":
            return base64.encode(utf8.encode(content));
          default:
            return null;
        }
      } catch (error) {
        return null;
      }
    });

    _runtime.onMessage('launchFetchBlock', (args) async {
      final url = args[0];
      final regex = args[1];
      final timeout = args[2];
      return await _browserHeadless.launchFetchBlock(
          url: url, regex: regex, timeout: timeout ?? 20000);
    });

    _runtime.onMessage('launchXhrBlock', (args) async {
      final url = args[0];
      final regex = args[1];
      final timeout = args[2];
      return await _browserHeadless.launchXhrBlock(
          url: url, regex: regex, timeout: timeout ?? 20000);
    });

    _runtime.onMessage('launch', (args) async {
      final url = args[0];
      final timeout = args[1];
      return await _browserHeadless.launch(url: url, timeout: timeout ?? 20000);
    });

    _runtime.onMessage('callJs', (args) async {
      final source = args[0];
      final timeout = args[1];
      return await _browserHeadless.callJs(
          source: source, timer: timeout ?? 20000);
    });

    _runtime.onMessage('waitUrl', (args) async {
      final url = args[0];
      final timeout = args[1];
      return await _browserHeadless.waitUrl(
          url: url, timeout: timeout ?? 20000);
    });

    _runtime.onMessage('waitUrlAjaxResponse', (args) async {
      final url = args[0];
      final timeout = args[1];
      return await _browserHeadless.waitUrlAjaxResponse(
          url: url, timeout: timeout ?? 20000);
    });
    _runtime.onMessage('getHtml', (args) async {
      return await _browserHeadless.getHtml();
    });
    _runtime.onMessage('loadUrl', (args) async {
      return await _browserHeadless.launch(url: args[0]);
    });

    _runtime.onMessage('setUserAgent', (args) {
      _browserHeadless.setUserAgent(args[0]);
      return true;
    });

    _runtime.onMessage('disposeBrowser', (args) async {
      return await _browserHeadless.dispose();
    });

    final result = _runtime.evaluate(jsExtension);
    _logger.log("init jsRuntime : ${!result.isError}");
    return !result.isError;
  }

  void clearBrowser() async {
    await _browserHeadless.clear();
  }

  Future<T> _runExtension<T>(Future<T> Function() fun) async {
    try {
      return await fun();
    } catch (e) {
      _logger.error(e, name: "_runExtension");
      rethrow;
    }
  }

  Future<ResponseJsRuntime> runJsCode({required String jsScript}) async {
    return _runExtension(() async {
      final jsResult =
          await _runtime.handlePromise(await _evaluateAsyncJsScript(jsScript));
      try {
        return jsResult.toResponse;
      } catch (error) {
        return jsResult.fromToError(error.toString());
      }
    });
  }

  bool _evaluateJsScript(String code) {
    try {
      final jsEvalResult = _runtime.evaluate(code);
      return jsEvalResult.isError;
    } catch (error) {
      throw JsRuntimeException(error.toString());
    }
  }

  Future<JsEvalResult> _evaluateAsyncJsScript(String code) async {
    try {
      final jsEvalResult = await _runtime.evaluateAsync(code);
      if (jsEvalResult.isError) {
        throw JsRuntimeException("Run script extension error");
      }
      return jsEvalResult;
    } catch (error) {
      throw JsRuntimeException(error.toString());
    }
  }

  Future<dynamic> tesJs(String source) async {
    return _runExtension(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime
          .handlePromise(await _evaluateAsyncJsScript('stringify(()=>test())'));
      return jsResult.toJson;
    });
  }

  Future<T> getTabs<T>(String source) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime
          .handlePromise(await _evaluateAsyncJsScript('stringify(()=>tabs())'));
      return jsResult.toResult;
    });
  }

  Future<T> getList<T>(
      {required String url,
      required String source,
      int page = 1,
      dynamic arg}) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime.handlePromise(
          await _evaluateAsyncJsScript(
              'stringify(()=>home("$url",$page,$arg))'));
      return jsResult.toResult;
    });
  }

  Future<T> getDetail<T>({required String url, required String source}) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime.handlePromise(
          await _evaluateAsyncJsScript('stringify(()=>detail("$url"))'));
      return jsResult.toResult;
    });
  }

  Future<T> getChapters<T>(
      {required String url, required String source, int? page = 1}) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime.handlePromise(
          await _evaluateAsyncJsScript('stringify(()=>chapters("$url"))'));
      return jsResult.toResult;
    });
  }

  Future<T> getChapter<T>({required String url, required String source}) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime.handlePromise(
          await _evaluateAsyncJsScript('stringify(()=>chapter("$url"))'));
      return jsResult.toResult;
    });
  }

  Future<T> getSearch<T>(
      {required String url,
      required String keyWord,
      int? page,
      required String source}) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime.handlePromise(
          await _evaluateAsyncJsScript(
              'stringify(()=>search("$url","$keyWord",$page))'));
      return jsResult.toResult;
    });
  }

  Future<T> getGenre<T>({required String url, required String source}) async {
    return _runExtension<T>(() async {
      _evaluateJsScript(source);
      final jsResult = await _runtime.handlePromise(
          await _evaluateAsyncJsScript('stringify(()=>genre("$url"))'));
      return jsResult.toResult;
    });
  }
}

extension Json on JsEvalResult {
  dynamic get toJson {
    try {
      final json = jsonDecode(stringResult);
      if (json.runtimeType.toString() == "String") {
        return jsonDecode(json);
      }
      return json;
    } catch (error) {
      return stringResult;
    }
  }

  ResponseJsRuntime get toResponse {
    final map = toJson;
    if (map is! Map) return ErrorJsRuntime(error: "Extension error");
    if (map["type"] == "success") {
      return SuccessJsRuntime(data: map["data"]);
    }
    return ErrorJsRuntime(error: map["data"] ?? "Error");
  }

  dynamic get toResult {
    final map = toJson;
    if (map is! Map) {
      throw JsRuntimeException("Extension error");
    }
    if (map["type"] == "success") {
      return map["data"];
    }
    throw JsRuntimeException(map["data"] ?? "Error");
  }

  ResponseJsRuntime fromToError(String error) {
    return ErrorJsRuntime(error: error);
  }
}
