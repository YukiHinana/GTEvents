class Event {
  int eventId;
  String title;
  String location;
  String description;
  int eventDate;
  int capacity;
  int fee;

  Event(this.eventId, this.title, this.location, this.description,
      this.eventDate, this.capacity, this.fee);

  factory Event.fromJson(dynamic json) {
    return Event(json['id'] as int, json['title'] as String,
        json['location'] as String, json['description'] as String,
        json['eventDate'] as int, json['capacity'] as int,
        json['fee'] as int);
        // json['author']['username'] as String, json['location'] as String);
  }

  @override
  String toString() {
    return'{$eventId, $title, $location, $description, $eventDate, $capacity, $fee}';
    // return '{ $eventId, $title, $author, $body }';
  }
}