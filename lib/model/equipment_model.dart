import 'package:cloud_firestore/cloud_firestore.dart';
import './facilities_model.dart';
import './sites_model.dart';

class EquipmentModel {
  final String id;
  final dynamic facilityId;
  final dynamic siteId;
  final String name;
  final String srNo;
  final String installationDate;
  final String createdBy;
  final dynamic whenCreated;
  final dynamic whenModified;
  bool isActive;
  bool isExpanded;
  final String imageUrl;

  EquipmentModel({
    this.id,
    this.facilityId,
    this.siteId,
    this.name,
    this.srNo,
    this.installationDate,
    this.createdBy,
    this.whenCreated,
    this.whenModified,
    this.isActive,
    this.isExpanded = false,
    this.imageUrl,
  });

  factory EquipmentModel.fromFirestore(DocumentSnapshot doc) {
    var id = doc.id;
    var data = doc.data();

    return EquipmentModel(
      id: id,
      facilityId: FacilitesModel.fromJSON(data['facilityId']),
      siteId: SitesModel.fromJSON(data['siteId']),
      name: data['name'],
      srNo: data['srNo'],
      installationDate: data['installationDate'],
      createdBy: data['createdBy'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
      isActive: data['isActive'],
      imageUrl: data['imageUrl'] ?? null,
    );
  }
}
