import 'package:flutter/material.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:skimscope/services/site_service.dart';

class SiteProvider extends ChangeNotifier {
  List<SitesModel> allSites = [];
  bool sitesLoader = false;
  SiteProvider() {
    sitesLoader = true;
    SiteService().getAllSites().listen((event) {
      sitesLoader = false;
      allSites = event;
      notifyListeners();
    });
  }
}
