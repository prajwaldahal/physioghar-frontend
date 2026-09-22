import '../../../core/data/mock_data_source.dart';
import '../../../core/models/therapist_profile.dart';

abstract class ProfileRepository {
  Future<TherapistProfile> fetchProfile();
}

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository(this._source);

  final MockDataSource _source;

  @override
  Future<TherapistProfile> fetchProfile() async {
    return TherapistProfile.fromJson(await _source.loadObject('profile'));
  }
}
