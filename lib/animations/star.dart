import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:slide_puzzle/presentation/puzzle/blocs/puzzle_bloc/puzzle_bloc.dart';

class Sparkling extends StatefulWidget {
  Sparkling({Key? key, required this.animate, required this.horizontal})
      : super(key: key);
  bool animate = false;
  bool horizontal;

  // PuzzleBloc puzzleBloc;

  @override
  _SparklingState createState() => _SparklingState();
}

class _SparklingState extends State<Sparkling>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late List<MyStar> myStars;

  @override
  void initState() {
    super.initState();

    myStars = <MyStar>[];
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 250,
        ));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //   for (final star in myStars) {
        //     star.isEnable = math.Random().nextBool();
        //   }
        animationController.forward();
      }
    });
    animation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutSine));
    animation.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void postFrameCallback(_) {
    if (!mounted) {
      return;
    }
    final size = MediaQuery.of(context).size;
    myStars.removeWhere((element) => element.itr >= 10);
    for (final star in myStars) {
      star.itr += 1;
      star.center = star.center + star.velocity;
      if (star.isEnable) {
        // star.innerOuterRadiusRatio = animation.value;
        star.innerOuterRadiusRatio = 1.0 + star.itr / 2;

        // if (star.center.dx >= size.width) {
        //   if (star.velocity.dy > 0) {
        //     star.velocity = const Offset(-1, 1);
        //   } else {
        //     star.velocity = const Offset(-1, -1);
        //   }

        //   star.center = Offset(size.width, star.center.dy);
        // } else if (star.center.dx <= 0) {
        //   if (star.velocity.dy > 0) {
        //     star.velocity = const Offset(1, 1);
        //   } else {
        //     star.velocity = const Offset(1, -1);
        //   }

        //   star.center = Offset(0, star.center.dy);
        // } else if (star.center.dy >= size.height) {
        //   if (star.velocity.dx > 0) {
        //     star.velocity = const Offset(1, -1);
        //   } else {
        //     star.velocity = const Offset(-1, -1);
        //   }

        //   star.center = Offset(star.center.dx, size.height);
        // } else if (star.center.dy <= 0) {
        //   if (star.velocity.dx > 0) {
        //     star.velocity = const Offset(1, 1);
        //   } else {
        //     star.velocity = const Offset(-1, 1);
        //   }

        //   star.center = Offset(star.center.dx, 0);
        // }
      }
    }
    // if (myStars.length < 40) {

    if (widget.animate) {
      myStars.addAll(List.generate(4, (index) {
        double velocityX = -3 * (math.Random().nextDouble());
        double velocityY = -4 * (math.Random().nextDouble());
        if (widget.horizontal) {
          velocityX = -4 * (math.Random().nextDouble());
          // if (math.Random().nextBool()) velocityX *= -1; //max velocity 2
          velocityY = -3 * (math.Random().nextDouble());
          if (math.Random().nextBool()) velocityY *= -1; //max velocity 2
        } else {
          if (math.Random().nextBool()) velocityX *= -1; //max velocity 2
        }
        // velocityX = math.Random().nextBool() ? velocityX : -velocityX;
        // velocityY = math.Random().nextBool() ? velocityY : -velocityY;
        // velocityX = widget.horizontal ? 2 : 0;
        // velocityY = widget.horizontal ? 0 : 2;

        return MyStar(
            // isEnable: math.Random().nextBool(),
            isEnable: true,
            innerCirclePoints: 6,
            beamLength: math.Random().nextDouble() * (8 - 2) + 8,
            innerOuterRadiusRatio: 0.0,
            angleOffsetToCenterStar: 0,
            // center: Offset(size.width * (math.Random().nextDouble()),
            //     size.height * (math.Random().nextDouble())),
            center: Offset(0, 0),
            velocity: Offset(velocityX, velocityY),
            color: Color(0xFF8C0303));
      }));
    }
    // } else {

    // }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(postFrameCallback);

    return CustomPaint(
        size: MediaQuery.of(context).size,
        painter: StarPainter(
          myStars: myStars,
        ));
  }
}

class StarPainter extends CustomPainter {
  List<MyStar> myStars;

  StarPainter({required this.myStars});

  List<Map> calcStarPoints(
      {required double centerX,
      required double centerY,
      required int innerCirclePoints,
      required double innerRadius,
      required double outerRadius,
      required double angleOffsetToCenterStar}) {
    final angle = ((math.pi) / innerCirclePoints);

    final totalPoints = innerCirclePoints * 2; // 10 in a 5-points star
    List<Map> points = [];
    for (int i = 0; i < totalPoints; i++) {
      bool isEvenIndex = i % 2 == 0;
      final r = isEvenIndex ? outerRadius : innerRadius;

      var currY = centerY + math.cos(i * angle + angleOffsetToCenterStar) * r;
      var currX = centerX + math.sin(i * angle + angleOffsetToCenterStar) * r;
      points.add({'x': currX, 'y': currY});
    }
    return points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final myStar in myStars) {
      final innerRadius = myStar.beamLength / myStar.innerCirclePoints;
      final outerRadius = innerRadius * myStar.innerOuterRadiusRatio;

      List<Map> points = calcStarPoints(
          centerX: myStar.center.dx,
          centerY: myStar.center.dy,
          innerCirclePoints: myStar.innerCirclePoints,
          innerRadius: innerRadius,
          outerRadius: outerRadius,
          angleOffsetToCenterStar: myStar.angleOffsetToCenterStar);
      var star = Path()..moveTo(points[0]['x'], points[0]['y']);
      for (var point in points) {
        star.lineTo(point['x'], point['y']);
      }

      canvas.drawPath(
        star,
        Paint()..color = myStar.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyStar {
  bool isEnable;
  int innerCirclePoints; //how many edges you need?
  double beamLength;
  double
      innerOuterRadiusRatio; // outter circle is x2 the inner // set star sharpness/chubbiness
  double angleOffsetToCenterStar;
  Offset center;
  Offset velocity;
  Color color;
  int itr = 0;

  MyStar(
      {required this.isEnable,
      required this.innerCirclePoints,
      required this.beamLength,
      required this.innerOuterRadiusRatio,
      required this.angleOffsetToCenterStar,
      required this.center,
      required this.velocity,
      required this.color});
}
