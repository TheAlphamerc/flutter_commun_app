import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_main_menu_state.dart';
part 'bottom_main_menu_cubit.freezed.dart';

class BottomMainMenuCubit extends Cubit<BottomMainMenuState> {
  BottomMainMenuCubit() : super(const BottomMainMenuState.initial(0));

  void updateCurrentPageIndex(int index) {
    emit(BottomMainMenuState.changeIndex(index));
  }
}
