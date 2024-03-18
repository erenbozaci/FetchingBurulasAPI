class RoutePrice {
  String cardType;
  double price;

  RoutePrice({required this.cardType, required this.price});
  
  factory RoutePrice.fromJSON(Map<String, dynamic> json) {
    return RoutePrice(cardType: json["cardType"], price: double.parse(json["price"].toString()));
  }

}