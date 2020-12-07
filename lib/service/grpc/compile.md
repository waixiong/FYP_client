protoc --dart_out=grpc:lib/service/grpc -I protos protos/chat.proto \
    --proto_path=$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
    --proto_path=$GOPATH/src/github.com/grpc-ecosystem/grpc-gateway