class ResponseWrapper<T> {
  final int? statusCode;
  final T? data;
  final String? message;

  ResponseWrapper({required this.statusCode, this.data, this.message});

  factory ResponseWrapper.success(T data) =>
      ResponseWrapper(statusCode: 200, data: data);

  factory ResponseWrapper.error(int statusCode, String message) =>
      ResponseWrapper(statusCode: statusCode, message: "Lỗi cmm rồi");
}
