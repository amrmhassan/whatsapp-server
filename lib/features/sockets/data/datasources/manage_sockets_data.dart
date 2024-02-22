import 'dart:io';

import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/msg_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class ManageSocketsData {
  // this is just used by the server to send and receive the user id then the client will be managed by his id
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
      MsgModel model = MsgModel.fromJson(body);
      await cronJobManager.createJob(
        jobType: CronJobType.message,
        issuerUserId: model.senderId,
        receiverUserId: model.receiverId,
        data: body,
      );
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
    required CronJobType cronJobType,
  }) async {
    var socket = (await socketManager.socketByUserId(userId))?.webSocket;
    if (socket == null) {
      MsgModel model = MsgModel.fromJson(body);
      await cronJobManager.createJob(
        jobType: cronJobType,
        issuerUserId: model.senderId,
        receiverUserId: model.receiverId,
        data: body,
      );
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
      body: body,
      headers: headers,
      receivedAt: receivedAt,
      sentAtServer: DateTime.now(),
    );
    webSocket.add(dataModel.toString());
  }
}
