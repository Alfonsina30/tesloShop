import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/provider/auth/auth_provider.dart';

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read( authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

//--- use Change notifier by notify that was changed this class property _authStatus
//-- and this class is conect with refreshListenable on AppRoute because it need the type Listenable
//-- and ChangeNotifier implement Listenable class flutter

class GoRouterNotifier extends ChangeNotifier {

  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier(this._authNotifier) {
    //--take the current state AuthNotifier and change the property value
  _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }


  AuthStatus get authStatus => _authStatus;

  set authStatus( AuthStatus value ) {
    _authStatus = value;
    notifyListeners();
  }

}