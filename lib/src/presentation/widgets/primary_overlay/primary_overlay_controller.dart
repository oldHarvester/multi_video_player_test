import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PrimaryOverlayState with EquatableMixin {
  const PrimaryOverlayState({required this.show});

  final bool show;

  PrimaryOverlayState copyWith({
    bool? show,
  }) {
    return PrimaryOverlayState(
      show: show ?? this.show,
    );
  }

  @override
  List<Object?> get props => [show];
}

class PrimaryOverlayController extends ValueNotifier<PrimaryOverlayState> {
  PrimaryOverlayController({PrimaryOverlayState? initialState})
      : super(
          initialState ??
              const PrimaryOverlayState(
                show: false,
              ),
        ) {
    _overlayController.show();
  }

  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink layerLink = LayerLink();
  Completer? _showHideOverlayCompleter;

  OverlayPortalController getOverlayPortalController() {
    return _overlayController;
  }

  Future<void> _showHideOverlay(bool show) async {
    final completer = Completer();
    _showHideOverlayCompleter = completer;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        try {
          if (_showHideOverlayCompleter == completer) {
            if (show) {
              _overlayController.show();
            } else {
              _overlayController.hide();
            }
            completer.complete();
          }
        } catch (e) {
          completer.completeError(e);
        }
      },
    );
  }

  Future<void> showOverlay() {
    return _showHideOverlay(true);
  }

  Future<void> hideOverlay() {
    return _showHideOverlay(false);
  }

  void updateValue(
    PrimaryOverlayState Function(PrimaryOverlayState old) onChange,
  ) {
    final newState = onChange(value);
    value = newState;
  }

  void show() {
    updateValue(
      (old) => old.copyWith(
        show: true,
      ),
    );
  }

  void hide() {
    updateValue(
      (old) => old.copyWith(show: false),
    );
  }

  void toggle() {
    updateValue(
      (old) {
        return old.copyWith(
          show: !old.show,
        );
      },
    );
  }
}
