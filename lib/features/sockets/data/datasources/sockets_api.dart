import 'package:whatsapp_server/features/socket_api/domain/repositories/api.dart';
import 'package:whatsapp_server/features/sockets/data/datasources/socket_datasource.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/constants/endpoints.dart';

class SocketsApi implements ApiMask {
  final SocketsDatasource _datasource = SocketsDatasource();
  @override
  Future<void> addApis() async {
    routerInfo.post(Endpoints.userId, _datasource.setUserId);
  }
}
