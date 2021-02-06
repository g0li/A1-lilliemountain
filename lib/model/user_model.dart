import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String role;
  final String name;
  final String email;
  final dynamic joiningDate;
  final bool isActive;
  final Timestamp whenCreated;
  final dynamic whenModified;

  UserModel({
    this.id,
    this.role,
    this.name,
    this.email,
    this.joiningDate,
    this.isActive,
    this.whenCreated,
    this.whenModified,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    String docId = doc.id;
    Map<String, dynamic> data = doc.data();
    return UserModel(
      id: docId,
      role: data['role'],
      name: data['name'],
      email: data['email'],
      joiningDate: data['joiningDate'],
      isActive: data['isActive'],
      whenCreated: data['whenCreated'],
      whenModified: data['whenModified'] ?? null,
    );
  }
}
