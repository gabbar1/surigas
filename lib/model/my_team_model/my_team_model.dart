class MyTeamModel {
  int? mobileNumber;
  String? name;
  String? address;
  String? key;
  bool ? isEnabled;

  MyTeamModel({this.mobileNumber,this.name,this.address});

  MyTeamModel.fromJson(Map<String, dynamic>json) {
    mobileNumber = json['mobile_number'];
    address = json['address'];
    name = json['name'];
    isEnabled = json['isEnabled']==null?false:json['isEnabled'];
    key = json['key'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile_number'] = this.mobileNumber;
    data['address'] = this.address;
    data['name'] = this.name;
    data['key'] = this.key;
    data['isEnabled'] = this.isEnabled;
    return data;
  }
}