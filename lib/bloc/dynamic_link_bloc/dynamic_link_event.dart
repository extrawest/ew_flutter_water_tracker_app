import 'package:equatable/equatable.dart';

abstract class DynamicLinkEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class GetDynamicLink extends DynamicLinkEvent {}

class CreateLink extends DynamicLinkEvent {}

class RequestSubscription extends DynamicLinkEvent {}

class DropLink extends DynamicLinkEvent {}

class ShareDynamicLink extends DynamicLinkEvent {
  final int sumOfMilliliters;

  ShareDynamicLink(this.sumOfMilliliters);
}