class UserDetailsModel {
  String? address;
  String? email;
  bool? isDealder;
  int? mobileNumber;
  String? name;
  int? orgId;
  int? pincode;
  int? refId;
  String? key;

  UserDetailsModel(
      {this.address,
        this.email,
        this.isDealder,
        this.mobileNumber,
        this.name,
        this.orgId,
        this.pincode,
        this.key,
        this.refId});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    email = json['email'];
    isDealder = json['isDealder'];
    mobileNumber = json['mobile_number'];
    name = json['name'];
    orgId = json['org_id'];
    pincode = json['pincode'];
    refId = json['ref_id'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['email'] = this.email;
    data['isDealder'] = this.isDealder;
    data['mobile_number'] = this.mobileNumber;
    data['name'] = this.name;
    data['org_id'] = this.orgId;
    data['pincode'] = this.pincode;
    data['ref_id'] = this.refId;
    data['key'] = this.key;
    return data;
  }
}
