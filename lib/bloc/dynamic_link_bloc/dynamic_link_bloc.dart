import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:water_tracker/bloc/dynamic_link_bloc/dynamic_link_barrel.dart';
import 'package:water_tracker/services/firebase/dynamic_links_service.dart';

class DynamicLinkBloc extends Bloc<DynamicLinkEvent, DynamicLinkState> {
  final DynamicLinksService dynamicLinksService;

  DynamicLinkBloc(this.dynamicLinksService) : super(const DynamicLinkState()) {
    on<GetDynamicLink>(_onGetDynamicLink);
    on<RequestSubscription>(_onSubscriptionRequested);
    on<DropLink>(_onDropLink);
    on<ShareDynamicLink>(_onShareDynamicLink);
  }

  Future<void> _onGetDynamicLink(
      GetDynamicLink event, Emitter<DynamicLinkState> emit) async {
    final linkData =
        await dynamicLinksService.dynamicLinkInstance.getInitialLink();

    if (linkData != null) {
      final linkParameter = _fetchParameter(linkData);
      emit(state.copyWith(linkParameter: linkParameter));
    }
  }

  Future<void> _onSubscriptionRequested(
      RequestSubscription event, Emitter<DynamicLinkState> emit) async {
    await emit.forEach(dynamicLinksService.dynamicLinkInstance.onLink,
        onData: (PendingDynamicLinkData linkData) {
      final linkParameter = _fetchParameter(linkData);
      return state.copyWith(linkParameter: linkParameter);
    });
  }

  void _onDropLink(DropLink event, Emitter<DynamicLinkState> emit) {
    emit(state.copyWith(linkParameter: null));
  }

  Future<void> _onShareDynamicLink(
      ShareDynamicLink event, Emitter<DynamicLinkState> emit) async {
    final link = await dynamicLinksService.createDynamicLink(event.sumOfMilliliters.toString());
    await Share.share(link.toString());
  }

  String? _fetchParameter(PendingDynamicLinkData linkData) {
    return linkData.link.queryParameters['sumofmilliliters'];
  }
}
