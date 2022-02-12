import 'package:flutter/material.dart';

extension EnumCategoryExtension on EnumCategory {
  String get value {
    switch (this) {
      case EnumCategory.all:
        return "all";
      case EnumCategory.breakfast:
        return "সকালের নাস্তা";
      case EnumCategory.lunch:
        return "দুপুরের খাবার";
      case EnumCategory.dinner:
        return "রাতের খাবার";
      case EnumCategory.snack:
        return "জলখাবার";
      default:
        return "";
    }
  }
}

enum EnumCategory {
  all,
  breakfast,
  lunch,
  dinner,
  snack,
}

class FilterProvider extends ChangeNotifier {
  EnumCategory selectedCategory = EnumCategory.all;
  void changeCategory(EnumCategory category) {
    selectedCategory = category;
    notifyListeners();
  }
}
