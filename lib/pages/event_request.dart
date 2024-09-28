
class EventRequest {
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final String location;
  final int organizerId;
  final int categoryId;
  final String url;

  EventRequest({
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizerId,
    required this.categoryId,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'location': location,
      'organizerId': organizerId,
      'categoryId': categoryId,
      'url': url,
    };
  }
}