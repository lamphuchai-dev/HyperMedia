// ignore_for_file: depend_on_referenced_packages

import 'package:code_text_field/code_text_field.dart';
import 'package:extensions_client/home/widgets/log_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../widgets/result_widget.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;

  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    _homeCubit = context.read<HomeCubit>();

    const source = '''

// await Extension.querySelectorAll(html, "query")
// await Extension.querySelector(html, "query")
// await Extension.getAttributeText(html, "query","Attribute[src..]")
// await Extension.getElementById(html,"id","fun [text,outerHTML,innerHTML]")
// await Extension. getElementsByClassName(html,"className","fun")

async function execute(url, page) {
  console.log("fe")
  // const res = await Extension.request(url, {
  //   queryParameters: {
  //     page: page ?? 0,
  //   },
  // });
  return {};
}

// runFn(() => execute("url"));



''';
    _codeController = CodeController(
      text: source,
      language: javascript,
      stringMap: {
        "runFn":
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        "Extension":
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        "request":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "querySelector":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "querySelectorAll":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "getElementById":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "getElementsByClassName":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "queryXPath":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "removeSelector":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
        "getAttributeText":
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.teal),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _homeCubit.onGo(context);
                    },
                    child: const Text("RUN")),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      _codeController?.clear();
                      _codeController?.insertStr('runFn(() => execute("url"))');
                    },
                    child: const Text("Clear code")),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      _homeCubit.clearLog();
                    },
                    child: const Text("Clear log")),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: CodeTheme(
                    data: const CodeThemeData(styles: atomOneDarkTheme),
                    child: CodeField(
                      controller: _codeController!,
                      maxLines: null,
                      textStyle: const TextStyle(fontFamily: 'SourceCode'),
                      onChanged: (value) {
                        _homeCubit.jsCodeTextEditingController.text = value;
                      },
                    ),
                  ),
                )),
            const SizedBox(
              height: 12,
            ),
            const Expanded(
                child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(tabs: [
                    Tab(
                      text: "result",
                    ),
                    Tab(
                      text: "log",
                    )
                  ]),
                  Expanded(
                    child: TabBarView(children: [ResultWidget(), LogWidget()]),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
