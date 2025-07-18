class Feed {
  final String id;
  final String imageUrl;
  final String caption;
  final List<String> likes;
  final List<Comment> comments;
  final String createdBy;
  final DateTime? createdAt;

  Feed({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.createdBy,
    this.createdAt,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'] ?? json['_id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      caption: json['caption'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      comments:
          (json['comments'] as List<dynamic>? ?? [])
              .map((c) => Comment.fromJson(c))
              .toList(),
      createdBy:
          json['createdBy'] is Map
              ? (json['createdBy']['email'] ?? '')
              : (json['createdBy'] ?? ''),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'caption': caption,
    'likes': likes,
    'comments': comments.map((c) => c.toJson()).toList(),
    'createdBy': createdBy,
    'createdAt': createdAt?.toIso8601String(),
  };
}

class Comment {
  final String user;
  final String text;
  final DateTime? createdAt;

  Comment({required this.user, required this.text, this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user:
          json['user'] is Map
              ? (json['user']['email'] ?? '')
              : (json['user'] ?? ''),
      text: json['text'] ?? '',
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user,
    'text': text,
    'createdAt': createdAt?.toIso8601String(),
  };
}
