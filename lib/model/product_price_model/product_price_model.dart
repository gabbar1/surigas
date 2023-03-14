class ProductPriceModel {
  String? productName;
  num? productPrice;
  bool? isReplaceable;
  String? key;

  ProductPriceModel({this.productName, this.productPrice, this.isReplaceable,this.key});

  ProductPriceModel.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productPrice = num.parse(json['product_price'].toString());
    isReplaceable = json['isReplaceable'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['product_price'] = this.productPrice;
    data['isReplaceable'] = this.isReplaceable;
    data['key'] = this.key;
    return data;
  }
}



