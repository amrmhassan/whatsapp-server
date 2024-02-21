// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/constants/endpoints.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/runtime_variables.dart';

class ServerSocket {
  final InternetAddress _myIp = InternetAddress.anyIPv4;
  final int port;
  late Stream<WebSocket> websocketServer;

  ServerSocket({
    this.port = 0,
  }) {
    _transform();
  }
  Completer<HttpServer> connLinkCompleter = Completer<HttpServer>();

  Future<HttpServer> getWsServer() async {
    return connLinkCompleter.future;
  }

  Future<String> getConnLink() async {
    var server = await getWsServer();
    int port = server.port;
    String ip = _myIp.address;
    return 'ws://$ip:$port';
  }

  Future<void> _transform() async {
    var server = await HttpServer.bind(_myIp, port);
    websocketServer = server.transform(WebSocketTransformer());

    connLinkCompleter.complete(server);
    String link = await getConnLink();
    logger.i('ws server listening at $link');

    await for (var socket in websocketServer) {
      final model = await socketManager.addNewSocket(webSocket: socket);
      String sessionId = model.sessionId;
      logger.i('Device Connected With session id : ${model.sessionId}');
      manageSocketsData.sendToClientBySessionId(
        sessionId,
        path: Endpoints.myInfo,
        body: sessionId,
        method: SocketMethod.post,
      );

      socket.listen(
        (event) async {
          logger.e(event.toString());
        },
        onDone: () async {
          logger.w('Device $sessionId disconnected');
          await socketManager.removeSocket(sessionId);
          int socketsLength = await socketManager.socketsLength();

          logger.i('Remaining devices $socketsLength');
        },
      );
    }
  }
}
