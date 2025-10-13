// ignore_for_file: avoid_print

import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../config/app_config.dart';

Future<MqttClient> mqttConnect() async {
  MqttServerClient client = MqttServerClient.withPort(
    AppConfig.mqttHost,
    "flutter",
    AppConfig.mqttPort,
    maxConnectionAttempts: 1,
  );

  client
    ..logging(on: false)
    ..setProtocolV311()
    ..keepAlivePeriod = 60
    ..onConnected = onConnected
    ..onDisconnected = onDisconnected
    ..onUnsubscribed = onUnsubscribed
    ..onSubscribed = onSubscribed
    ..onSubscribeFail = onSubscribeFail
    ..pongCallback = pong
    ..secure = true
    ..securityContext = SecurityContext.defaultContext;

  final connMess = MqttConnectMessage()
      .authenticateAs(
        AppConfig.mqttUsername,
        AppConfig.mqttPassword,
      )
      .withClientIdentifier('flutter')
      .withWillTopic('test')
      .withWillMessage('My Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMess;

  try {
    print('Connecting');
    await client.connect();
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }
  print("connected");

  client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
    final recMessage = c![0].payload as MqttPublishMessage;
    final payload = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

    print('Received message:$payload from topic: ${c[0].topic}');
  });

  if (client.connectionStatus?.state == MqttConnectionState.connected) {
    print('MQTT Connected');
    client.subscribe("test", MqttQos.atLeastOnce);
  } else {
    print('MQTT Connection failed - status: ${client.connectionStatus}');
    client.disconnect();
    return client;
  }

  return client;
}

// Connected callback
void onConnected() {
  print('Connected');
}

// Disconnected callback
void onDisconnected() {
  print('Disconnected');
}

// Subscribed callback
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}

// Subscribed failed callback
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}

// Unsubscribed callback
void onUnsubscribed(String? topic) {
  print('Unsubscribed topic: $topic');
}

// Ping callback
void pong() {
  print('Ping response client callback invoked');
}
