import 'package:tweetly/main.dart';

class SessionManager {
  final MyApp appContext;
  Session? _currentSession;

  /* constructor */ SessionManager.of(this.appContext);

  Session? getSession() {
    return _currentSession;
  }

  void setSession(Session session) {
    _currentSession = session;
  }
}

class Session {
  String uid;
  String token;

  Session({required this.uid, required this.token});
}
