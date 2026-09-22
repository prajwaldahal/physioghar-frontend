import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/api_client.dart';
import '../../../core/data/data_providers.dart';
import '../../../core/models/therapist_profile.dart';
import '../repository/profile_repository.dart';

class ProfileException implements Exception {
  const ProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final api = ref.watch(apiClientProvider);
  return api == null
      ? MockProfileRepository(ref.watch(mockDataSourceProvider))
      : RemoteProfileRepository(api);
});

class ProfileNotifier extends AsyncNotifier<TherapistProfile> {
  @override
  Future<TherapistProfile> build() {
    return ref.watch(profileRepositoryProvider).fetchProfile();
  }

  Future<void> save(TherapistProfile updated) async {
    try {
      state = AsyncData(
        await ref.read(profileRepositoryProvider).save(updated),
      );
    } on ApiException catch (e) {
      throw ProfileException(e.message);
    }
  }

  void reset() => ref.invalidateSelf();
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, TherapistProfile>(
      ProfileNotifier.new,
    );

final therapistNameProvider = Provider<String>((ref) {
  return ref.watch(profileProvider).value?.name ?? '';
});
