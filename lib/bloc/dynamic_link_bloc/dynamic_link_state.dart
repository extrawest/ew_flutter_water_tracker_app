import 'package:equatable/equatable.dart';

class DynamicLinkState extends Equatable {
  final String? linkParameter;

  const DynamicLinkState({this.linkParameter});

  DynamicLinkState copyWith(
      {String? linkParameter}) {
    return DynamicLinkState(
        linkParameter: linkParameter);
  }

  @override
  List<Object?> get props => [linkParameter];
}
