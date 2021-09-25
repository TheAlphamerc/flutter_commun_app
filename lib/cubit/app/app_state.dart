part of 'app_cubit.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial() = _Initial;
  const factory AppState.response(
      {required EAppState estate, required String message}) = _Response;
}
