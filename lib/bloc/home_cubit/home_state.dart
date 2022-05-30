part of 'home_cubit.dart';

enum HomeTab { drinks, progress }

class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.drinks});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
