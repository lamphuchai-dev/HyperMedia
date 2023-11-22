// ignore_for_file: public_member_api_docs, sort_constructors_first
class JsRuntimeException implements Exception {
  final String? message;
  JsRuntimeException(this.message);

  @override
  String toString() => 'JsRuntimeException(error: $message)';
}
