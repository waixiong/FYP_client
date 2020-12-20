import 'dart:async';
import 'package:fixnum/fixnum.dart';

import 'package:grpc/grpc.dart';
import 'package:imageChat/service/db.dart';
import 'package:imageChat/service/grpc/chat.pbgrpc.dart' as chatpb;

import '../util/validator.dart';
import 'package:logger/logger.dart';
import '_exception.dart';
import 'package:imageChat/model/user.dart';
import 'package:imageChat/model/message.dart';
import './auth_service.dart';
import './_hive.dart';

import 'package:dash_chat/dash_chat.dart';
import 'package:hive/hive.dart';

import '../util/network_config.dart';
import '../logger.dart';
import '../locator.dart';

class ChatService {
  Logger log = getLogger("ChatService");
  // final String service;
  final String host;
  final int port;
  chatpb.ChatServiceClient _client;
  String _accessToken;
  // CallOptions _callOptions;

  ResponseStream<chatpb.Message> _responseStream;
  StreamController<chatpb.ReadMessage> _requestStream;
  StreamSubscription _requestStreamSub;

  set accessToken(String token) {
    _accessToken = token;
    _HeaderInterceptor._token = _accessToken;
  }

  ChatService({this.host = '0.0.0.0', this.port = 8100}) {
    ClientChannel _channel = ClientChannel(
      host, 
      port: port,
      options: ChannelOptions(
        credentials: ChannelCredentials.secure(
          onBadCertificate: (certificate, host) {
            log.e(host);
            return true;
          },
        ),
      )
    );
    // _callOptions = CallOptions(
    //   metadata: {
    //     // 'User': locator<AuthService>().user.id,
    //     'Authorization': _accessToken
    //   }
    // );
    _client = chatpb.ChatServiceClient(
      _channel, 
      options: CallOptions(
        metadata: {
          // 'User': locator<AuthService>().user.id,
          'Authorization': _accessToken
        }
      ),
      interceptors: [_HeaderInterceptor()]
    );
  }

  void connect() {
    log.i('connect to gRPC Service');
    log.d('host: $host:$port');
    if(_requestStream != null && !_requestStream.isClosed) _requestStream.close();
    if(_responseStream != null) _responseStream.cancel();
    if(_requestStreamSub != null && !_requestStreamSub.isPaused) _requestStreamSub.cancel();
    _requestStream = StreamController<chatpb.ReadMessage>();
    _responseStream = _client.connect(_requestStream.stream);
    _requestStreamSub = _responseStream.listen(_onIncomingMessage, onError: (err){
      log.e('[connect] $err');
    });
  }

  Future<void> _onIncomingMessage(chatpb.Message message) async {
    log.i('[_onIncomingMessage] '+message.text);
    if(message.senderId == message.receiverId) {
      await Future.delayed(Duration(milliseconds: 300));
    }
    locator<DB>().addMessage(Message.fromProto(message));
      log.i('added');
    _requestStream.add(chatpb.ReadMessage()..id = message.id);
    // print(_requestStream.hasListener);
  }

  Future<void> sendMessage(ChatMessage message, String receiverId) async {
    chatpb.Message m = chatpb.Message();
    m.text = message.text?? '';
    m.receiverId = receiverId;
    m.img = message.image?? '';
    m.attachment = message.customProperties != null? message.customProperties['attachment']?? '' : '';
    m.senderId = message.user.uid?? '';
    m.timestamp = Int64(message.createdAt.millisecondsSinceEpoch);
    log.i('sending');
    m = await _client.sendMessage(m);
    locator<DB>().addMessage(Message.fromProto(m));
    log.i('done');
  }

  void receiveMessage(Message message) {
    _requestStream.add(chatpb.ReadMessage()..id = message.id);
  }

  dispose() {
    if(_requestStream != null && !_requestStream.isClosed) _requestStream.close();
    if(_responseStream != null) _responseStream.cancel();
    if(_requestStreamSub != null) _requestStreamSub.cancel();
  }
}

class _HeaderInterceptor implements ClientInterceptor {

  static String _token = '';

  @override
  ResponseStream<R> interceptStreaming<Q, R>(ClientMethod<Q, R> method, Stream<Q> requests, CallOptions options, invoker) {
    // options.metadata['Authorization'] = _token;
    options = options.mergedWith(CallOptions(
      metadata: {
        'Authorization': _token
      }
    ));
    print(options.metadata);
    return invoker(method, requests, options);
  }
  
  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request, CallOptions options, invoker) {
    // options.metadata['Authorization'] = _token;
    options = options.mergedWith(CallOptions(
      metadata: {
        'Authorization': _token
      }
    ));
    print(options.metadata);
    return invoker(method, request, options);
  }
}