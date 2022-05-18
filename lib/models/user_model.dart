class UserModel {
  String? id;
  String email;
  String? photoId;
  int dailyWaterLimit;
  List<DayModel>? days;

  UserModel(
      {this.id,
      required this.email,
      this.photoId,
      this.days,
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

class DayModel {
  String? id;
  List<WaterModel>? water;
  String? date;

  DayModel({required this.date, required this.water, this.id});

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'water': water != null
          ? List<dynamic>.from(water!.map((e) => e.toJson()))
          : null,
    };
  }

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
        date: json['date'],
        water: List<WaterModel>.from(
          json['water'].map((e) => WaterModel.fromJson(e)),
        ));
  }
}

class WaterModel {
  int amount;
  String type;
  String time;

  WaterModel({required this.amount, required this.time, required this.type});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
      'time': time,
    };
  }

  factory WaterModel.fromJson(Map<String, dynamic> json) {
    return WaterModel(
        amount: json['amount'], time: json['time'], type: json['type']);
  }
}
