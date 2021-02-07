import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skimscope/model/equipment_model.dart';
import 'package:skimscope/model/facilities_model.dart';
import 'package:skimscope/model/sites_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EquipmentService {
  var db = FirebaseFirestore.instance;
  var storage = FirebaseStorage.instance;
  var firebaseAuth = FirebaseAuth.instance;

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
  Stream<List<EquipmentModel>> getAllEquipments(
      {@required String facilityName, @required String createdBy}) {
    try {
      var equipmentRef = db
          .collection('equipments')
          .where(
            'createdBy',
            isEqualTo: firebaseAuth.currentUser.uid,
          )
          .snapshots();
      var list = equipmentRef.map((d) {
        var list = d.docs;
        if (list != null && list.length > 0) {
          list = list
              .where((it) => (it['facilityId']['name'] == facilityName &&
                  it['facilityId']['createdBy'] == createdBy))
              .toList();
          return list.map((doc) => EquipmentModel.fromFirestore(doc)).toList();
        } else {
          return null;
        }
      });
      return list;
    } catch (err) {
      print(err.toString());
      return null;
    }
  }

  // get single equipments
  Stream<EquipmentModel> getEquipment(String id) {
    try {
      var equipmentRef = db.doc('equipments/$id').snapshots();
      return equipmentRef.map((event) => EquipmentModel.fromFirestore(event));
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

  //active deactive equipment
  Future<void> toggleEquipment(bool toggle, equipmentId) {
    var docRef = db.doc('equipments/$equipmentId');
    return docRef.update({'isActive': toggle});
  }

  //watch equipment status
  Stream<bool> wathchIsActive(equipmentId) {
    var docRef = db.doc('equipments/$equipmentId');
    return docRef.snapshots().map((event) => event.data()['isActive']);
  }
}
