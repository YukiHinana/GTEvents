//Event variables
class Event {
  int eventId;
  String title;
  String location;
  String description;
  // int eventDate;
  int capacity;
  int fee;
  bool isSaved;

  Event(this.eventId, this.title, this.location, this.description,
      this.capacity, this.fee, this.isSaved);

//jason for the variables
  factory Event.fromJson(dynamic json) {
    return Event(json['id'] as int, json['title'] as String,
        json['location'] as String, json['description'] as String,
        json['capacity'] as int,
        json['fee'] as int, false);
  }
//change the variables to string
  @override
  String toString() {
    return'{$eventId, $title, $location, $description, $capacity, $fee}';
  }
}

class Tag {
  int tagId;
  String name;
  Tag(this.tagId, this.name);
  factory Tag.fromJson(dynamic json) {
    return Tag(json['id'] as int, json['name'] as String);
  }
//change the variables to string
  @override
  String toString() {
    return'{$tagId, $name}';
  }
}