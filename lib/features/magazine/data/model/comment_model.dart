class CommentItem {
  CommentItem({
    this.id,
    this.userId,
    this.magazineId,
    this.parentId,
    this.username,
    this.content,
    this.createdAt,
  });

  final int? id;
  final int? userId;
  final int? magazineId;
  final int? parentId;
  final String? username;
  final String? content;
  final String? createdAt;

  factory CommentItem.fromJson(Map<String, dynamic> json) => CommentItem(
        id: json["id"],
        userId: json["user_id"],
        magazineId: json["magazine_id"],
        parentId: json["parent_id"],
        username: json["username"],
        content: json["content"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "magazine_id": magazineId,
        "parent_id": parentId,
        "username": username,
        "content": content,
        "created_at": createdAt,
      };
}
