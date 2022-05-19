class UserModel {
  String? id;
  String email;
  String? photoId;
  int dailyWaterLimit;

  UserModel(
      {this.id,
      required this.email,
      this.photoId,
      required this.dailyWaterLimit});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'photoId': photoId,
      'daily_water_limit': dailyWaterLimit,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'],
        dailyWaterLimit: json['daily_water_limit'],);
  }
}
