import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'pickfile_state.dart';

class PickFileCubit extends Cubit<PickFileState> {
  int sentCount = 0;
  bool _sendStart = false;

  PickFileCubit() : super(FilePickInitial());

  Future pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    List<String> rowDetail = [];

    String filePath = result?.files.first.path ?? '';

    if (result == null ||
        filePath == "" ||
        filePath.split('.').last != 'xlsx') {
      emit(FilePickError(error: 'Please Select excel file!'));
    }

    var bytes = File.fromUri(Uri(path: filePath)).readAsBytesSync();
    var excel = SpreadsheetDecoder.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        for (var i = 0; i < row.length; i++) {
          if (row[i].toString().contains('@gmail.com')) {
            rowDetail.add(row[i]);
          }
        }
      }
    }
    emit(FilePickSuccess(
        emailList: rowDetail, fileName: result!.files.first.name));
  }

  void removeAttechment(List<Attachment> attachements, String fileName) {
    List<Attachment> newListAttachments = List.from(
        attachements.where((element) => element.fileName != fileName));

    if (state is PickAttechmentSuccess) {
      var success = state as PickAttechmentSuccess;

      emit(success.copyWith(
          fileList: newListAttachments, update: !success.update));
    } else {
      emit(PickAttechmentSuccess(fileList: newListAttachments));
    }
  }

  Future pickAttechment() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      List<Attachment> files = [];
      for (var i = 0; i < result!.files.length; i++) {
        files.add(FileAttachment(File(result.files[i].path!),
            fileName: result.files[i].name));
      }

      if (state is PickAttechmentSuccess) {
        var success = state as PickAttechmentSuccess;
        List<Attachment> successFile = success.fileList ?? [];
        for (var file in files) {
          if (!(success.fileList!
              .every((element) => element.fileName == file.fileName))) {
            success.fileList!.add(file);
          }
        }
        emit(success.copyWith(fileList: successFile, update: !success.update));
      } else {
        emit(PickAttechmentSuccess(fileList: files));
      }
    } catch (e) {
      emit(PickAttechmentFailure(error: 'Failed to Pick attechment'));
    }
  }
}
