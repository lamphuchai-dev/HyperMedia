import 'flavors.dart';

import 'main.dart' as runner;

Future<void> main() async {
  FlavorApp.appFlavor = Flavor.dev;
  await runner.main();
}
