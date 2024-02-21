import 'package:whatsapp_server/features/cron_job/data/models/cron_job_model.dart';
import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/runtime_variables.dart';

List<CronJobModel> _cronJobs = [];

class CronJobManager {
  Future<CronJobModel> createJob({
    required CronJobType jobType,
    required String issuerUserId,
    required String receiverUserId,
    required Map<String, dynamic> data,
  }) async {
    String id = dartId.generate();
    CronJobModel cronJobModel = CronJobModel(
      id: id,
      jobType: jobType,
      issuerUserId: issuerUserId,
      receiverUserId: receiverUserId,
      data: data,
      issuedAt: DateTime.now(),
    );
    _cronJobs.add(cronJobModel);
    return cronJobModel;
  }

  Future<void> deleteJob(String id) async {
    _cronJobs.removeWhere((element) => element.id == id);
  }

  Future<List<CronJobModel>> getUserDelayedJobs(String receiverUserId) async {
    return _cronJobs
        .where((element) => element.receiverUserId == receiverUserId)
        .toList();
  }

  Future<void> deleteUserDelayedJobs(String receiverUserId) async {
    _cronJobs
        .removeWhere((element) => element.receiverUserId == receiverUserId);
  }
}
