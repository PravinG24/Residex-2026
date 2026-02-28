  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import '../../../../core/di/injection.dart';
  import '../../domain/entities/property.dart';
  import '../../../../../features/shared/domain/entities/groups/app_group.dart';

  /// Provider for all groups
  final groupsProvider = FutureProvider<List<AppGroup>>((ref) async {
    final repository = ref.watch(groupRepositoryProvider);
    final result = await repository.getAllGroups();

    return result.fold(
      (failure) => throw Exception(failure.message),
      (groups) => groups,
    );
  });

  /// Provider for a specific group by ID
  final groupByIdProvider = FutureProvider.family<AppGroup?, String>((ref, groupId) async {      
    final repository = ref.watch(groupRepositoryProvider);
    final result = await repository.getGroupById(groupId);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (group) => group,
    );
  });