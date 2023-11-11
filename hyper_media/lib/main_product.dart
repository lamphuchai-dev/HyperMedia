import 'flavors.dart';

import 'main.dart' as runner;

Future<void> main() async {
  FlavorApp.appFlavor = Flavor.product;
  await runner.main();
}
