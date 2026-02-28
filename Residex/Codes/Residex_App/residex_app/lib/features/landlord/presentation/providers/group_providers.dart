import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../../shared/domain/entities/groups/app_group.dart';

  final groupsProvider = FutureProvider<List<AppGroup>>((ref) async {
    final repository = ref.watch(groupRepositoryProvider);
    final result = await repository.getAllGroups();
    return result.fold(
      (failure) => [],
      (groups) => groups,
    );
  });