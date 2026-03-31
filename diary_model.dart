class Diary {
  final int? id;
  final String date;
  final String emotion;
  final String content;
  final String? imagePath;
  final String? location;

  Diary({this.id, required this.date, required this.emotion, required this.content, this.imagePath, this.location});

  Map<String, dynamic> toMap() {
    return {
      'id': id, 'date': date, 'emotion': emotion,
      'content': content, 'imagePath': imagePath, 'location': location,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'], date: map['date'], emotion: map['emotion'],
      content: map['content'], imagePath: map['imagePath'], location: map['location'],
    );
  }
}