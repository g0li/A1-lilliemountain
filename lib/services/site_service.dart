import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/model/sites_model.dart';

class SiteService {
  var db = FirebaseFirestore.instance;

  // create site
  Future<bool> createSite({
    @required String name,
    @required String createdBy,
  }) async {
    try {
      SitesModel site = SitesModel(
        name: name,
        createdBy: createdBy,
        isActive: true,
        whenCreated: Timestamp.now(),
      );

      await db.collection('sites').add(SitesModel.siteModelToJSON(site));
      return true;
    } catch (err) {
      print('Error in creating site: ${err.toString()}');
      return false;
    }
  }

  // edit site
  Future<bool> editSite({
    @required String siteId,
    @required String name,
  }) async {
    try {
      var siteRef = db.doc('sites/$siteId');
      await siteRef.update({
        'name': name,
        'whenModified': Timestamp.now(),
      });

      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // get all Sites
  Stream<List<SitesModel>> getAllSites() {
    try {
      var siteRef = db
          .collection('sites')
          .orderBy('whenCreated', descending: true)
          .snapshots();
      var list = siteRef.map(
          (d) => d.docs.map((doc) => SitesModel.fromFirestore(doc)).toList());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
