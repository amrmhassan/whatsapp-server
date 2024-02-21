// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:whatsapp_server/features/cron_job/data/models/cron_job_type.dart';

class CronJobModel {
  final String id;
  final CronJobType jobType;
  final String issuerUserId;
  final String receiverUserId;
  final Map<String, dynamic> data;
  final DateTime issuedAt;

  CronJobModel({
    required this.id,
    required this.jobType,
    required this.issuerUserId,
    required this.receiverUserId,
    required this.data,
    required this.issuedAt,
  });
}
