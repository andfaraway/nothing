import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:nothing/common/prefix_header.dart'; // 必须导入async库

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Dio _dio = Dio();
  Response<ResponseBody>? _response;
  StreamSubscription? _streamSubscription; // 新增订阅管理
  List<String> messages = [];
  bool _isConnecting = false;

  @override
  void dispose() {
    _streamSubscription?.cancel(); // 正确取消订阅
    super.dispose();
  }

  Future<void> _connectStream() async {
    setState(() => _isConnecting = true);

    try {
      _response = await _dio.get(
        '${Config.baseUrl}/chat',
        options: Options(
          responseType: ResponseType.stream, // 关键设置
          headers: {
            'Accept': 'text/event-stream',
            'Connection': 'keep-alive',
          },
        ),
      );

      // 保存订阅对象
      _streamSubscription = _response?.data?.stream.listen((data) {
        String str = utf8.decode(data);
        print('str = $str');
      });
    } catch (e) {
      print('连接错误: $e');
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temp')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isConnecting ? null : _connectStream,
            child: Text(_isConnecting ? '连接中...' : '开始连接'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(messages[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
