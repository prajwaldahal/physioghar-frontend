import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/data_providers.dart';
import '../../../core/models/therapist_profile.dart';
import '../repository/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => MockProfileRepository(ref.watch(mockDataSourceProvider)),
);

class ProfileNotifier extends AsyncNotifier<TherapistProfile> {
  @override
  Future<TherapistProfile> build() {
    return ref.watch(profileRepositoryProvider).fetchProfile();
  }

  void save(TherapistProfile updated) => state = AsyncData(updated);

  void reset() => ref.invalidateSelf();
}

final profileProvider =
    AsyncNotifierProvider<ProfileNotifier, TherapistProfile>(
      ProfileNotifier.new,
    );

final therapistNameProvider = Provider<String>((ref) {
  return ref.watch(profileProvider).value?.name ?? '';
});
