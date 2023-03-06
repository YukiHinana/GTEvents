class Response {
  final bool isSuccess;
  final Object data;
  
  const Response({
    required this.isSuccess,
    required this.data,
  });
  
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(isSuccess: json['isSuccess'], data: json['data']);
  }
}