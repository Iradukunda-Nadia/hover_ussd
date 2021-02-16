import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum TransactionState { succesfull, waiting, failed }

class HoverUssd {
  final MethodChannel _methodChannel;

  factory HoverUssd() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel('hover_ussd');
      _instance = HoverUssd.private(methodChannel);
    }
    return _instance;
  }

  static HoverUssd _instance;

  @visibleForTesting
  HoverUssd.private(this._methodChannel);

  Stream<TransactionState> _onTransactionStateChanged;

  Future sendUssd(
          {@required String actionId, Map<String, String> extras}) async =>
      await _methodChannel.invokeMethod(
          "hoverStartTransaction", {"action_id": actionId, "extras": extras});


  Future initialize() async {
    await _methodChannel.invokeMethod("hoverInitial");
  }

  TransactionState _parseTransactionState(String state) {
    switch (state) {
      case "succeeded":
        return TransactionState.succesfull;
        break;
      case "pending":
        return TransactionState.waiting;
      case "failed":
        return TransactionState.failed;
      default:
        throw ArgumentError('$state');
    }
  }
}
