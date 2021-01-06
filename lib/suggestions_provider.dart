import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' as io;

// TODO :fetch asset icons and pass to widget

class SuggestionsProvider extends ChangeNotifier {
  List suggestion = List();
  List allProducts;
  List iconFiles;

  Future<List<dynamic>> loadJson(path) async {
    final json = rootBundle.loadString(path);
    final decoder = JsonDecoder();
    print("Loading json");
    final data = decoder.convert(await json);
    return data;
  }

  String fetchIcon(String assetName) {
    // print(iconFiles);
    String formattedAssetName = assetName.trim().toLowerCase()+ '.svg';
    String path = 'assets/svg/' +  formattedAssetName ;
    // asset = rootBundle.loadString(path).then((value) {return value;});
    // for a file
    // bool exists = io.File(path).exists().then((value) {return value;});

    if(iconFiles.contains(formattedAssetName)){
      print(path);
      return path;
    }
    else{
      return 'assets/ui/go_grocery_logo.svg';
    }
  }

  Future<List> getSuggestions(String pattern) async {
    List<Map<String, dynamic>> separatedMatches = List();
    if (allProducts == null) {
      this.allProducts = await loadJson('assets/products.json').then((value) {
        return value;
      });
      this.iconFiles = await loadJson('assets/svg/data.json').then((value) {
        return value;
      });
    }


    if (allProducts != null) {
      // print(pattern);

      List matches = List();
      matches.addAll(allProducts);
      matches.retainWhere(
          (item) => item['name'].toLowerCase().contains(pattern.toLowerCase()));

      // print(matches);
      String iconPath;
      for (var match in matches) {
        if (match['name'].contains('|')) {
          List names = match['name'].split('|');
          for (var name in names) {
            iconPath = fetchIcon(name.trim());
          }
          for (var name in names) {
            separatedMatches.add(
                {'name': name, 'brand': match['brand'], 'iconPath': iconPath});
          }
        } else {
          separatedMatches.add(match);
        }
      }
      notifyListeners();
      this.suggestion = separatedMatches;
      return separatedMatches;
    } else {
      print("Nothing matches patetrn");
      // notifyListeners();
      // return null;
    }
  }
}
