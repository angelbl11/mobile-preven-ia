class Variables {
  final double? imc;
  final String? sexo;
  final String? edad;

  Variables({
    this.imc,
    this.sexo,
    this.edad,
  });

  factory Variables.fromJson(Map<String, dynamic> json) {
    return Variables(
      imc: json['IMC'] != null ? double.tryParse(json['IMC'].toString()) : null,
      sexo: json['sexo'] as String?,
      edad: json['edad'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IMC': imc,
      'sexo': sexo,
      'edad': edad,
    };
  }
}
