import 'package:flutter/material.dart';

/// A utility class for animations in the app
class AppAnimations {
  /// Fade transition for widgets
  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Scale transition for widgets
  static Widget scaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return ScaleTransition(
      scale: animation,
      child: child,
    );
  }

  /// Slide transition for widgets
  static Widget slideTransition({
    required Widget child,
    required Animation<double> animation,
    required Offset beginOffset,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  /// Combined fade and scale transition
  static Widget fadeScaleTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  /// Page route transition
  static PageRouteBuilder<T> pageRouteBuilder<T>({
    required Widget page,
    required RouteSettings settings,
    TransitionType transitionType = TransitionType.fadeAndScale,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        switch (transitionType) {
          case TransitionType.fade:
            return fadeTransition(
              animation: curvedAnimation,
              child: child,
            );
          case TransitionType.scale:
            return scaleTransition(
              animation: curvedAnimation,
              child: child,
            );
          case TransitionType.slideFromRight:
            return slideTransition(
              animation: curvedAnimation,
              beginOffset: const Offset(1.0, 0.0),
              child: child,
            );
          case TransitionType.slideFromLeft:
            return slideTransition(
              animation: curvedAnimation,
              beginOffset: const Offset(-1.0, 0.0),
              child: child,
            );
          case TransitionType.slideFromBottom:
            return slideTransition(
              animation: curvedAnimation,
              beginOffset: const Offset(0.0, 1.0),
              child: child,
            );
          case TransitionType.fadeAndScale:
            return fadeScaleTransition(
              animation: curvedAnimation,
              child: child,
            );
          case TransitionType.slideFromTop:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      },
    );
  }

  /// Staggered list animation
  static List<Widget> staggeredList({
    required List<Widget> children,
    required AnimationController controller,
    Duration staggerDuration = const Duration(milliseconds: 50),
  }) {
    return List.generate(children.length, (index) {
      final delay = index * staggerDuration.inMilliseconds;
      final Animation<double> animation = CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay / (children.length * staggerDuration.inMilliseconds),
          (delay + staggerDuration.inMilliseconds) /
              (children.length * staggerDuration.inMilliseconds),
          curve: Curves.easeOut,
        ),
      );

      return fadeScaleTransition(
        animation: animation,
        child: children[index],
      );
    });
  }

  /// Pulse animation for attention
  static Widget pulseAnimation({
    required Widget child,
    required AnimationController controller,
  }) {
    final Animation<double> animation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Shimmer loading effect
  static Widget shimmerLoading({
    required Widget child,
    required AnimationController controller,
    Color baseColor = const Color(0xFFEEEEEE),
    Color highlightColor = const Color(0xFFFAFAFA),
  }) {
    final Animation<double> animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(animation.value - 1, 0),
              end: Alignment(animation.value, 0),
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }
}

/// Enum for transition types
enum TransitionType {
  fade,
  scale,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  fadeAndScale, slideFromTop,
}

/// Extension for AnimationController to simplify common patterns
extension AnimationControllerExtension on AnimationController {
  void repeatPulse() {
    repeat(reverse: true);
  }

  void repeatShimmer() {
    repeat();
  }
}

/// A stateful widget that provides staggered animations for its children
class StaggeredAnimationList extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDuration;
  final Duration animationDuration;
  final Axis direction;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const StaggeredAnimationList({
    super.key,
    required this.children,
    this.staggerDuration = const Duration(milliseconds: 50),
    this.animationDuration = const Duration(milliseconds: 400),
    this.direction = Axis.vertical,
    this.physics,
    this.padding,
  });

  @override
  State<StaggeredAnimationList> createState() => _StaggeredAnimationListState();
}

class _StaggeredAnimationListState extends State<StaggeredAnimationList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animatedChildren = AppAnimations.staggeredList(
      children: widget.children,
      controller: _controller,
      staggerDuration: widget.staggerDuration,
    );

    return widget.direction == Axis.vertical
        ? ListView(
            physics: widget.physics,
            padding: widget.padding,
            children: animatedChildren,
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: widget.physics,
            padding: widget.padding,
            child: Row(children: animatedChildren),
          );
  }
}

/// A widget that animates when it first appears
class AnimatedAppearance extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final TransitionType transitionType;
  final Curve curve;

  const AnimatedAppearance({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.transitionType = TransitionType.fadeAndScale,
    this.curve = Curves.easeInOut,
  });

  @override
  State<AnimatedAppearance> createState() => _AnimatedAppearanceState();
}

class _AnimatedAppearanceState extends State<AnimatedAppearance>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.transitionType) {
      case TransitionType.fade:
        return AppAnimations.fadeTransition(
          animation: _animation,
          child: widget.child,
        );
      case TransitionType.scale:
        return AppAnimations.scaleTransition(
          animation: _animation,
          child: widget.child,
        );
      case TransitionType.slideFromRight:
        return AppAnimations.slideTransition(
          animation: _animation,
          beginOffset: const Offset(1.0, 0.0),
          child: widget.child,
        );
      case TransitionType.slideFromLeft:
        return AppAnimations.slideTransition(
          animation: _animation,
          beginOffset: const Offset(-1.0, 0.0),
          child: widget.child,
        );
      case TransitionType.slideFromBottom:
        return AppAnimations.slideTransition(
          animation: _animation,
          beginOffset: const Offset(0.0, 1.0),
          child: widget.child,
        );
      case TransitionType.fadeAndScale:
        return AppAnimations.fadeScaleTransition(
          animation: _animation,
          child: widget.child,
        );
      case TransitionType.slideFromTop:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
