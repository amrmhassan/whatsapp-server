import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/constants/endpoints.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/msg_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class MsgDatasource {
  Future<void> sendMsg(MsgModel msgModel) async {
    manageSocketsData.sendToClientByUserID(
      msgModel.receiverId,
      body: msgModel.toJson(),
      method: SocketMethod.post,
      path: Endpoints.msg,
      receivedAt: DateTime.now(),
    );
  }
}