import 'package:whatsapp_server/features/cron_job/data/models/cron_job_model.dart';
import 'package:whatsapp_server/features/cron_job/domain/repositories/cron_job_handler.dart';
import 'package:whatsapp_server/features/message/data/datasources/msg_datasource.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/msg_model.dart';

class MsgCronJob implements CronJobHandler {
  @override
  Future<bool> handle(CronJobModel cronJob) async {
    MsgDatasource msgDatasource = MsgDatasource();
    MsgModel msgModel = MsgModel.fromJson(cronJob.data);
    return msgDatasource.sendMsg(msgModel);
  }
}
