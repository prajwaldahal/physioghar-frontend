import '../../../core/data/api_client.dart';
import '../../../core/data/mock_data_source.dart';
import '../../../core/models/therapist_profile.dart';

abstract class ProfileRepository {
  Future<TherapistProfile> fetchProfile();
  Future<TherapistProfile> save(TherapistProfile profile);
}

class MockProfileRepository implements ProfileRepository {
  const MockProfileRepository(this._source);

  final MockDataSource _source;

  @override
  Future<TherapistProfile> fetchProfile() async {
    return TherapistProfile.fromJson(await _source.loadObject('profile'));
  }

  @override
  Future<TherapistProfile> save(TherapistProfile profile) async => profile;
}

class RemoteProfileRepository implements ProfileRepository {
  const RemoteProfileRepository(this._api);

  final ApiClient _api;

  @override
  Future<TherapistProfile> fetchProfile() async {
    return TherapistProfile.fromApi(await _api.getObject('/api/v1/profile'));
  }

  @override
  Future<TherapistProfile> save(TherapistProfile profile) async =>
      TherapistProfile.fromApi(
        await _api.putObject(
          '/api/v1/profile',
          body: {
            'name': profile.name,
            'email': profile.email,
            'phone': profile.phone,
            'experienceYears': profile.experienceYears,
            'specialization': profile.specialization,
            'address': profile.address,
          },
        ),
      );
}
