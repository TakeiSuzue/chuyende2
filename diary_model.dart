class Diary {
  final int? id;
  final String date;
  final String emotion;
  final int score; // Trường mới
  final String content;
  final String? imagePath;
  final String? location;

  Diary({this.id, required this.date, required this.emotion, required this.score, required this.content, this.imagePath, this.location});

  Map<String, dynamic> toMap() {
    return {
      'id': id, 'date': date, 'emotion': emotion, 'score': score,
      'content': content, 'imagePath': imagePath, 'location': location,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      date: map['date'],
      emotion: map['emotion'],
      score: map['score'] ?? 5, // Tránh lỗi nếu dữ liệu cũ không có score
      content: map['content'],
      imagePath: map['imagePath'],
      location: map['location'],
    );
  }
}

// Bảng quy đổi cảm xúc sang điểm số
final Map<String, int> emotionScores = {
  "💖 Yêu đời": 10,
  "☀️ Hào hứng": 9,
  "😊 Vui vẻ": 8,
  "🌿 Bình yên": 7,
  "😐 Bình thường": 6,
  "😴 Mệt mỏi": 5,
  "😢 Buồn": 4,
  "😡 Giận dữ": 3,
  "😫 Tuyệt vọng": 1,
};