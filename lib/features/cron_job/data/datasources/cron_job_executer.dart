import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';
import 'package:whatsapp_server/features/message/data/datasources/msg_datasource.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/msg_model.dart';

class CronJobExecuter {
  Future<void> handleUserCronJobs(String userId) async {
    var userJobs = await cronJobManager.getUserDelayedJobs(userId);
    for (var cronJob in userJobs) {
      if (cronJob.jobType == CronJobType.message) {
        MsgDatasource msgDatasource = MsgDatasource();
        MsgModel msgModel = MsgModel.fromJson(cronJob.data);
        await msgDatasource.sendMsg(msgModel);
        await cronJobManager.deleteJob(cronJob.id);
      }
    }
  }
}
