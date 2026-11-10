class BMIModel {

  final double? value;

  final String unit;

  final String status;

  const BMIModel({

    this.value,

    required this.unit,

    required this.status,

  });

  factory BMIModel.fromJson(Map<String,dynamic> json){

    return BMIModel(

      value: double.tryParse(json["value"].toString()),
      unit: json["unit"],

      status: json["status"],

    );

  }

}