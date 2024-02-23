import 'dart:io';

import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';
import 'package:whatsapp_server/features/sockets/data/datasources/send_timeout_class.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/user_data_sending_id.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/runtime_variables.dart';

class ManageSocketsData {
  // this is just used by the server to send and receive the user id then the client will be managed by his id
  Future<bool?> sendToClientBySessionId(
    String sessionId, {
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
    bool handshake = false,
  }) async {
    var socket = (await socketManager.socketBySessionId(sessionId))?.webSocket;
    if (socket == null) {
      throw Exception('This sessions id doesn\'t exist ');
    } else {
      return _sendToClient(
        handshake: handshake,
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

  Future<bool?> sendToClientByUserID(
    /// this is the receiver  user id which will receive the data from the server
    String userId, {
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
    required CronJobType cronJobType,
    required String senderUserId,
    bool handshake = false,
  }) async {
    var socket = (await socketManager.socketByUserId(userId))?.webSocket;
    if (socket == null) {
      //! this can't be correct, because the cron job data won't be a message model every time
      await cronJobManager.createJob(
        jobType: cronJobType,
        issuerUserId: senderUserId,
        receiverUserId: userId,
        data: body,
      );
      return false;
    } else {
      return _sendToClient(
        handshake: true,
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

  Future<bool?> _sendToClient({
    required WebSocket webSocket,
    required String path,
    required SocketMethod method,
    required dynamic body,
    Map<String, dynamic>? headers,
    DateTime? receivedAt,
    required UserDataSendingId sendingId,

    /// this will make sure that no infante loops of connections with client occurs
    /// if false then the server will send the data to the client and waits for a response that the data is correct
    /// if true the server will send the data without waiting
    required bool handshake,
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
    SendTimeoutClass dataModelSender = SendTimeoutClass();
    if (handshake) {
      webSocket.add(dataModel.toString());
      return null;
    } else {
      return dataModelSender.sendToClient(
        webSocket,
        dataModel,
        sendingId,
      );
    }
    //? here add the sending status response
  }
}
