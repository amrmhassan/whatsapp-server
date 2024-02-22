import 'package:whatsapp_server/features/cron_job/data/datasources/cron_job_executer.dart';
import 'package:whatsapp_server/init/runtime_variables.dart';
import 'package:whatsapp_shared_code/whatsapp_shared_code/models/socket_data_model.dart';

class SocketsDatasource {
  final CronJobExecuter _jobExecuter = CronJobExecuter();
  Future<void> setUserId(SocketDataModel dataModel) async {
    String userId = dataModel.body['userId'];
    String sessionId = dataModel.body['sessionId'];
    await socketManager.updateUserId(sessionId, userId);
    print('Setting user id $userId to $sessionId');
    await _jobExecuter.handleUserCronJobs(userId);
  }
}
