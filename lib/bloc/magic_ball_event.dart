part of 'magic_ball_bloc.dart';

@immutable
abstract class MagicBallEvent {
  const MagicBallEvent();
}

class OnBallMagicBallEvent extends MagicBallEvent {
  final AnimationController controller;

  const OnBallMagicBallEvent({required this.controller});
}