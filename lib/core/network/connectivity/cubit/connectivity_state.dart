part of 'connectivity_cubit.dart';

sealed class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityLoading extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {
  final ConnectionType connectionType;

  const ConnectivityConnected({required this.connectionType});
}

class ConnectivityDisconnected extends ConnectivityState {}
