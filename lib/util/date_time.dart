import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateTimeFormat {
  static String formatDateTime(Timestamp timestamp) {
    return DateFormat('HH:mm, EEEE, d MMMM').format(timestamp.toDate());
  }
}
