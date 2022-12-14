class SalesModel {
  int? mobileNumber;
  String? name;
  String? address;

  SalesModel({this.mobileNumber, this.name, this.address});

  SalesModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobile_number'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_number'] = this.mobileNumber;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}
