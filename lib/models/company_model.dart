class CompanyModel {
  final int id;
  final String name;
  final String logo;

  CompanyModel({required this.id, required this.name, required this.logo});

  factory CompanyModel.fromMap(Map<String, dynamic> json) {
    return CompanyModel(id: json['id'], name: json['name'], logo: json['logo']);
  }
}
