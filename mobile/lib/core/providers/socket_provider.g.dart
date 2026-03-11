// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(socket)
const socketProvider = SocketProvider._();

final class SocketProvider
    extends $FunctionalProvider<io.Socket, io.Socket, io.Socket>
    with $Provider<io.Socket> {
  const SocketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketHash();

  @$internal
  @override
  $ProviderElement<io.Socket> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  io.Socket create(Ref ref) {
    return socket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(io.Socket value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<io.Socket>(value),
    );
  }
}

String _$socketHash() => r'87c1a03415e2d5b390486bb3371d773a29c5a5d2';
