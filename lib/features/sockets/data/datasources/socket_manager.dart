import 'dart:io';

import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_model.dart';

class SocketManager {
  final List<SocketModel> _sockets = [];

  Future<SocketModel> addNewSocket({
    required WebSocket webSocket,
    String? userId,
  }) async {
    SocketModel socketModel = SocketModel(
      webSocket: webSocket,
      userId: userId,
    );
    _sockets.add(socketModel);
    return socketModel;
  }

  Future<void> updateUserId(String sessionId, String userId) async {
    int index =
        _sockets.indexWhere((element) => element.sessionId == sessionId);
    if (index == -1) return;
    var model = _sockets[index].copyWith(userId: userId);
    _sockets[index] = model;
  }

  Future<List<SocketModel>> getAllSockets() async {
    return [..._sockets];
  }

  Future<void> removeSocket(String sessionId) async {
    _sockets.removeWhere((element) => element.sessionId == sessionId);
  }

  Future<SocketModel?> socketBySessionId(String sessionId) async {
    try {
      return _sockets.firstWhere((element) => element.sessionId == sessionId);
    } catch (e) {
      return null;
    }
  }

  Future<SocketModel?> socketByUserId(String userId) async {
    try {
      return _sockets.firstWhere((element) => element.userId == userId);
    } catch (e) {
      return null;
    }
  }

  Future<int> socketsLength() async {
    return _sockets.length;
  }
}
