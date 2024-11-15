import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final WebSocketChannel channel;

  WebSocketService(this.channel);

  static WebSocketService connect(String url) {
    try {
      print('Connecting to WebSocket: $url');
      final channel = WebSocketChannel.connect(Uri.parse(url));
      print('Connected to WebSocket');
      return WebSocketService(channel);
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      rethrow;
    }
  }

  Stream<Map<String, dynamic>> getCandlestickStream(String symbol, String interval) {
    final Map<String, dynamic> request = {
      'method': 'SUBSCRIBE',
      'params': ["$symbol@kline_$interval"],
      'id': 1
    };

    print('Subscribing to candlestick data for $symbol with interval $interval');
    channel.sink.add(json.encode(request));

    return channel.stream.map((data) {
      print('Received candlestick data: $data');
      return json.decode(data);
    });
  }

  Stream<Map<String, dynamic>> getOrderbookStream(String symbol) {
    final Map<String, dynamic> request = {
      'method': 'SUBSCRIBE',
      'params': ["$symbol@depth5@100ms"],
      'id': 1
    };

    print('Subscribing to orderbook data for $symbol');
    channel.sink.add(json.encode(request));

    return channel.stream.map((data) {
      print('Received orderbook data: $data');
      return json.decode(data);
    });
  }

  void close() {
    print('Closing WebSocket connection');
    channel.sink.close();
  }
}
