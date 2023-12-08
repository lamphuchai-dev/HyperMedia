enum Flavor {
  dev,
  product,
}

class FlavorApp {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Hyper Media DEV';
      case Flavor.product:
        return 'Hyper Media';
      default:
        return 'title';
    }
  }
}
