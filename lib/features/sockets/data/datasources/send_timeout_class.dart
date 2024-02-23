import 'dart:async';
import 'dart:io';

import 'package:whatsapp_server/features/sockets/data/datasources/socket_data_model_sender.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/user_data_sending_id.dart';

class SendTimeoutClass {
  final int _retries;

  /// in milliseconds
  /// this is the timeout for each try
  final int _timeout;
  SendTimeoutClass({
    int retries = 5,

    /// 3 seconds
    int timeout = 3000,
  })  : _timeout = timeout,
        _retries = retries;
  final SocketDataModelSender _dataModelSender = SocketDataModelSender();

  Future<bool> sendToClient(
    WebSocket webSocket,
    SocketDataModel dataModel,
    UserDataSendingId sendingId,
  ) async {
    bool sent = false;
    for (var i = 0; i < _retries; i++) {
      var dataSentFuture =
          _dataModelSender.sendToClient(webSocket, dataModel, sendingId);
      var timeoutFuture = _timeoutFuture();
      var res = await _firstFutureToCome([dataSentFuture, timeoutFuture]);
      if (res) {
        sent = true;
        break;
      }
    }
    return sent;
  }

  Future<bool> _timeoutFuture() async {
    await Future.delayed(Duration(milliseconds: _timeout));
    return false;
  }

  Future<T> _firstFutureToCome<T>(List<Future<T>> futures) async {
    Completer<T> completer = Completer<T>();
    for (var future in futures) {
      future.then((value) {
        if (!completer.isCompleted) {
          completer.complete(value);
        }
      });
    }
    return completer.future;
  }
}
