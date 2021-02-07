import 'package:flutter/material.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:skimscope/services/site_service.dart';

class SiteProvider extends ChangeNotifier {
  List<SitesModel> allSites = [];
  SiteProvider() {
    SiteService().getAllSites().listen((event) {
      allSites = event;
      notifyListeners();
    });
  }
}
