import 'dart:async';

import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class RouterInfo {
  final List<RouterEntity> _entities = [];

  List<RouterEntity> get entities {
    return [..._entities];
  }

  RouterEntity? getMatch(String path, SocketMethod method) {
    return _entities.cast().firstWhere(
          (element) => element.path == path && element.method == method,
          orElse: () => null,
        );
  }

  void addEntity(RouterEntity entity) {
    bool exist = _entities.any((element) =>
        element.path == entity.path || element.method == entity.method);
    if (exist) {
      throw Exception('This entity already exists');
    }
    _entities.add(entity);
  }

  void addEntities(List<RouterEntity> entities) {
    for (var entity in entities) {
      addEntity(entity);
    }
  }

  RouterInfo get(
    String path,
    FutureOr<void> Function(SocketDataModel dataModel) handler,
  ) {
    RouterEntity entity = RouterEntity(path, SocketMethod.get, handler);
    addEntity(entity);
    return this;
  }

  RouterInfo post(
    String path,
    FutureOr<void> Function(SocketDataModel dataModel) handler,
  ) {
    RouterEntity entity = RouterEntity(path, SocketMethod.post, handler);
    addEntity(entity);
    return this;
  }

  RouterInfo put(
    String path,
    FutureOr<void> Function(SocketDataModel dataModel) handler,
  ) {
    RouterEntity entity = RouterEntity(path, SocketMethod.put, handler);
    addEntity(entity);
    return this;
  }

  RouterInfo patch(
    String path,
    FutureOr<void> Function(SocketDataModel dataModel) handler,
  ) {
    RouterEntity entity = RouterEntity(path, SocketMethod.patch, handler);
    addEntity(entity);
    return this;
  }

  RouterInfo delete(
    String path,
    FutureOr<void> Function(SocketDataModel dataModel) handler,
  ) {
    RouterEntity entity = RouterEntity(path, SocketMethod.delete, handler);
    addEntity(entity);
    return this;
  }
}

class RouterEntity {
  final String path;
  final SocketMethod method;
  final FutureOr<void> Function(SocketDataModel dataModel) handler;

  const RouterEntity(
    this.path,
    this.method,
    this.handler,
  );
}
