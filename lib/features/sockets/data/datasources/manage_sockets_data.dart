import 'dart:convert';
import 'dart:io';

import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/runtime_variables.dart';

class ManageSocketsData {
  Future<void> sendToClientBySessionId(
    String sessionId, {
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
  }) async {
    var socket = (await socketManager.socketBySessionId(sessionId))?.webSocket;
    if (socket == null) {
      logger.e('This user id doesn\'t exist');
      return;
    } else {
      await _sendToClient(
        webSocket: socket,
        path: path,
        method: method,
        body: body,
        headers: headers,
        receivedAt: receivedAt,
      );
    }
  }

  Future<void> sendToClientByUserID(
    String userId, {
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
  }) async {
    var socket = (await socketManager.socketByUserId(userId))?.webSocket;
    if (socket == null) {
      logger.e('This user id doesn\'t exist');
      return;
    } else {
      await _sendToClient(
        webSocket: socket,
        path: path,
        method: method,
        body: body,
        headers: headers,
        receivedAt: receivedAt,
      );
    }
  }

  Future<void> _sendToClient({
    required WebSocket webSocket,
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
  }) async {
    SocketDataModel dataModel = SocketDataModel(
      path: path,
      method: method,
      body: json.encode(body),
      headers: headers,
      receivedAt: receivedAt,
      sentAtServer: DateTime.now(),
    );
    webSocket.add(dataModel.toString());
  }
}
