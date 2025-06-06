import 'package:flutter/material.dart';
import '../../services/accessibility_service.dart';
import '../../utils/tap_target_utils.dart';

class AnimatedAdaptiveConstraint extends StatefulWidget {
  final AccessibilityService service;
  final Widget Function(
    BuildContext context,
    double animatedMinSize,
    EdgeInsetsGeometry animatedPadding,
  )
  builder;
  final double? customMinTapTarget;
  final EdgeInsetsGeometry? customPadding;

  static const Duration _animationDuration = Duration(milliseconds: 200);
  static const Curve _animationCurve = Curves.linear;

  const AnimatedAdaptiveConstraint({
    super.key,
    required this.service,
    required this.builder,
    this.customMinTapTarget,
    this.customPadding,
  });

  @override
  State<AnimatedAdaptiveConstraint> createState() =>
      _AnimatedAdaptiveConstraintState();
}

class _AnimatedAdaptiveConstraintState
    extends State<AnimatedAdaptiveConstraint> {
  late double _targetMinSize;
  late EdgeInsetsGeometry _targetPadding;

  @override
  void initState() {
    super.initState();
    _updateTargets();
    widget.service.addListener(_serviceListener);
  }

  void _serviceListener() {
    final newMinSize =
        widget.customMinTapTarget ??
        TapTargetUtils.getEffectiveMinTapTargetSize(widget.service);
    final newPadding =
        widget.customPadding ??
        TapTargetUtils.getAdaptivePadding(accessibilityService: widget.service);

    if (newMinSize != _targetMinSize || newPadding != _targetPadding) {
      if (mounted) {
        setState(() {
          _targetMinSize = newMinSize;
          _targetPadding = newPadding;
        });
      }
    }
  }

  void _updateTargets() {
    _targetMinSize =
        widget.customMinTapTarget ??
        TapTargetUtils.getEffectiveMinTapTargetSize(widget.service);
    _targetPadding =
        widget.customPadding ??
        TapTargetUtils.getAdaptivePadding(accessibilityService: widget.service);
  }

  @override
  void didUpdateWidget(AnimatedAdaptiveConstraint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.service != oldWidget.service) {
      oldWidget.service.removeListener(_serviceListener);
      _updateTargets(); // Update targets with the new service
      widget.service.addListener(_serviceListener);
    } else if (widget.customMinTapTarget != oldWidget.customMinTapTarget ||
        widget.customPadding != oldWidget.customPadding) {
      // If custom props change, update targets and trigger animation
      final newMinSize =
          widget.customMinTapTarget ??
          TapTargetUtils.getEffectiveMinTapTargetSize(widget.service);
      final newPadding =
          widget.customPadding ??
          TapTargetUtils.getAdaptivePadding(
            accessibilityService: widget.service,
          );
      if (newMinSize != _targetMinSize || newPadding != _targetPadding) {
        if (mounted) {
          setState(() {
            _targetMinSize = newMinSize;
            _targetPadding = newPadding;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    widget.service.removeListener(_serviceListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: _targetMinSize),
      duration: AnimatedAdaptiveConstraint._animationDuration,
      curve: AnimatedAdaptiveConstraint._animationCurve,
      builder: (context, animatedMinSize, _) {
        return TweenAnimationBuilder<EdgeInsetsGeometry>(
          tween: EdgeInsetsTween(
            end: _targetPadding is EdgeInsets
                ? _targetPadding as EdgeInsets
                : _targetPadding.resolve(Directionality.of(context)),
          ),
          duration: AnimatedAdaptiveConstraint._animationDuration,
          curve: AnimatedAdaptiveConstraint._animationCurve,
          builder: (context, animatedPadding, _) {
            return widget.builder(context, animatedMinSize, animatedPadding);
          },
        );
      },
    );
  }
}
