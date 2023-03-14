class PurchaseModel {
  int? mobileNumber;
  String? name;
  String? address;
  String? key;

  PurchaseModel({this.mobileNumber,this.name,this.address});

  PurchaseModel.fromJson(Map<String, dynamic>json) {
    mobileNumber = json['mobile_number'];
    address = json['address'];
    name = json['name'];
    key = json['key'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_number'] = this.mobileNumber;
    data['address'] = this.address;
    data['name'] = this.name;
    data['key'] = this.key;
    return data;
  }
}