import 'package:flutter/material.dart';

class TestUiPage extends StatefulWidget {
  const TestUiPage({super.key});

  @override
  State<TestUiPage> createState() => _TestUiPageState();
}

class _TestUiPageState extends State<TestUiPage> {
  @override
  void initState() {
    super.initState();
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
              ElevatedButton(onPressed: () {}, child: const Text("TEST"))
            ],
          ),
        ));
  }
}
