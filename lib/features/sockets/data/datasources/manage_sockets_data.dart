import 'dart:io';

import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';
import 'package:whatsapp_server/features/sockets/data/datasources/socket_data_model_sender.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/msg_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/user_data_sending_id.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/runtime_variables.dart';

class ManageSocketsData {
  // this is just used by the server to send and receive the user id then the client will be managed by his id
  Future<bool> sendToClientBySessionId(
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
      return false;
    } else {
      return _sendToClient(
        webSocket: socket,
        path: path,
        method: method,
        body: body,
        headers: headers,
        receivedAt: receivedAt,
        sendingId: UserDataSendingId(
          id: sessionId,
          type: SendingIdType.sessionId,
        ),
      );
    }
  }

  Future<bool> sendToClientByUserID(
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
      return false;
    } else {
      return _sendToClient(
        webSocket: socket,
        path: path,
        method: method,
        body: body,
        headers: headers,
        receivedAt: receivedAt,
        sendingId: UserDataSendingId(
          id: userId,
          type: SendingIdType.sessionId,
        ),
      );
    }
  }

  Future<bool> _sendToClient({
    required WebSocket webSocket,
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
    required UserDataSendingId sendingId,
  }) async {
    String requestId = dartId.generate();
    SocketDataModel dataModel = SocketDataModel(
      path: path,
      method: method,
      body: body,
      headers: headers,
      receivedAt: receivedAt,
      sentAtServer: DateTime.now(),
      userDataSendingId: sendingId,
      id: requestId,
    );
    SocketDataModelSender dataModelSender = SocketDataModelSender();
    return dataModelSender.sendToClient(
      webSocket,
      dataModel,
      sendingId,
    );
    //? here add the sending status response
  }
}
