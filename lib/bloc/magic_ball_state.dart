part of 'magic_ball_bloc.dart';

@immutable
abstract class MagicBallState {
  const MagicBallState();
}

class MagicBallInitial extends MagicBallState {
  final String text;

  const MagicBallInitial({required this.text});
}

class MagicBallLoadingState extends MagicBallState {}

class MagicBallLoadedState extends MagicBallState {
  final String text;

  const MagicBallLoadedState({required this.text});
}
