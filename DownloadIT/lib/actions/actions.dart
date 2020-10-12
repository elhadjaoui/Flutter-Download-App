import 'package:flutter/material.dart';

class UpdateStatusAction {
  final String status;


  UpdateStatusAction(this.status);

  @override
  String toString() {
    return 'UpdateStatusAction{status: $status}';
  }
}

class StartDownloadAction {
  final String url;
  final BuildContext context;

  StartDownloadAction(this.url, this.context);

  @override
  String toString() {
    return 'StartDownloadAction';
  }
}

class StopDownloadAction {
  @override
  String toString() {
    return 'StopDownloadAction';
  }
}

class OpenDialogAction {
  final String title;
  final String body;
  final BuildContext context;

  OpenDialogAction({
    @required this.title,
    @required this.body,
    @required this.context,
  });

  @override
  String toString() {
    return 'OpenDialogAction{title: $title, body: $body}';
  }
}
