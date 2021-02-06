import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skimscope/model/sites_model.dart';

class FacilitesModel {
  final String id;
  final SitesModel site;
  final String name;
  final String createdBy;
  final Timestamp whenCreated;
  final dynamic whenModified;
  final bool isActive;

  FacilitesModel({
    this.id,
    this.site,
    this.name,
    this.createdBy,
    this.whenCreated,
    this.whenModified,
    this.isActive,
  });

  factory FacilitesModel.fromFirestore(DocumentSnapshot doc) {
    var id = doc.id;
    var data = doc.data();

    return FacilitesModel(
      id: id,
      name: data['name'],
      isActive: data['isActive'],
      site: SitesModel.fromJSON(data['site']),
      createdBy: data['createdBy'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
    );
  }

  // from JSON
  factory FacilitesModel.fromJSON(Map<String, dynamic> data) {
    return FacilitesModel(
      id: data['id'],
      name: data['name'],
      isActive: data['isActive'],
      site: SitesModel.fromJSON(data['site']),
      createdBy: data['createdBy'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
    );
  }

  static Map<String, dynamic> facilityToJSon(FacilitesModel fac) {
    return {
      'name': fac.name,
      'site': SitesModel.siteModelToJSON(fac.site),
      'isActive': fac.isActive,
      'whenCreated': fac.whenCreated,
      'createdBy': fac.createdBy,
    };
  }
}
