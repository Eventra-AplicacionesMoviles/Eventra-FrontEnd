class Ticket {
  final int ticketID;
  final String event;
  final double price;
  final int totalAvailable;
  final String category;
  final String description;

  Ticket({
    required this.ticketID,
    required this.event,
    required this.price,
    required this.totalAvailable,
    required this.category,
    required this.description,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketID: json['ticketID'],
      event: json['event'],
      price: json['price'],
      totalAvailable: json['totalAvailable'],
      category: json['category'],
      description: json['description'],
    );
  }
}