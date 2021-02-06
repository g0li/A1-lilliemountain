import 'package:cloud_firestore/cloud_firestore.dart';

class SitesModel {
  final String id;
  final String name;
  final String createdBy;
  final bool isActive;
  final Timestamp whenCreated;
  final dynamic whenModified;

  SitesModel({
    this.id,
    this.name,
    this.createdBy,
    this.whenCreated,
    this.whenModified,
    this.isActive,
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
      isActive: data['isActive'],
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
        isActive: data['isActive']);
  }

  // from JSON
  static Map<String, dynamic> siteModelToJSON(SitesModel site) {
    return {
      'name': site.name,
      'createdBy': site.createdBy,
      'whenCreated': site.whenCreated,
      'isActive': site.isActive,
    };
  }
}
