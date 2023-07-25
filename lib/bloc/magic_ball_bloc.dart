import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:surf_practice_magic_ball/domain/api_clients/api_clients.dart';

part 'magic_ball_event.dart';
part 'magic_ball_state.dart';

class MagicBallBloc extends Bloc<MagicBallEvent, MagicBallState> {
  MagicBallBloc() : super(const MagicBallInitial(text: "")) {
    on<OnBallMagicBallEvent>(_onPressedMagicBall);
  }

  void _onPressedMagicBall(OnBallMagicBallEvent event, emit) async {
    final apiClient = ApiClient();
    event.controller.repeat(reverse: true);
    emit(MagicBallLoadingState());
    var text = await apiClient.getRandomReading();
    event.controller.reset();
    event.controller.value = 0.5;
    emit(MagicBallLoadedState(text: text ?? ""));
  }
}
