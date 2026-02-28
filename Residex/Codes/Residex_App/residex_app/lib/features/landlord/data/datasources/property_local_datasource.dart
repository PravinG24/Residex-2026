import 'package:drift/drift.dart';
import '../../../../data/database/app_database.dart';
import '../models/property_model.dart';

  /// Local data source for groups using Drift
  class GroupLocalDataSource {
    final AppDatabase database;

    GroupLocalDataSource(this.database);

    /// Get all groups
    Future<List<AppGroupModel>> getAllGroups() async {
    final groups = await database.groupDao.getAllGroups();
    return groups.map((group) {
      return AppGroupModel.fromDb({
        'id': group.id,
        'name': group.name,
        'tenantIds': group.tenantIds,  // <-- FIXED
        'emoji': group.emoji,
        'colorValue': group.colorValue,
        'createdBy': group.createdBy,
        'address': group.address,
        'landlordId': group.landlordId,
        'leaseStartDate': group.leaseStartDate?.toIso8601String(),
        'leaseEndDate': group.leaseEndDate?.toIso8601String(),
      });
    }).toList();
  }

    /// Get group by ID
    Future<AppGroupModel?> getGroupById(String id) async {
      final group = await database.groupDao.getGroupById(id);
      if (group == null) return null;

      return AppGroupModel.fromDb({
        'id': group.id,
        'name': group.name,
        'tenantIds': group.tenantIds,  // <-- FIXED
        'emoji': group.emoji,
        'colorValue': group.colorValue,
        'createdBy': group.createdBy,
        'address': group.address,
        'landlordId': group.landlordId,
        'leaseStartDate': group.leaseStartDate?.toIso8601String(),
        'leaseEndDate': group.leaseEndDate?.toIso8601String(),
  });
    }

    /// Add or update group
    Future<void> upsertGroup(AppGroupModel group) async {
      final dbData = group.toDb();
      await database.groupDao.upsertGroup(
        GroupsCompanion(
          id: Value(dbData['id'] as String),
          name: Value(dbData['name'] as String),
          tenantIds: Value(dbData['tenantIds'] as String),  // <-- FIXED
          emoji: Value(dbData['emoji'] as String),
          colorValue: Value(dbData['colorValue'] as int),
          createdBy: Value(dbData['createdBy'] as String?),
          address: Value(dbData['address'] as String?),
          landlordId: Value(dbData['landlordId'] as String?),
          leaseStartDate: Value(dbData['leaseStartDate'] != null
              ? DateTime.parse(dbData['leaseStartDate'] as String)
              : null),
          leaseEndDate: Value(dbData['leaseEndDate'] != null
              ? DateTime.parse(dbData['leaseEndDate'] as String)
              : null),
        ),
      );
    }

    /// Delete group
    Future<void> deleteGroup(String id) async {
      await database.groupDao.deleteGroup(id);
    }
  }