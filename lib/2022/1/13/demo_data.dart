class DrinkData {
  final String title;
  final int requiredPoints;
  final String iconImage;

  const DrinkData({
    required this.title,
    required this.requiredPoints,
    required this.iconImage,
  });
}

class DemoData {
  // how many points this user has earned, in a real app this would be loaded from an online service
  int earnedPoints = 450;

  // List of available drinks
  List<DrinkData> drinks = const [
    DrinkData(title: "Coffee", requiredPoints: 100, iconImage: "Coffee.png"),
    DrinkData(title: "Tea", requiredPoints: 150, iconImage: "Tea.png"),
    DrinkData(title: "Latte", requiredPoints: 250, iconImage: "Latte.png"),
    DrinkData(
        title: "Frappuccino",
        requiredPoints: 350,
        iconImage: "Frappuccino.png"),
    DrinkData(
        title: "Pressed Juice", requiredPoints: 450, iconImage: "Juice.png"),
  ];
}
