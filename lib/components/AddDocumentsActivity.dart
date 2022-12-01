import 'package:flutter/material.dart';
import 'package:sindcelma_app/components/camera/SendingImageLoading.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../model/entities/User.dart';
import 'CameraFile.dart';


class AddDocumentsActivity extends StatefulWidget {

  final Function(bool status) onResponse;

  const AddDocumentsActivity(this.onResponse, {Key? key}) : super(key: key);

  @override
  State<AddDocumentsActivity> createState() => _AddDocumentsActivityState();
}

class _AddDocumentsActivityState extends State<AddDocumentsActivity> {

  Widget comp = Container();

  checkStatus() async {
    var request = Request();
    await request.post('/user/socios/check_status', {});
    if(request.code() == 200){
      User().socio.status = 2;
      widget.onResponse(true);
    }
  }

  @override
  void initState() {
    super.initState();
    comp = CameraFile(
        onRespose: (status, refresh){
          if(status){
            setState(() {
              comp = CameraFile(
                  onRespose: (status, refresh){
                    if(status){
                      checkStatus();
                    }
                  },
                  type: ImageType.selfieComDoc
              );
            });
          }
        },
        type: ImageType.selfieSemDoc
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: comp,
    );
  }
}
