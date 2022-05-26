
import 'dart:convert';

OrderResult OrderResultFromJson(String str) => OrderResult.fromJson(json.decode(str));

class OrderResult {
  String result;
  String messages;
  String redirect;

  OrderResult({
    required this.result,
    required this.messages,
    required this.redirect,
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) => new OrderResult(
    result: json["result"] == null ? '' : json["result"],
    messages: json["messages"] == null ? '' : json["messages"],
    redirect: json["redirect"] == null ? '' : json["redirect"],
  );

}