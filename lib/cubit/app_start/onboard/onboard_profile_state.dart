part of 'onboard_profile_cubit.dart';

@freezed
abstract class OnboardProfileState with _$OnboardProfileState {
  const factory OnboardProfileState.initial(ProfileModel model) = _Initial;
  const factory OnboardProfileState.response(
      EOnboardProfileState response, String message) = _Response;
}
