part of 'backup_restore_view.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({super.key});

  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  late BackupRestoreCubit _backupRestoreCubit;
  @override
  void initState() {
    _backupRestoreCubit = context.read<BackupRestoreCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Backup restore")),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
        child: Column(
          children: [
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _backupRestoreCubit.backup();
                    },
                    child: const Text("Sao lưu"))),
            Gaps.hGap16,
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      _backupRestoreCubit.restore().then((value) {
                        if (value) {
                          Future.delayed(const Duration(seconds: 1)).then(
                              (value) => Navigator.pushNamedAndRemoveUntil(
                                  context, "/", (route) => false));
                        }
                      });
                    },
                    child: const Text("Khôi phục"))),
          ],
        ),
      ),
    );
  }
}
