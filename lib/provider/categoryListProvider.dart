//
// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
//
// import 'model/categoryModel.dart';
//
// class VehicleListProvider extends ChangeNotifier {
//   List<Data> _allCategory = [];
//
//   List<Data> get allCategory => [..._allCategory];
//
//   Future fetchAllCategory() async {
//
//     _allCategory = [];
//     List<Data> fetchAllCategoryList = [];
//
//     // final result = await fetchCategory();
//
//     // ResultCategory itemListModel = ResultCategory.fromJson(result);
//
//     result['results'].forEach(
//           (element) {
//             fetchAllCategoryList.add(
//               Data.fromJson(element),
//
//         );
//       },
//     );
//     // log("fteching");
//
//     _allCategory = fetchAllCategoryList;
//     notifyListeners();
//   }
// }
