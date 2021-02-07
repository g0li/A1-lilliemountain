import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EquipmentService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;

  // create equipment
  Future<bool> createEquipment({
    @required FacilitesModel facilityId,
    @required SitesModel site,
    @required String name,
    @required String srNo,
    @required DateTime installationDate,
    @required String createdBy,
    @required File image,
  }) async {
    try {
      EquipmentModel equipmentModel = EquipmentModel(
        facilityId: facilityId,
        siteId: site,
        name: name,
        srNo: srNo,
        installationDate: installationDate,
        createdBy: createdBy,
        whenCreated: Timestamp.now(),
        isActive: true,
      );

      var createdEquipment = await db
          .collection('equipments')
          .add(EquipmentModel.equipmentModelToJSON(equipmentModel));

      String downloadUrl = '';
      if (image != null) {
        // upload image
        final storageRef = storage
            .ref()
            .child('Equipments')
            .child(createdEquipment.id + '.jpg');
        await storageRef.putFile(image);
        downloadUrl = await storageRef.getDownloadURL();
      }

      await db.doc('equipments/${createdEquipment.id}').update({
        'imageUrl': downloadUrl,
      });

      return true;
    } catch (err) {
      print('Error creating equipment: ${err.toString()}');
      return false;
    }
  }

  // delete equipment
  Future<bool> deleteEquipment({@required String equipmentId}) async {
    try {
      var docRef = db.doc('equipments/$equipmentId');
      await docRef.delete();
      return true;
    } catch (err) {
      print('Error deleting equipment: ${err.toString()}');
      return false;
    }
  }

  // get all equipments
  Stream<List<EquipmentModel>> getAllEquipments() {
    try {
      var equipmentRef = db.collection('equipments').snapshots();
      var list = equipmentRef.map((d) =>
          d.docs.map((doc) => EquipmentModel.fromFirestore(doc)).toList());
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // get all equipments
  Stream<int> getEquipmentCount(FacilitesModel facilityModel) {
    try {
      var equipmentRef = db
          .collection('equipments')
          .where('facilityId',
              isEqualTo: FacilitesModel.facilityToJSon(facilityModel))
          .snapshots();
      return equipmentRef.map((event) => event.size);

      // var list = equipmentRef.map((d) =>
      //     d.docs.map((doc) => EquipmentModel.fromFirestore(doc)).toList());
      // return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }
}
