/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 06/011/2017
 * Copyright :  S.Hamblett
 *
 * The Ethereum client package
 */

part of ethereum;

/// The Ethereum JSON-RPC client class.
/// Further details of this interface and its API specification can be found at
/// https://github.com/ethereum/wiki/wiki/JSON-RPC#web3_clientversion.
/// The API calls return null if an ethereum error occurred.
class Ethereum {
  Ethereum(this._httpAdapter) {
    rpcClient = new EthereumRpcClient(_httpAdapter);
  }

  Ethereum.withConnectionParameters(EthereumIHTTPAdapter adapter,
      String hostname,
      [port = defaultPort])
      : _httpAdapter = adapter {
    rpcClient = new EthereumRpcClient(_httpAdapter);
    connectParameters(hostname, port);
  }

  /// Constants
  static const String rpcScheme = 'http';

  /// Defaults
  static const int defaultPort = 8545;

  /// Connection parameters
  int port = defaultPort;
  String host;
  Uri _uri;

  Uri get uri => _uri;

  /// HTTP Adapter
  EthereumIHTTPAdapter _httpAdapter;

  set httpAdapter(EthereumIHTTPAdapter adapter) => _httpAdapter = adapter;

  /// Json RPC client
  EthereumRpcClient rpcClient;

  /// Last error
  EthereumError lastError = new EthereumError();

  /// Connection methods

  //// Connect using a host string of the form http://thehost.com:1234,
  /// port is optional. Scheme must be http
  void connectString(String hostname) {
    if (hostname == null) {
      throw new ArgumentError.notNull("Ethereum::connectString - hostname");
    }
    final Uri uri = Uri.parse(hostname);
    _validateUri(uri);
  }

  /// Connect using a URI, port is optional
  void connectUri(Uri uri) {
    if (uri == null) {
      throw new ArgumentError.notNull("Ethereum::connectUri - uri");
    }
    _validateUri(uri);
  }

  /// Connect by explicitly setting the connection parameters
  void connectParameters(String hostname, [int port]) {
    if (hostname == null) {
      throw new ArgumentError.notNull("Ethereum::connectParameters - hostname");
    }
    int uriPort = defaultPort;
    if (port != null) {
      uriPort = port;
    }
    final Uri uri = new Uri(scheme: rpcScheme, host: hostname, port: uriPort);
    _validateUri(uri);
  }

  void _validateUri(Uri puri) {
    // Must have a valid scheme which must be http, host and port
    if (puri.hasAuthority && (puri.host.isNotEmpty)) {
      host = puri.host;
    } else {
      throw new ArgumentError.value(
          puri.host, "Ethereum::_validateUri - invalid host");
    }
    Uri newUri = puri.replace(scheme: rpcScheme);
    if (!puri.hasPort) {
      newUri = newUri.replace(port: defaultPort);
    }
    port = newUri.port;
    _uri = newUri;
    rpcClient.uri = _uri;
  }

  /// Print errors, default is off
  bool printError = false;

  /// Error processing helper
  void _processError(String method, JsonObjectLite res) {
    lastError.updateError(res.error.code, res.error.message, rpcClient.id);
    if (printError) {
      print("ERROR::$method - ${lastError.toString()}");
    }
  }

  /// API constants
  static const String ethEarliest = "earliest";
  static const String ethLatest = "latest";
  static const String ethPending = "pending";
  static const String ethResultKey = "result";

  /// API methods

