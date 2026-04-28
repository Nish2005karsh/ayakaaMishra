class ApiStatus {
  final String code;
  final String message;

  bool get isSuccess => code == '0';

  const ApiStatus({required this.code, required this.message});

  factory ApiStatus.fromJson(Map<String, dynamic> json) {
    return ApiStatus(
      code: json['code']?.toString() ?? '1',
      message: json['message']?.toString() ?? 'Unknown error',
    );
  }
}
