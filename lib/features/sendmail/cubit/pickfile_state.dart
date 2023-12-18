part of 'pickfile_cubit.dart';

abstract class PickFileState {
  const PickFileState();
}

class FilePickInitial extends PickFileState {}

class FilePickSuccess extends PickFileState {
  final List<String> emailList;
    final String fileName;

  FilePickSuccess({required this.emailList, required this.fileName});
}

class FilePickError extends PickFileState {
  final String error;
  FilePickError({required this.error});
}

class PickAttechmentSuccess extends PickFileState {
  List<Attachment>? fileList;
  bool update;
  PickAttechmentSuccess({this.fileList, this.update = false});
  PickAttechmentSuccess copyWith({
    List<Attachment>? fileList,
    bool? update,
  }) =>
      PickAttechmentSuccess(
       fileList :  fileList ?? this.fileList,
      );
}

class PickAttechmentFailure extends PickFileState {
  final String error;
  PickAttechmentFailure({required this.error});
}
