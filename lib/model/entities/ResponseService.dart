class ResponseService {

  final String _response;
  final bool _status;

  const ResponseService(this._status, this._response);

  String getResponse() => _response;
  bool getStatus() => _status;

}