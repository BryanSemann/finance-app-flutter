class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic)? fromMap,
  ) {
    return ApiResponse<T>(
      success: map['success'] ?? false,
      message: map['message'] ?? '',
      data: map['data'] != null && fromMap != null
          ? fromMap(map['data'])
          : map['data'],
      errors: map['errors'],
    );
  }

  factory ApiResponse.success(T data, [String message = 'Sucesso']) {
    return ApiResponse<T>(success: true, message: message, data: data);
  }

  factory ApiResponse.error(String message, [Map<String, dynamic>? errors]) {
    return ApiResponse<T>(success: false, message: message, errors: errors);
  }
}
