part of 'bottom_main_menu_cubit.dart';

@freezed
abstract class BottomMainMenuState with _$BottomMainMenuState {
  const factory BottomMainMenuState.initial(int pageIndex) = _Initial;
  const factory BottomMainMenuState.changeIndex(int pageIndex) = _ChangeIndex;
}
