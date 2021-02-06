import 'package:cloud_firestore/cloud_firestore.dart';

class SitesModel {
  final String id;
  final String name;
  final String createdBy;
  final Timestamp whenCreated;
  final dynamic whenModified;

  SitesModel({
    this.id,
    this.name,
    this.createdBy,
    this.whenCreated,
    this.whenModified,
  });

  factory SitesModel.fromFirestore(DocumentSnapshot doc) {
    var id = doc.id;
    var data = doc.data();

    return SitesModel(
      id: id,
      name: data['name'],
      createdBy: data['createdBy'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
    );
  }

  // from JSON
  factory SitesModel.fromJSON(Map<String, dynamic> data) {
    return SitesModel(
      id: data['id'],
      name: data['name'],
      createdBy: data['createdBy'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
    );
  }
}
