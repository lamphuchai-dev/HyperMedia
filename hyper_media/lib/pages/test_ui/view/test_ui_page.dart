import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_media/app/constants/index.dart';
import 'package:js_runtime/js_runtime.dart';
import '../cubit/test_ui_cubit.dart';

class TestUiPage extends StatefulWidget {
  const TestUiPage({super.key});

  @override
  State<TestUiPage> createState() => _TestUiPageState();
}

class _TestUiPageState extends State<TestUiPage> {
  late TestUiCubit _testUiCubit;

  // BrowserHeadless _browserHeadless = BrowserHeadless();

  final JsRuntime _runtime = JsRuntime();

  @override
  void initState() {
    _testUiCubit = context.read<TestUiCubit>();

    init();
    super.initState();
  }

  void init() async {
    final isReady =
        await _runtime.initRuntime(pathSource: AppAssets.jsScriptExtension);
    print(isReady);
  }

  @override
  Widget build(BuildContext context) {
    // return MyApp();
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Test ui")),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    // final result = await _runtime.launchFetchBlock(
                    //     url:
                    //         "https://motchillzzz.tv/xem-phim-7-escape-tap-1-2d47",
                    //     regex: ".*?/api/play/get*?",
                    //     timeout: 10000);
                    // print(result);
                  },
                  child: const Text("launchFetchBlock")),
              ElevatedButton(
                  onPressed: () async {
                    // final result = await _browserHeadless.launch(
                    //     url:
                    //         "https://metruyencv.com/truyen/toan-dan-tro-choi-tu-zombie-tan-the-bat-dau-treo-may",
                    //     timeout: 20000);

                    // _browserHeadless.callJs(
                    //     source:
                    //         "for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click()}}",
                    //     timer: 1);

                    // final tmp = await _browserHeadless.waitUrl(
                    //     url: ".*?api.truyen.onl/v2/chapters.*?",
                    //     timeout: 10000);
                    // print(tmp.length);
                  },
                  child: const Text("launch")),
              ElevatedButton(
                  onPressed: () async {
                    // final result = await _browserHeadless.launch(
                    //     url:
                    //         "https://metruyencv.com/truyen/toan-dan-tro-choi-tu-zombie-tan-the-bat-dau-treo-may",
                    //     timeout: 20000);

                    // _browserHeadless.callJs(
                    //     source:
                    //         "for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click()}}",
                    //     timer: 1);

                    // final tmp = await _browserHeadless.waitUrlAjaxResponse(
                    //     url: ".*?api.truyen.onl/v2/chapters*?", timeout: 10000);
                    // print(tmp.toString());
                    // _browserHeadless.dispose();
                  },
                  child: const Text("waitUrlAjaxResponse")),
              ElevatedButton(
                  onPressed: () async {
                    String testCode = '''

//   async function test() {
//   console.log("test");

//    const tmp =await Browser.launch("https://metruyencv.com/truyen/toan-dan-tro-choi-tu-zombie-tan-the-bat-dau-treo-may",10000)

//    Browser.callJs("for(const a of document.querySelectorAll('a')){if(a.textContent.includes('Danh sách chương')){a.click()}}",1000)    

// const data =  await Browser.waitUrlAjaxResponse(".*?api.truyen.onl/v2/chapters*?",10000)
// Browser.close()  
//   return data;

//   // const tmp = await Browser.launchFetchBlock("https://motchillzzz.tv/xem-phim-7-escape-tap-1-2d47",".*?/api/play/get*?")
//   // return [tmp];
// }


 const data = await Browser.launchFetchBlock("https://metruyencv.com/truyen/?sort_by=new_chap_at&status=-1&props=-1&limit=20",".*?api.truyen.onl/v2/books*?", 10000);
  return data;


''';
                    final tmp = await _runtime.runJsCode(jsScript: '''

async function home(url, page) {
  const data = await Browser.launchXhrBlock(
    url,
    ".*?api.truyen.onl/v2/books*?",
    10000
  );
  return data;
}

runFn(() =>
  home(
    "https://metruyencv.com/truyen/?sort_by=new_chap_at&status=-1&props=-1&limit=20"
  )
);

''');

                    print(tmp);
                  },
                  child: const Text("TEST CODE")),
              ElevatedButton(
                  onPressed: () async {
                    final jsChapter =
                        await rootBundle.loadString("assets/js/chapters.js");
                    final tm = await _runtime.getChapters(
                        url:
                            "https://phetruyen.net/vua-moi-huy-hon-da-bi-da-ho-ly-lua-ket-hon",
                        source: jsChapter);
                    print(tm);
                  },
                  child: const Text("Chapter"))
            ],
          ),
        ));
  }
}
