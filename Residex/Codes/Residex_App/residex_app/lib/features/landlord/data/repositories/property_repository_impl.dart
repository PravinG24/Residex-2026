import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../shared/domain/entities/groups/app_group.dart';
import '../../../shared/domain/repositories/groups/group_repository.dart';
import '../datasources/property_local_datasource.dart';
import '../models/property_model.dart';

  /// Implementation of GroupRepository using local data source
  class GroupRepositoryImpl implements GroupRepository {
    final GroupLocalDataSource localDataSource;

    GroupRepositoryImpl({required this.localDataSource});

    @override
    Future<Either<Failure, List<AppGroup>>> getAllGroups() async {
      try {
        final groups = await localDataSource.getAllGroups();
        return Right(groups.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to get groups: ${e.toString()}'));
      }
    }

    @override
    Future<Either<Failure, AppGroup?>> getGroupById(String id) async {
      try {
        final group = await localDataSource.getGroupById(id);
        return Right(group?.toEntity());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to get group: ${e.toString()}'));
      }
    }

    @override
    Future<Either<Failure, void>> createGroup(AppGroup group) async {
      try {
        final groupModel = AppGroupModel.fromEntity(group);
        await localDataSource.upsertGroup(groupModel);
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to create group: ${e.toString()}'));
      }
    }

    @override
    Future<Either<Failure, void>> updateGroup(AppGroup group) async {
      try {
        final groupModel = AppGroupModel.fromEntity(group);
        await localDataSource.upsertGroup(groupModel);
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to update group: ${e.toString()}'));
      }
    }

    @override
    Future<Either<Failure, void>> deleteGroup(String groupId) async {
      try {
        await localDataSource.deleteGroup(groupId);
        return const Right(null);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(CacheFailure('Failed to delete group: ${e.toString()}'));
      }
    }

    @override
    Future<Either<Failure, void>> addMemberToGroup({
      required String groupId,
      required String userId,
    }) async {
      try {
        final groupResult = await getGroupById(groupId);

        return groupResult.fold(
          (failure) => Left(failure),
          (group) async {
            if (group == null) {
              return const Left(CacheFailure('Group not found'));
            }

            if (group.tenantIds.contains(userId)) {
              return const Right(null); // Already a member
            }

            final updatedGroup = group.copyWith(
              tenantIds: [...group.tenantIds, userId],
            );

            return await updateGroup(updatedGroup);
          },
        );
      } catch (e) {
        return Left(CacheFailure('Failed to add member: ${e.toString()}'));
      }
    }

    @override
    Future<Either<Failure, void>> removeMemberFromGroup({
      required String groupId,
      required String userId,
    }) async {
      try {
        final groupResult = await getGroupById(groupId);

        return groupResult.fold(
          (failure) => Left(failure),
          (group) async {
            if (group == null) {
              return const Left(CacheFailure('Group not found'));
            }

            final updatedMemberIds = group.tenantIds.where((id) => id != userId).toList();

            final updatedGroup = group.copyWith(tenantIds: updatedMemberIds);

            return await updateGroup(updatedGroup);
          },
        );
      } catch (e) {
        return Left(CacheFailure('Failed to remove member: ${e.toString()}'));
      }
    }
  }