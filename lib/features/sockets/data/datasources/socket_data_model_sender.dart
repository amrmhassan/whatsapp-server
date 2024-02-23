import 'dart:async';
import 'dart:io';

import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/user_data_sending_id.dart';

//! next thing is the trying multiple times and adding the timeout

class SocketDataModelSender {
  final Completer<bool> _completer = Completer<bool>();
  StreamSubscription<SocketDataModel>? _subscription;

  Future<bool> sendToClient(
    WebSocket webSocket,
    SocketDataModel dataModel,
    UserDataSendingId sendingId,
  ) async {
    String hash = dataModel.hash;
    _waitForUserResponse(
      hash,
      dataModel.path,
      dataModel.method,
      sendingId,
      dataModel.id,
    );
    webSocket.add(dataModel.toString());
    return _completer.future;
  }

  void _waitForUserResponse(
    String hash,
    String path,
    SocketMethod method,
    UserDataSendingId userDataSendingId,
    String requestId,
  ) {
    _subscription = serverSocket
        .addListener(
      path: path,
      method: method,
      userDataSendingId: userDataSendingId,
    )
        .listen((event) {
      if (event.id == requestId) {
        String receivedHash = event.hash;
        _completer.complete(receivedHash == hash);
        _subscription?.cancel();
      }
    });
  }
}
