// ignore_for_file: public_member_api_docs, sort_constructors_first
sealed class ResponseJsRuntime {}

class SuccessJsRuntime extends ResponseJsRuntime {
  final dynamic data;
  SuccessJsRuntime({
    required this.data,
  });

  SuccessJsRuntime copyWith({
    dynamic data,
  }) {
    return SuccessJsRuntime(
      data: data ?? this.data,
    );
  }
}

class ErrorJsRuntime extends ResponseJsRuntime {
  final String error;
  ErrorJsRuntime({
    required this.error,
  });

  ErrorJsRuntime copyWith({
    String? error,
  }) {
    return ErrorJsRuntime(
      error: error ?? this.error,
    );
  }
}


// response