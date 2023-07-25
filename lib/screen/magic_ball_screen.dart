import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:surf_practice_magic_ball/bloc/magic_ball_bloc.dart';

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({Key? key}) : super(key: key);

  @override
  State<MagicBallScreen> createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen>
    with TickerProviderStateMixin {
  final bloc = MagicBallBloc();

  late ShakeDetector _detector;
  late AnimationController _upDownController;
  late AnimationController _shakeController;
  late final _shakeTween = Tween(begin: -pi, end: pi).animate(_shakeController);

  @override
  void initState() {
    super.initState();

    _detector = ShakeDetector.autoStart(
      onPhoneShake: () =>
          bloc.add(OnBallMagicBallEvent(controller: _shakeController)),
      shakeThresholdGravity: 3.5,
    );

    _upDownController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      value: 0.5,
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      lowerBound: 0,
      upperBound: 1,
    );
    _shakeTween.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _detector.stopListening();
    _upDownController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Spacer(),
            AnimatedBuilder(
              animation: _upDownController,
              builder: (context, child) {
                final controllerValue = CurvedAnimation(
                        parent: _upDownController, curve: Curves.easeInOut)
                    .value;
                return Transform.translate(
                  offset:
                      Offset(_shakeTween.value * 20, controllerValue * 100),
                  child: GestureDetector(
                    onTap: () {
                      bloc.add(
                          OnBallMagicBallEvent(controller: _shakeController));
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.cyan,
                            Colors.greenAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: _MagicBallContent(bloc: bloc),
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                'Нажмите на шар или потрясите телефон',
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _MagicBallContent extends StatelessWidget {
  const _MagicBallContent({required this.bloc});
  final MagicBallBloc bloc;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: Colors.black),
        child: Center(
          child: BlocBuilder<MagicBallBloc, MagicBallState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is MagicBallLoadingState) {
                return const CircularProgressIndicator();
              }
              if (state is MagicBallLoadedState) {
                return Text(
                  state.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return const Text("");
            },
          ),
        ),
      ),
    );
  }
}
