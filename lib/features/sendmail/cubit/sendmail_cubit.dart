import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mail_sender/features/authentication/services/secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

part 'sendmail_state.dart';

class SendMailCubit extends Cubit<SendMailState> {
  int sentCount = 0;
  bool stopToSend = false;

  final List<String> sentList = [];
  final List<String> failedList = [];

  SendMailCubit() : super(SendMailInitial());

  Future sendEmailToList(List<String> emailList,
      {usingPersonalMail = false,
      String subject = '',
      String body = '',
      String senderEmail = '',
      String port = '',
      String host = '',
      String password = '',
      String timer = '',
      required List<Attachment> emailAttachments}) async {
    emit(SendingMail(sentCount: sentCount));
    final String emailSubject = subject;
    final String emailBody = body;

    SmtpServer smtpServer;

    if (usingPersonalMail) {
      smtpServer = gmail(senderEmail, password);
    } else {
      smtpServer = SmtpServer(host,
          port: int.parse(port), ssl: true, allowInsecure: true);
    }

    for (var i = 0; i < emailList.length; i++) {
      final message = Message()
        ..from = Address(senderEmail)
        ..recipients = [emailList[i]]
        ..subject = emailSubject
        ..text = emailBody
        ..attachments = emailAttachments;

      try {
        final SendReport sendMail = await send(message, smtpServer);
        print('mail sent to:::: ${emailList[i]}');
        sentCount++;
        sentList.add(emailList[i]);

        if (state is SendingMail) {
          SendingMail success = state as SendingMail;
          emit(success.copyWith(sentCount: sentCount, update: !success.update));
        } else {
          emit(SendingMail(sentCount: sentCount));
        }
      } on SocketException {
        print('SocketException');
        break;
      } on SmtpClientAuthenticationException catch (e) {
        print('SmtpClientAuthenticationException');
        break;
      } on MailerException catch (e) {
        failedList.add(emailList[i]);
        print('Failed ::::: ${e.message}');
        emit(SendEmailFailure(error: 'Failed to send mail to ${emailList[i]}'));
      } catch (e) {
        print('default exception');
        break;
      }
      await Future.delayed(Duration(minutes: int.parse(timer)));
    }
    if (sentCount == 0) {
      emit(SmtpClientFailure(error: ''));
    } else {
      emit(SendEmailSuccess(sentList: sentList, failedList: failedList));
    }
  }
}
