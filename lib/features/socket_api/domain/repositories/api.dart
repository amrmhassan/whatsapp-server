import 'package:whatsapp_server/features/socket_api/domain/repositories/router_info.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class Api {
  final RouterInfo routerInfo;
  const Api(this.routerInfo);

  void handleSocketRequest(SocketDataModel dataModel) async {
    var match = routerInfo.getMatch(dataModel.path, dataModel.method);
    if (match == null) {
      print('No thing');
      return;
    }
    try {
      await match.handler(dataModel);
    } catch (e) {
      print(e);
    }
  }
}
