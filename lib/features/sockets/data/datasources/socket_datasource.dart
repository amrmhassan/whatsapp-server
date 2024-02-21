import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class SocketsDatasource {
  void setUserId(SocketDataModel dataModel) {
    String userId = dataModel.body['userId'];
    String sessionId = dataModel.body['sessionId'];
    socketManager.updateUserId(sessionId, userId);
    print('Setting user id $userId to $sessionId');
  }
}
