import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/services_model.dart';

class MaintenanceService {
  var db = FirebaseFirestore.instance;

  // create & edit service
  Future<bool> createService({
    @required String equipmentId,
    @required String equipmentName,
    @required String title,
    @required Timestamp startDate,
    @required Timestamp endDate,
    @required dynamic facility,
    @required String createdBy,
    @required String notes,
    String mode = 'create',
    String serviceId,
  }) async {
    try {
      print('asdasd');
      ServicesModel service = ServicesModel(
        equipmentId: equipmentId,
        equipmentName: equipmentName,
        title: title,
        startDate: startDate,
        endDate: endDate,
        facility: facility,
        createdBy: createdBy,
        notes: notes,
        whenCreated: Timestamp.now(),
      );

      if (mode != 'create' && serviceId != null) {
        // edit mode
        var serviceRef = db.doc('equipments/$equipmentId/services/$serviceId');
        await serviceRef.update({
          'equipmentId': equipmentId,
          'title': title,
          'startDate': startDate,
          'endDate': endDate,
          'facility': FacilitesModel.facilityToJSon(facility),
          'notes': notes,
          'whenModified': Timestamp.now(),
        });
      } else {
        // create mode
        await db
            .collection('equipments/$equipmentId/services')
            .add(ServicesModel.servicesToJSON(service));
      }

      return true;
    } catch (err) {
      print(err.toString());
      return false;
    }
  }

  // get all equipment services
  Stream<List<ServicesModel>> getEquipmentServices({
    @required String equipmentId,
  }) {
    try {
      var servicesRef = db
          .collection('equipments/$equipmentId/services')
          .orderBy('whenCreated', descending: true)
          .snapshots();
      var list = servicesRef.map((d) =>
          d.docs.map((doc) => ServicesModel.fromFirestore(doc)).toList());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
