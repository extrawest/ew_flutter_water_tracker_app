class UserModel {
  String? id;
  String email;
  String name;
  String? photoId;
  int dailyWaterLimit;

  UserModel(
      {this.id,
      required this.email,
       required this.name,
      this.photoId,
      required this.dailyWaterLimit});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'photoId': photoId,
      'name': name,
      'daily_water_limit': dailyWaterLimit,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        name: json['name'] ?? '',
        dailyWaterLimit: json['daily_water_limit'],);
  }
}
