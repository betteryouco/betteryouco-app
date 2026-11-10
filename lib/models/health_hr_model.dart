class HeartRateModel {

  final double? value;

  final String unit;

  final String status;

  const HeartRateModel({

    this.value,

    required this.unit,

    required this.status,

  });

  factory HeartRateModel.fromJson(Map<String,dynamic> json){

    return HeartRateModel(

      value: json["value"] != null
          ? double.parse(json["value"].toString())
          : 0.0,

      unit: json["unit"],

      status: json["status"],

    );

  }

}