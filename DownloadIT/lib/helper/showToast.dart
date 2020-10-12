import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class showToast
{
  FToast fToast;

  init(BuildContext context)
  {
    fToast = FToast(context);
  }
show(String msg)
{
  fToast.showToast(
    child: Text(msg),
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 1),
  );
}

}