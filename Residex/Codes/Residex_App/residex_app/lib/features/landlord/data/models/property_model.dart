import 'dart:convert';
import '../../../shared/domain/entities/groups/app_group.dart';

  /// Data model that extends AppGroup entity
  class AppGroupModel extends AppGroup {
    const AppGroupModel({
      required super.id,
      required super.name,
      required super.address,           // FIXED: Changed from memberIds
      required super.tenantIds,         // FIXED: Changed from memberIds
      required super.landlordId,        // FIXED: Added
      required super.emoji,
      required super.colorValue,
      super.leaseStartDate,             // FIXED: Added
      super.leaseEndDate,               // FIXED: Added
      super.createdBy,
    });

    /// Create from domain entity
    factory AppGroupModel.fromEntity(AppGroup group) {
      return AppGroupModel(
        id: group.id,
        name: group.name,
        address: group.address,         // FIXED
        tenantIds: group.tenantIds,     // FIXED
        landlordId: group.landlordId,   // FIXED
        emoji: group.emoji,
        colorValue: group.colorValue,
        leaseStartDate: group.leaseStartDate,  // FIXED
        leaseEndDate: group.leaseEndDate,      // FIXED
        createdBy: group.createdBy,
      );
    }

    /// Convert to domain entity
    AppGroup toEntity() {
      return AppGroup(
        id: id,
        name: name,
        address: address,               // FIXED
        tenantIds: tenantIds,           // FIXED
        landlordId: landlordId,         // FIXED
        emoji: emoji,
        colorValue: colorValue,
        leaseStartDate: leaseStartDate, // FIXED
        leaseEndDate: leaseEndDate,     // FIXED
        createdBy: createdBy,
      );
    }

    /// From JSON
    factory AppGroupModel.fromJson(Map<String, dynamic> json) {
      return AppGroupModel(
        id: json['id'] as String,
        name: json['name'] as String,
        address: json['address'] as String?,                    // FIXED
        tenantIds: List<String>.from(json['tenantIds'] as List), // FIXED
        landlordId: json['landlordId'] as String?,              // FIXED
        emoji: json['emoji'] as String,
        colorValue: json['colorValue'] as int,
        leaseStartDate: json['leaseStartDate'] != null
            ? DateTime.parse(json['leaseStartDate'] as String)
            : null,                                             // FIXED
        leaseEndDate: json['leaseEndDate'] != null
            ? DateTime.parse(json['leaseEndDate'] as String)
            : null,                                             // FIXED
        createdBy: json['createdBy'] as String?,
      );
    }

    /// To JSON
    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': name,
        'address': address,                                     // FIXED
        'tenantIds': tenantIds,                                 // FIXED
        'landlordId': landlordId,                               // FIXED
        'emoji': emoji,
        'colorValue': colorValue,
        'leaseStartDate': leaseStartDate?.toIso8601String(),    // FIXED
        'leaseEndDate': leaseEndDate?.toIso8601String(),        // FIXED
        'createdBy': createdBy,
      };
    }

    /// From database row
    factory AppGroupModel.fromDb(Map<String, dynamic> row) {
      return AppGroupModel(
        id: row['id'] as String,
        name: row['name'] as String,
        address: row['address'] as String?,                                    // FIXED
        tenantIds: List<String>.from(jsonDecode(row['tenantIds'] as String)), // FIXED
        landlordId: row['landlordId'] as String?,                             // FIXED
        emoji: row['emoji'] as String,
        colorValue: row['colorValue'] as int,
        leaseStartDate: row['leaseStartDate'] != null
            ? DateTime.parse(row['leaseStartDate'] as String)
            : null,                                                            // FIXED
        leaseEndDate: row['leaseEndDate'] != null
            ? DateTime.parse(row['leaseEndDate'] as String)
            : null,                                                            // FIXED
        createdBy: row['createdBy'] as String?,
      );
    }

    /// To database format
    Map<String, dynamic> toDb() {
      return {
        'id': id,
        'name': name,
        'address': address,                                     // FIXED
        'tenantIds': jsonEncode(tenantIds),                     // FIXED
        'landlordId': landlordId,                               // FIXED
        'emoji': emoji,
        'colorValue': colorValue,
        'leaseStartDate': leaseStartDate?.toIso8601String(),    // FIXED
        'leaseEndDate': leaseEndDate?.toIso8601String(),        // FIXED
        'createdBy': createdBy,
      };
    }
  }