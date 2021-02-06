class EquipmentModel {
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
  });

  String id;
  dynamic facilityId;
  dynamic siteId;
  String name;
  String srNo;
  String installationDate;
  String createdBy;
  dynamic whenCreated;
  dynamic whenModified;
  bool isActive;
  bool isExpanded;
}
