part of 'settings_view.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsCubit _settingsCubit;
  final local = getIt<LocalNotificationService>();
  @override
  void initState() {
    _settingsCubit = context.read<SettingsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Settings")),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  // local.showOrUpdateDownloadStatus("title", "body",
                  //     maxProgress: 100,
                  //     progress: 50,
                  //     showActions: true,
                  //     isDetailed: true);
                  final tmp = await getApplicationSupportDirectory();
                  print(tmp);
                },
                child: Text("Show"))
          ],
        ));
  }
}
