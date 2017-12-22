/*
 * Packge : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 22/12/2017
 * Copyright :  S.Hamblett
 *
 * Provides a common interface for Ethereum to connect over websockets in
 * the browser.
 */

part of ethereum_browser_ws_client;

class EthereumBrowserWSAdapter implements EthereumINetworkAdapter {
  Future<JsonObjectLite> httpRequest(Uri uri, JsonObjectLite request) {
    final completer = new Completer();
    final WebSocket webSocket = new WebSocket(uri.toString());
    final String message = request.toString();
    webSocket.onOpen.listen((Event e) {
      webSocket.sendString(message);
    });
    webSocket.onError.listen((Event e) {
      print(
          'EthereumBrowserWSAdapter::WebSocket error, message not sent, state is ${webSocket
              .readyState.toString()}');
      webSocket.close();
      return completer.complete(null);
    });
    webSocket.onMessage.listen((MessageEvent e) {
      final String ret = e.data;
      webSocket.close();
      completer.complete(new JsonObjectLite.fromJsonString(ret));
    });
    return completer.future;
  }
}