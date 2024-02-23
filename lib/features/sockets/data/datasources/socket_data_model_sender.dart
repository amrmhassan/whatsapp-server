import 'dart:async';
import 'dart:io';

import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class SocketDataModelSender {
  final int retries;

  /// in milliseconds
  final int timeout;
  SocketDataModelSender({
    this.retries = 5,

    /// 3 seconds
    this.timeout = 3000,
  });

  final Completer<bool> _completer = Completer<bool>();

  Future<bool> sendToClient(
    WebSocket webSocket,
    SocketDataModel dataModel,
  ) async {
    String hash = dataModel.hash;
    waitForUserResponse(hash);
    webSocket.add(dataModel.toString());
    return _completer.future;
  }

  void waitForUserResponse(String hash) {}
}
