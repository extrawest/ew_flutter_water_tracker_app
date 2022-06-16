class WaterModel {
  int amount;
  String type;
  String time;

  WaterModel(
      {required this.amount, required this.time, required this.type});

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

  @override
  String toString() {
    return 'amount: $amount, type: $type, time: $time';
  }
}
