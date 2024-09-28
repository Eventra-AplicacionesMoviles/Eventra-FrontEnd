class CategoryEventResponse {
  final int id;
  final String name;

  CategoryEventResponse({required this.id, required this.name});

  factory CategoryEventResponse.fromJson(Map<String, dynamic> json) {
    return CategoryEventResponse(
      id: json['id'],
      name: json['name'],
    );
  }
}