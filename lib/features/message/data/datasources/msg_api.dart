import 'package:whatsapp_server/features/message/data/datasources/msg_handler.dart';
import 'package:whatsapp_server/features/socket_api/domain/repositories/api.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/constants/endpoints.dart';

class MsgApi implements ApiMask {
  final MsgHandler _handler = MsgHandler();

  @override
  Future<void> addApis() async {
    routerInfo.get(Endpoints.msg, _handler.handleSendMessage);
  }
}
