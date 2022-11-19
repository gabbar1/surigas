class PurchaseModel {
  int? mobileNumber;
  String? name;

  PurchaseModel({this.mobileNumber,this.name});

  PurchaseModel.fromJson(Map<String, dynamic>json) {
    mobileNumber = json['mobile_number'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_number'] = this.mobileNumber;
    data['name'] = this.name;
    return data;
  }
}