import 'package:flutter/material.dart';
import 'package:sindcelma_app/model/Request.dart';

import '../model/entities/User.dart';
import 'CameraFile.dart';

class AddDocumentsComponent extends StatefulWidget {

  final Function(bool status) onResponse;
  final bool activity;
  const AddDocumentsComponent({required this.onResponse, this.activity = true, Key? key}) : super(key: key);

  @override
  State<AddDocumentsComponent> createState() => _AddDocumentsComponentState();
}

class _AddDocumentsComponentState extends State<AddDocumentsComponent> {

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
        activity: widget.activity,
        onRespose: (status, refresh){
          if(status){
            setState(() {
              comp = CameraFile(
                  activity: widget.activity,
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
    return comp;
  }
}
