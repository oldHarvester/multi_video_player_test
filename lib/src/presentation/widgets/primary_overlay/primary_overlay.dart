import 'package:flutter/material.dart';

import 'primary_overlay_controller.dart';

class PrimaryOverlayData {}

class PrimaryOverlay extends StatefulWidget {
  const PrimaryOverlay({
    super.key,
    this.overlayController,
    required this.targetBuilder,
    this.animationBuilder,
    this.followerAnchor = Alignment.topCenter,
    this.targetAnchor = Alignment.bottomCenter,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration = const Duration(milliseconds: 200),
    this.curve = Curves.easeIn,
    this.reverseCurve = Curves.easeOut,
    required this.builder,
    this.tapRegionId,
    this.offset = Offset.zero,
    this.enable = false,
  });

  final bool enable;
  final Object? tapRegionId;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final PrimaryOverlayController? overlayController;
  final Duration duration;
  final Offset offset;
  final Duration reverseDuration;
  final Curve curve;
  final Curve reverseCurve;
  final Widget Function(
    BuildContext context,
    PrimaryOverlayData data,
  ) targetBuilder;
  final Widget Function(
    BuildContext context,
    PrimaryOverlayData data,
  ) builder;
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )? animationBuilder;

  @override
  State<PrimaryOverlay> createState() => _PrimaryOverlayState();
}

class _PrimaryOverlayState extends State<PrimaryOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final PrimaryOverlayController _overlayController;
  late final Animation<double> _animation;
  late PrimaryOverlayState _previousState;

  @override
  void initState() {
    super.initState();
    _overlayController = widget.overlayController ??
        PrimaryOverlayController(
          initialState: PrimaryOverlayState(
            show: widget.enable,
          ),
        );
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      value: _overlayController.value.show ? 1 : 0,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );
    _overlayController.addListener(_overlayListener);
    _previousState = _overlayController.value;
  }

  @override
  void didUpdateWidget(covariant PrimaryOverlay oldWidget) {
    if (oldWidget.enable != widget.enable) {
      if (widget.enable) {
        _overlayController.show();
      } else {
        _overlayController.hide();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _overlayListener() {
    final newState = _overlayController.value;
    if (newState != _previousState) {
      if (newState.show != _previousState.show) {
        if (newState.show) {
          _overlayController.showOverlay();
          _animationController.animateTo(1, duration: widget.duration);
        } else {
          _animationController
              .animateTo(0, duration: widget.reverseDuration)
              .then(
            (value) {
              _overlayController.hideOverlay();
            },
          );
        }
      }
      _previousState = newState;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayController.removeListener(_overlayListener);
    if (widget.overlayController == null) {
      _overlayController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animationBuilder = widget.animationBuilder;
    final data = PrimaryOverlayData();
    return CompositedTransformTarget(
      link: _overlayController.layerLink,
      child: OverlayPortal(
        controller: _overlayController.getOverlayPortalController(),
        overlayChildBuilder: (context) {
          final target = widget.targetBuilder(context, data);
          return Center(
            child: ValueListenableBuilder(
              valueListenable: _overlayController,
              builder: (context, overlayState, child) {
                final show = overlayState.show;
                return CompositedTransformFollower(
                  showWhenUnlinked: false,
                  offset: widget.offset,
                  link: _overlayController.layerLink,
                  followerAnchor: widget.followerAnchor,
                  targetAnchor: widget.targetAnchor,
                  child: IgnorePointer(
                    ignoring: !show,
                    child: TapRegion(
                      groupId: widget.tapRegionId,
                      child: animationBuilder != null
                          ? animationBuilder(context, _animation, target)
                          : FadeTransition(
                              opacity: _animation,
                              child: target,
                            ),
                    ),
                  ),
                );
              },
            ),
          );
        },
        child: widget.builder(context, data),
      ),
    );
  }
}
