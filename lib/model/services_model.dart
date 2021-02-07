import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skimscope/model/facilities_model.dart';

class ServicesModel {
  final String id;
  final String equipmentId;
  final String equipmentName;
  final String title;
  final Timestamp startDate;
  final Timestamp endDate;
  final FacilitesModel facility;
  final String notes;
  final String createdBy;
  final Timestamp whenCreated;
  final Timestamp whenModified;

  ServicesModel({
    this.id,
    this.equipmentId,
    this.equipmentName,
    this.title,
    this.startDate,
    this.endDate,
    this.facility,
    this.notes,
    this.createdBy,
    this.whenCreated,
    this.whenModified,
  });

  factory ServicesModel.fromFirestore(DocumentSnapshot doc) {
    var id = doc.id;
    var data = doc.data();

    return ServicesModel(
      id: id,
      equipmentId: data['equipmentId'] ?? '',
      equipmentName: data['equipmentName'] ?? '',
      title: data['title'],
      startDate: data['startDate'],
      endDate: data['endDate'] ?? null,
      facility: FacilitesModel.fromJSON(data['facility']),
      createdBy: data['createdBy'],
      notes: data['notes'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
    );
  }

  static Map<String, dynamic> servicesToJSON(ServicesModel service) {
    return {
      'equipmentId': service.equipmentId,
      'title': service.title,
      'startDate': service.startDate,
      'endDate': service.endDate,
      'facility': FacilitesModel.facilityToJSon(service.facility),
      'createdBy': service.createdBy,
      'notes': service.notes,
      'whenCreated': service.whenCreated,
    };
  }
}
