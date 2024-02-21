import 'package:whatsapp_server/features/message/data/datasources/msg_datasource.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/msg_model.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class MsgHandler {
  final MsgDatasource _datasource = MsgDatasource();

  Future<void> handleSendMessage(SocketDataModel dataModel) async {
    MsgModel model = MsgModel.fromJson(dataModel.body);
    _datasource.sendMsg(model);
  }
}
