import 'dart:collection';

class StackCollection<E> {
  final LinkedHashMap<int, E> _map = LinkedHashMap<int, E>();

  void push(E value) => _map[_map.length + 1] = value;

  E? pop() {
    E? value = _map[_map.length];
    _map.remove(_map.length);
    return value;
  }

  E? peek() => _map[_map.length];

  E? peekN(int n) => _map[_map.length - n];

  void clear() {
    _map.clear();
  }
}
