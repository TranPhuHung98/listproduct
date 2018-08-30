
class AppState{
  AppState(this.isLoading);
  final bool isLoading;
  bool get isLogged => isLoading == true ;
}