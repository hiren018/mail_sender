part of 'sendmail_cubit.dart';

abstract class SendMailState {
  const SendMailState();
}

class SendMailInitial extends SendMailState {}

class SendEmailFailure extends SendMailState {
  final String error;
  SendEmailFailure({required this.error});
}
class SmtpClientFailure extends SendMailState {
  final String error;
  SmtpClientFailure({required this.error});
}

class SendingMail extends SendMailState {
  int sentCount;
  bool update;
  SendingMail({this.sentCount = 0, this.update = false});
  SendingMail copyWith({
    int? sentCount,
    bool? update,
  }) =>
      SendingMail(
        sentCount: sentCount ?? this.sentCount,
      );
}

class SendEmailSuccess extends SendMailState {
  final List<String> sentList;
  final List<String> failedList;
  SendEmailSuccess({required this.sentList, required this.failedList});
}