  //// Client version
  Future<String> clientVersion() async {
    final String method = EthereumRpcMethods.web3ClientVersion;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return res.result;
    }
    _processError(method, res);
    return null;
  }

  /// Returns Keccak-256 (not the standardized SHA3-256) of the given data.
  Future<int> sha3(int data) async {
    if (data == null) {
      throw new ArgumentError.notNull("Ethereum::sha3 - data");
    }
    final String method = EthereumRpcMethods.web3Sha3;
    final List params = [EthereumUtilities.intToHex(data)];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Net version
  Future<String> netVersion() async {
    final String method = EthereumRpcMethods.netVersion;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return res.result;
    }
    _processError(method, res);
    return null;
  }

  /// Net listening, true when listening
  Future<bool> netListening() async {
    final String method = EthereumRpcMethods.netListening;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return res.result;
    }
    _processError(method, res);
    return null;
  }

  /// Net peer count,
  Future<int> netPeerCount() async {
    final String method = EthereumRpcMethods.netPeerCount;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Protocol version
  Future<String> protocolVersion() async {
    final String method = EthereumRpcMethods.protocolVersion;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return res.result;
    }
    _processError(method, res);
    return null;
  }

  /// Sync status, an object with data about the sync status if syncing or false if not.
  /// Encoded as a JsonObject with a syncStatus, if true the sync status data is valid.
  Future<JsonObjectLite> syncStatus() async {
    final String method = EthereumRpcMethods.syncing;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      final JsonObjectLite resp = new JsonObjectLite();
      resp.syncStatus = false;
      if (!(res.result is bool) && (res.result.containsKey('startingBlock'))) {
        resp.syncStatus = true;
        resp.startingBlock =
            EthereumUtilities.hexToInt(res.result.startingBlock);
        resp.currentBlock = EthereumUtilities.hexToInt(res.result.currentBlock);
        resp.highestBlock = EthereumUtilities.hexToInt(res.result.highestBlock);
      }
      return resp;
    }
    _processError(method, res);
    return null;
  }

  /// The client coinbase address.
  Future<int> coinbaseAddress() async {
    final String method = EthereumRpcMethods.coinbaseAddress;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Mining, true when mining
  Future<bool> mining() async {
    final String method = EthereumRpcMethods.mining;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return res.result;
    }
    _processError(method, res);
    return null;
  }

  /// Hashrate, returns the number of hashes per second that the node is mining with.
  Future<int> hashrate() async {
    final String method = EthereumRpcMethods.hashrate;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// The current price per gas in wei.
  Future<int> gasPrice() async {
    final String method = EthereumRpcMethods.gasPrice;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Accounts,  a list of addresses owned by client.
  Future<List<int>> accounts() async {
    final String method = EthereumRpcMethods.accounts;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToIntList(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Block number, the number of most recent block.
  Future<int> blockNumber() async {
    final String method = EthereumRpcMethods.blockNumber;
    final res = await rpcClient.request(method);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Get balance, the balance of the account of the given address.
  /// The block can be an integer block number or the one of the strings
  /// "latest", "earliest" or "pending.
  Future<int> getBalance(int accountNumber, dynamic block) async {
    if (accountNumber == null) {
      throw new ArgumentError.notNull("Ethereum::getBalance - accountNumber");
    }
    if (block == null) {
      throw new ArgumentError.notNull("Ethereum::getBalance - block");
    }
    final String method = EthereumRpcMethods.balance;
    String blockString;
    if (block is int) {
      blockString = EthereumUtilities.intToHex(block);
    } else {
      blockString = block;
    }
    final List params = [
      EthereumUtilities.intToHex(accountNumber),
      blockString
    ];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Get Storage at, the value from a storage position at a given address.
  /// Parameters are the address of the storage, the integer position of the storage and
  /// the block number, or the string "latest", "earliest" or "pending.
  Future<int> getStorageAt(int address, int pos, dynamic block) async {
    if (address == null) {
      throw new ArgumentError.notNull("Ethereum::getStorageAt - address");
    }
    if (pos == null) {
      throw new ArgumentError.notNull("Ethereum::getStorageAt - pos");
    }
    if (block == null) {
      throw new ArgumentError.notNull("Ethereum::getStorageAt - block");
    }
    final String method = EthereumRpcMethods.storageAt;
    String blockString;
    if (block is int) {
      blockString = EthereumUtilities.intToHex(block);
    } else {
      blockString = block;
    }
    final List params = [
      EthereumUtilities.intToHex(address),
      EthereumUtilities.intToHex(pos),
      blockString
    ];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Transaction count, returns the number of transactions sent from an address.
  /// The block can be an integer block number or the one of the strings
  /// "latest", "earliest" or "pending.
  Future<int> getTransactionCount(int address, dynamic block) async {
    if (address == null) {
      throw new ArgumentError.notNull(
          "Ethereum::getTransactionCount - address");
    }
    if (block == null) {
      throw new ArgumentError.notNull("Ethereum::getTransactionCount - block");
    }
    final String method = EthereumRpcMethods.transactionCount;
    String blockString;
    if (block is int) {
      blockString = EthereumUtilities.intToHex(block);
    } else {
      blockString = block;
    }
    final List params = [EthereumUtilities.intToHex(address), blockString];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Block Transaction Count By Hash
  /// The number of transactions in a block from a block matching the given block hash.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getBlockTransactionCountByHash(int blockHash) async {
    if (blockHash == null) {
      throw new ArgumentError.notNull(
          "Ethereum::getBlockTransactionCountByHash - blockHash");
    }
    final String method = EthereumRpcMethods.blockTransactionCountByHash;
    final List params = [EthereumUtilities.intToHex(blockHash)];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      if (res.result != null) {
        return EthereumUtilities.hexToInt(res.result);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Block Transaction Count By Number
  /// The number of transactions in a block matching the given block number.
  /// The block can be an integer block number or the one of the strings
  /// "latest", "earliest" or "pending.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getBlockTransactionCountByNumber(dynamic blockNumber) async {
    if (blockNumber == null) {
      throw new ArgumentError.notNull(
          "Ethereum::getBlockTransactionCountByNumber - blockNumber");
    }
    final String method = EthereumRpcMethods.blockTransactionCountByNumber;
    String blockString;
    if (blockNumber is int) {
      blockString = EthereumUtilities.intToHex(blockNumber);
    } else {
      blockString = blockNumber;
    }
    final List params = [blockString];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      if (res.result != null) {
        return EthereumUtilities.hexToInt(res.result);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Block Uncle Count By Hash
  /// The number of uncles in a block from a block matching the given block hash.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getUncleCountByHash(int blockHash) async {
    if (blockHash == null) {
      throw new ArgumentError.notNull(
          "Ethereum::getUncleCountByHash - blockHash");
    }
    final String method = EthereumRpcMethods.blockUncleCountByBlockHash;
    final List params = [EthereumUtilities.intToHex(blockHash)];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      if (res.result != null) {
        return EthereumUtilities.hexToInt(res.result);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Block Uncle Count By Number
  /// The number of uncles in a block matching the given block number.
  /// The block number can be an integer block number or the one of the strings
  /// "latest", "earliest" or "pending.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getUncleCountByNumber(dynamic blockNumber) async {
    if (blockNumber == null) {
      throw new ArgumentError.notNull(
          "Ethereum::getUncleCountByNumber - blockNumber");
    }
    final String method = EthereumRpcMethods.blockUncleCountByBlockNumber;
    String blockString;
    if (blockNumber is int) {
      blockString = EthereumUtilities.intToHex(blockNumber);
    } else {
      blockString = blockNumber;
    }
    final List params = [blockString];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      if (res.result != null) {
        return EthereumUtilities.hexToInt(res.result);
      } else {
        return 0;
      }
    }
    _processError(method, res);
    return null;
  }

  /// Get code, the code at the given address.
  /// The block can be an integer block number or the one of the strings
  /// "latest", "earliest" or "pending.
  Future<int> getCode(int address, dynamic block) async {
    if (address == null) {
      throw new ArgumentError.notNull("Ethereum::getCode - address");
    }
    if (block == null) {
      throw new ArgumentError.notNull("Ethereum::getCode - block");
    }
    final String method = EthereumRpcMethods.code;
    String blockString;
    if (block is int) {
      blockString = EthereumUtilities.intToHex(block);
    } else {
      blockString = block;
    }
    final List params = [EthereumUtilities.intToHex(address), blockString];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Sign
  /// The sign method calculates an Ethereum specific signature with:
  /// sign(keccak256("\x19Ethereum Signed Message:\n" + len(message) + message))).
  /// Note the address to sign with must be unlocked.
  Future<int> sign(int account, int message) async {
    if (account == null) {
      throw new ArgumentError.notNull("Ethereum::sign - account");
    }
    if (message == null) {
      throw new ArgumentError.notNull("Ethereum::sign - message");
    }
    final String method = EthereumRpcMethods.sign;
    final List params = [
      EthereumUtilities.intToHex(account),
      EthereumUtilities.intToHex(message)
    ];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Send transaction
  /// Creates new message call transaction or a contract creation, if the data field contains code.
  /// address: The address the transaction is sent from.
  /// to: (optional when creating new contract) The address the transaction is directed to.
  /// gas: (optional, default: 90000) Integer of the gas provided for the transaction execution. It will return unused gas.
  /// gasPrice: (optional, default: To-Be-Determined) Integer of the gasPrice used for each paid gas
  /// value: (optional) Integer of the value send with this transaction
  /// data: The compiled code of a contract OR the hash of the invoked method signature and encoded parameters. For details see Ethereum Contract ABI
  /// nonce: optional) Integer of a nonce. This allows to overwrite your own pending transactions that use the same nonce.
  /// Returns the transaction hash, or the zero hash if the transaction is not yet available.
  Future<int> sendTransaction(int address, int data,
      {int to, int gas: 9000, int gasPrice, int value, int nonce}) async {
    if (address == null) {
      throw new ArgumentError.notNull("Ethereum::sendTransaction - address");
    }
    if (data == null) {
      throw new ArgumentError.notNull("Ethereum::sendTransaction - data");
    }
    final String method = EthereumRpcMethods.sendTransaction;
    Map<String, String> paramBlock = {
      "from": EthereumUtilities.intToHex(address),
      "to": to == null ? null : EthereumUtilities.intToHex(to),
      "gas": EthereumUtilities.intToHex(gas),
      "gasPrice":
      gasPrice == null ? null : EthereumUtilities.intToHex(gasPrice),
      "value": value == null ? null : EthereumUtilities.intToHex(value),
      "data": EthereumUtilities.intToHex(data),
      "nonce": nonce == null ? null : EthereumUtilities.intToHex(nonce)
    };
    paramBlock = EthereumUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Send raw transaction
  /// Creates new message call transaction or a contract creation for signed transactions.
  /// Takes the signed transaction data.
  /// Returns the transaction hash, or the zero hash if the transaction is not yet available.
  Future<int> sendRawTransaction(int signedTransaction) async {
    if (signedTransaction == null) {
      throw new ArgumentError.notNull(
          "Ethereum::sendRawTransaction - signedTransaction");
    }
    final String method = EthereumRpcMethods.sendRawTransaction;
    final dynamic params = [EthereumUtilities.intToHex(signedTransaction)];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Call
  /// Executes a new message call immediately without creating a transaction on the block chain.
  /// address: The address the transaction is sent to.
  /// from: (optional) The address the transaction is sent from.
  /// gas: (optional) Integer of the gas provided for the transaction execution. eth_call consumes zero gas,
  /// but this parameter may be needed by some executions.
  /// gasPrice: (optional) Integer of the gasPrice used for each paid gas
  /// value: (optional) Integer of the value send with this transaction
  /// data: (optional) Hash of the method signature and encoded parameters. For details see Ethereum Contract ABI
  /// block: integer block number, or the string "latest", "earliest" or "pending"
  /// Returns the return value of executed contract.
  Future<int> call(int address, dynamic block,
      {int from, int gas, int gasPrice, int value, int data}) async {
    if (address == null) {
      throw new ArgumentError.notNull("Ethereum::call - address");
    }
    if (block == null) {
      throw new ArgumentError.notNull("Ethereum::call - block");
    }
    final String method = EthereumRpcMethods.call;
    String blockString;
    if (block is int) {
      blockString = EthereumUtilities.intToHex(block);
    } else {
      blockString = block;
    }
    Map<String, String> paramBlock = {
      "from": from == null ? null : EthereumUtilities.intToHex(from),
      "to": EthereumUtilities.intToHex(address),
      "gas": gas == null ? null : EthereumUtilities.intToHex(gas),
      "gasPrice":
      gasPrice == null ? null : EthereumUtilities.intToHex(gasPrice),
      "value": value == null ? null : EthereumUtilities.intToHex(value),
      "data": data == null ? null : EthereumUtilities.intToHex(data)
    };
    paramBlock = EthereumUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock, blockString];
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }

  /// Estimate gas
  /// Makes a call or transaction, which won't be added to the blockchain and returns the used gas,
  /// which can be used for estimating the used gas.
  /// See eth_call parameters, expect that all properties are optional. If no gas limit is specified geth
  /// uses the block gas limit from the pending block as an upper bound. As a result the returned estimate
  /// might not be enough to executed the call/transaction when the amount of gas is higher than the
  /// pending block gas limit.
  /// Returns the amount of gas used.
  Future<int> estimateGas({int address,
    int from,
    int gas,
    int gasPrice,
    int value,
    int data}) async {
    Map<String, String> paramBlock = {
      "from": from == null ? null : EthereumUtilities.intToHex(from),
      "to": address == null ? null : EthereumUtilities.intToHex(address),
      "gas": gas == null ? null : EthereumUtilities.intToHex(gas),
      "gasPrice":
      gasPrice == null ? null : EthereumUtilities.intToHex(gasPrice),
      "value": value == null ? null : EthereumUtilities.intToHex(value),
      "data": data == null ? null : EthereumUtilities.intToHex(data)
    };
    paramBlock = EthereumUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock];
    final String method = EthereumRpcMethods.estimateGas;
    final res = await rpcClient.request(method, params);
    if (res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res.result);
    }
    _processError(method, res);
    return null;
  }
}
