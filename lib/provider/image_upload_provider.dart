import 'package:do_an_chuyen_nganh/enum/view_state.dart';
import 'package:flutter/cupertino.dart';

class ImageUploadProvider with ChangeNotifier {

  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewState => _viewState;

  void setToLoading() {
    _viewState = ViewState.LOADING;
    notifyListeners();
  }

  void setToIdle() {
    _viewState = ViewState.IDLE;
    notifyListeners();
  }

}