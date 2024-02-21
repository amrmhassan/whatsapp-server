import 'package:whatsapp_server/features/message/data/datasources/msg_api.dart';
import 'package:whatsapp_server/features/socket_api/domain/repositories/api.dart';
import 'package:whatsapp_server/features/socket_server/data/datasources/server_socket.dart';
import 'package:whatsapp_server/features/sockets/data/datasources/sockets_api.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';

// dart run build_runner build --delete-conflicting-outputs

late ServerSocket serverSocket;
void main(List<String> arguments) async {
  api = Api(routerInfo);
  api.addApis(MsgApi());
  api.addApis(SocketsApi());

  serverSocket = ServerSocket(port: 3000);
}
