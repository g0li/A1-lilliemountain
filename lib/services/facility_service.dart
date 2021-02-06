import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:flutter/foundation.dart';

class FacilityService {
  var db = FirebaseFirestore.instance;

  // create facility
  Future<bool> createFacility({
    @required SitesModel site,
    @required String name,
    @required String createdBy,
  }) async {
    try {
      FacilitesModel fac = FacilitesModel(
        createdBy: createdBy,
        site: site,
        isActive: true,
        whenCreated: Timestamp.now(),
        name: name,
      );

      await db.collection('facilities').add(FacilitesModel.facilityToJSon(fac));
      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // edit facility
  Future<bool> editFacility({
    @required String facilityId,
    @required String name,
  }) async {
    try {
      var docRef = db.doc('facilities/$facilityId');
      await docRef.update({
        'name': name,
        'whenModified': Timestamp.now(),
      });

      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // get all facilities
  Stream<List<FacilitesModel>> getAllFacilities() {
    try {
      var facilitiesRef = db.collection('facilities').snapshots();
      var list = facilitiesRef.map((d) =>
          d.docs.map((doc) => FacilitesModel.fromFirestore(doc)).toList());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
