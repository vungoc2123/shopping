class ProductModel {
  int? id;
  String? name;
  int? price;
  String? img;
  String? type;
  String? category;
  String? description;
  String? color;
  String? size;

  ProductModel({this.id, this.name, this.price, this.img,this.type, this.category, this.description, this.color,this.size});

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    img : json['img'],
    type: json['type'],
    category : json['category'],
    description: json['description'],
    color: json['color'],
    size: json['size'],

  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price" : price,
    "img" : img,
    "type": type,
    "category": category,
    "description" : description,
    "color": color,
    "size" : size,
  };

}