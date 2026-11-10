class SleepModel {

  final double? value;

  final String unit;

  final String status;

  const SleepModel({

    this.value,

    required this.unit,

    required this.status,

  });

  factory SleepModel.fromJson(Map<String,dynamic> json){

    return SleepModel(

      value: json["value"] != null
          ? double.tryParse(json["value"].toString())
          : null,

      unit: json["unit"],

      status: json["status"],

    );

  }

}
