import 'package:whatsapp_server/features/socket_server/data/datasources/server_socket.dart';

// dart run build_runner build --delete-conflicting-outputs

late ServerSocket serverSocket;
void main(List<String> arguments) async {
  serverSocket = ServerSocket(port: 3000);
}
