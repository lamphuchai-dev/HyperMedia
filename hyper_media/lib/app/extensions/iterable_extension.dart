extension IterableModifier<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) value) =>
      cast<E?>().firstWhere((v) => v != null && value(v), orElse: () => null);
}
