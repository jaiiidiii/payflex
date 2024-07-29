import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/utils/enums.dart';

part 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity connectivity;
  StreamSubscription? connectivityStreamSubscription;

  ConnectivityCubit({required this.connectivity})
      : super(ConnectivityLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<List<ConnectivityResult>> monitorInternetConnection() {
    return connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult
          .any((element) => element == ConnectivityResult.wifi)) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResult
          .any((element) => element == ConnectivityResult.mobile)) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (connectivityResult
          .any((element) => element == ConnectivityResult.none)) {
        emitInternetDisconnected();
      }
    });
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(ConnectivityConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(ConnectivityDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription?.cancel();
    return super.close();
  }
}
