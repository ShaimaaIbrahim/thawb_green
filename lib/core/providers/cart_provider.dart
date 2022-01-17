import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ojos_app/features/cart/domin/entities/cart_attribute_entity.dart';
import 'package:ojos_app/features/product/domin/entities/cart_entity.dart';
import 'dart:math' as math;

//To control the choice of answers
class CartProvider with ChangeNotifier {
  CartProvider() {
    initList();
  }

  List<CartEntity> listOfCart = [];

  get getListOfItems => listOfCart;

  addItemToCart(CartEntity cartEntity) {
    print('item new is ${cartEntity.id}');
    print('isExist(cartEntity) ${cartEntity.id} ${isExist(cartEntity)}');
    if (isExist(cartEntity)) {
      /* if (cartEntity.argsForGlasses != null) {
        print('updateee');
        updateArgs(cartEntity);
      }*/
      increaseItemCount(cartEntity.id);
    } else {
      listOfCart.add(cartEntity);
    }

    notifyListeners();
  }

  bool isExist(CartEntity cartEntity) {
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id == cartEntity.id) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  updateArgs(CartEntity cartEntity) {
    print('updateee');
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id == cartEntity.id) {
          print('updateee');
          // item.argsForGlasses = cartEntity.argsForGlasses;
        }
      }
    }
  }

  initList() async {
    //   listAnswer = new Map();
    listOfCart = [];
  }

  clearList() {
    // listAnswer = new Map();
    listOfCart.clear();
    notifyListeners();
  }

  setItemCount() {

  }

  int getTotalPricesAfterDiscount() {
    double total = 0;
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if ((item.productEntity.discount_price == null  || item.productEntity.discount_price==0)) {
          int discount = item.productEntity.price!;
          total += (discount) * (item.count);
        } else {
          total += (item.productEntity.discount_price) * (item.count);
        }
      }
    }
    return total.toInt();
  }

  int getTotalPricesint() {
    double total = 0;
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.productEntity.price == null) {
         int price = 0;
          total += (price).abs() * (item.count);
        } else {
          total += (item.productEntity.price!) * (item.count);
        }
      }
    }
    return total.toInt();
  }

  increaseItemCount(int? id) {
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id != null && item.id == id) {
          item.count = ((item.count) + 1);
        }
      }
    }
    notifyListeners();
  }

  decreaseItemCount(int? id) {
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.id != null && item.id == id) {
          if (item.count == 1) {
            listOfCart.removeWhere((element) => element.id == id);
            notifyListeners();
          } else
            item.count = (item.count) - 1;
        }
      }
    }
    notifyListeners();
  }

  List<dynamic>? getItems() {
    return listOfCart;
  }

  int getItemsCount() {
    int count = 0;
    if (listOfCart.isNotEmpty) {
      for (CartEntity item in listOfCart) {
        if (item.count != null && item.count != 0) {
          count += (item.count);
        }
      }
    }
    return count;
  }

  List<CartAttributeEntity> listAttributeOfCart = [];

  get getListAttributeOfItems => listAttributeOfCart;

  addItemAttributeToCart(CartAttributeEntity cartEntity) {
    print('item new is ${cartEntity.id}');
    print('isExist(cartEntity) ${cartEntity.id} ${isAttributeExist(cartEntity)}');
    if (isAttributeExist(cartEntity)) {
      /* if (cartEntity.argsForGlasses != null) {
        print('updateee');
        updateArgs(cartEntity);
      }*/
      increaseAttributeItemCount(cartEntity.id);
    } else {
      listAttributeOfCart.add(cartEntity);
    }

    notifyListeners();
  }

  bool isAttributeExist(CartAttributeEntity cartEntity) {
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if (item.id == cartEntity.id) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  updateAttributeArgs(CartAttributeEntity cartEntity) {
    print('updateee');
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if (item.id == cartEntity.id) {
          print('updateee');
          // item.argsForGlasses = cartEntity.argsForGlasses;
        }
      }
    }
  }

  initAttributeList() async {
    //   listAnswer = new Map();
    listAttributeOfCart = [];
  }

  clearAttributeList() {
    // listAnswer = new Map();
    listAttributeOfCart.clear();
    notifyListeners();
  }

  setItemAttributeCount() {}

  int getTotalPricesAttributeAfterDiscount() {
    double total = 0;
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if ((item.discountPrice == null || item.discountPrice==0)) {
         int discount=  item.price!;
          total += (discount) * (item.count!);
        } else {
          total += (item.discountPrice!) * (item.count!);
        }
      }
    }
    return total.toInt();
  }

  int getTotalAttriburtePricesint() {
    double total = 0;
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if (item.price == null && item.discountPrice!=null && item.discountPrice!=0) {
          item.price = item.discountPrice;
          total += (item.price!).abs() * (item.count!);
        } else {
          total += (item.price!) * (item.count!);
        }
      }
    }
    return total.toInt();
  }

  increaseAttributeItemCount(int? id) {
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if (item.id != null && item.id == id) {
          item.count = ((item.count!) + 1);
        }
      }
    }
    notifyListeners();
  }

  decreaseAttributeItemCount(int? id) {
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if (item.id != null && item.id == id) {
          if (item.count == 1) {
            listAttributeOfCart.removeWhere((element) => element.id == id);
            notifyListeners();
          } else
            item.count = (item.count!) - 1;
        }
      }
    }
    notifyListeners();
  }

  List<dynamic>? getAttributeItems() {
    return listAttributeOfCart;
  }

  int getItemsAttributesCount() {
    int count = 0;
    if (listAttributeOfCart.isNotEmpty) {
      for (CartAttributeEntity item in listAttributeOfCart) {
        if (item.count != null && item.count != 0) {
          count += (item.count!);
        }
      }
    }
    return count;
  }
}
