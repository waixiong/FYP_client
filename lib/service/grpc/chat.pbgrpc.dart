///
//  Generated code. Do not modify.
//  source: chat.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'chat.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'chat.pb.dart';

class ChatServiceClient extends $grpc.Client {
  static final _$sendMessage = $grpc.ClientMethod<$0.Message, $0.Message>(
      '/serviceproto.ChatService/sendMessage',
      ($0.Message value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Message.fromBuffer(value));
  static final _$updateMessage = $grpc.ClientMethod<$0.Message, $0.Message>(
      '/serviceproto.ChatService/updateMessage',
      ($0.Message value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Message.fromBuffer(value));
  static final _$deleteMessage = $grpc.ClientMethod<$0.Message, $1.Empty>(
      '/serviceproto.ChatService/deleteMessage',
      ($0.Message value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$connect = $grpc.ClientMethod<$0.ReadMessage, $0.Message>(
      '/serviceproto.ChatService/connect',
      ($0.ReadMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Message.fromBuffer(value));

  ChatServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions options,
      $core.Iterable<$grpc.ClientInterceptor> interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Message> sendMessage($0.Message request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$sendMessage, request, options: options);
  }

  $grpc.ResponseFuture<$0.Message> updateMessage($0.Message request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$updateMessage, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> deleteMessage($0.Message request,
      {$grpc.CallOptions options}) {
    return $createUnaryCall(_$deleteMessage, request, options: options);
  }

  $grpc.ResponseStream<$0.Message> connect(
      $async.Stream<$0.ReadMessage> request,
      {$grpc.CallOptions options}) {
    return $createStreamingCall(_$connect, request, options: options);
  }
}

abstract class ChatServiceBase extends $grpc.Service {
  $core.String get $name => 'serviceproto.ChatService';

  ChatServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Message, $0.Message>(
        'sendMessage',
        sendMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Message, $0.Message>(
        'updateMessage',
        updateMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Message, $1.Empty>(
        'deleteMessage',
        deleteMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Message.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ReadMessage, $0.Message>(
        'connect',
        connect,
        true,
        true,
        ($core.List<$core.int> value) => $0.ReadMessage.fromBuffer(value),
        ($0.Message value) => value.writeToBuffer()));
  }

  $async.Future<$0.Message> sendMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Message> request) async {
    return sendMessage(call, await request);
  }

  $async.Future<$0.Message> updateMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Message> request) async {
    return updateMessage(call, await request);
  }

  $async.Future<$1.Empty> deleteMessage_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Message> request) async {
    return deleteMessage(call, await request);
  }

  $async.Future<$0.Message> sendMessage(
      $grpc.ServiceCall call, $0.Message request);
  $async.Future<$0.Message> updateMessage(
      $grpc.ServiceCall call, $0.Message request);
  $async.Future<$1.Empty> deleteMessage(
      $grpc.ServiceCall call, $0.Message request);
  $async.Stream<$0.Message> connect(
      $grpc.ServiceCall call, $async.Stream<$0.ReadMessage> request);
}
