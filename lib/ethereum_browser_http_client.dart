/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 06/011/2017
 * Copyright :  S.Hamblett
 *
 * An instance of Ethereum specialised for use in the browser.
 */

library ethereum_browser_client;

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:ethereum/ethereum.dart';

part 'src/adapters/ethereum_browser_http_adapter.dart';

/// The browser HTTP client
class EthereumBrowserHTTPClient extends Ethereum {
  /// Construction
  EthereumBrowserHTTPClient() : super(browserHttpAdapter);

  /// With connection parameters
  EthereumBrowserHTTPClient.withConnectionParameters(String hostname,
      [int port])
      : super.withConnectionParameters(
            browserHttpAdapter, hostname, Ethereum.rpcHttpScheme, port);

  /// The adapter
  static EthereumBrowserHTTPAdapter browserHttpAdapter =
      EthereumBrowserHTTPAdapter();
}
