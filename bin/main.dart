import 'package:whatsapp_server/features/socket_api/domain/repositories/api.dart';
import 'package:whatsapp_server/features/socket_server/data/datasources/server_socket.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';

// dart run build_runner build --delete-conflicting-outputs

late ServerSocket serverSocket;
void main(List<String> arguments) async {
  api = Api(routerInfo);
  serverSocket = ServerSocket(port: 3000);
}
