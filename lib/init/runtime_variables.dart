import 'package:whatsapp_server/features/socket_api/domain/repositories/api.dart';
import 'package:whatsapp_server/features/socket_api/domain/repositories/router_info.dart';
import 'package:whatsapp_server/features/sockets/data/datasources/manage_sockets_data.dart';
import 'package:whatsapp_server/features/sockets/data/datasources/socket_manager.dart';

final SocketManager socketManager = SocketManager();
final ManageSocketsData manageSocketsData = ManageSocketsData();

RouterInfo routerInfo = RouterInfo();
late Api api;
