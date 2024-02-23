// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/constants/endpoints.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/user_data_sending_id.dart';

class CustomServerSocket {
  final InternetAddress _myIp = InternetAddress.anyIPv4;
  final int port;
  late Stream<WebSocket> websocketServer;
  final StreamController<SocketDataModel> _streamController =
      StreamController<SocketDataModel>.broadcast();

  CustomServerSocket({
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
    print('ws server listening at $link');

    await for (var socket in websocketServer) {
      final model = await socketManager.addNewSocket(webSocket: socket);
      String sessionId = model.sessionId;
      manageSocketsData.sendToClientBySessionId(
        sessionId,
        path: Endpoints.myInfo,
        body: sessionId,
        method: SocketMethod.post,
      );

      socket.listen(
        (event) async {
          SocketDataModel? dataModel = SocketDataModel.fromString(event);
          if (dataModel == null) return;
          api.handleSocketRequest(dataModel);
          _streamController.add(dataModel);
        },
        onDone: () async {
          await socketManager.removeSocket(sessionId);
          int socketsLength = await socketManager.socketsLength();

          print('Remaining devices $socketsLength');
        },
      );
    }
  }

  Stream<SocketDataModel> addListener({
    required String path,
    required SocketMethod method,
    required UserDataSendingId? userDataSendingId,
  }) {
    Stream<SocketDataModel> stream = _streamController.stream;
    return stream.where((event) {
      bool request = event.path == path && event.method == method;
      bool user = false;
      if (userDataSendingId == null) {
        user = true;
      } else if (userDataSendingId.type == event.userDataSendingId.type &&
          userDataSendingId.id == event.userDataSendingId.id) {
        user = true;
      }
      return request && user;
    });
  }
}
