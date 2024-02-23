import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';
import 'package:whatsapp_server/features/cron_job/data/repositories/msg_cron_job.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';

class CronJobExecuter {
  Future<void> handleUserCronJobs(String userId) async {
    var userJobs = await cronJobManager.getUserDelayedJobs(userId);
    for (var cronJob in userJobs) {
      bool? sent = false;
      if (cronJob.jobType == CronJobType.message) {
        sent = await MsgCronJob().handle(cronJob);
      }
      // this should be at the end of each loop cycle
      //! i won't add a cron jobs if the sent is null
      if (sent == true || sent == null) {
        await cronJobManager.deleteJob(cronJob.id);
      }
    }
  }
}
