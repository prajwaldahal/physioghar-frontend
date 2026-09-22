import '../../../core/data/api_client.dart';
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

class RemoteProfileRepository implements ProfileRepository {
  const RemoteProfileRepository(this._api);

  final ApiClient _api;

  @override
  Future<TherapistProfile> fetchProfile() async {
    return TherapistProfile.fromApi(await _api.getObject('/api/v1/profile'));
  }
}
