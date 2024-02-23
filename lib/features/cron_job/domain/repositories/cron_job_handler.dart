import 'package:whatsapp_server/features/cron_job/data/models/cron_job_model.dart';

abstract class CronJobHandler {
  Future<bool> handle(CronJobModel cronJob);
}
