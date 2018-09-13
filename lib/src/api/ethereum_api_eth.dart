/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 12/09/2018
 * Copyright :  S.Hamblett
 *
 * The Ethereum client package
 */

part of ethereum;

/// This class implements the Ethereuum eth API, sometimes referred to as DApp
class EthereumApiEth extends EthereumApi {
  EthereumApiEth(Ethereum client) : super(client);

  //// Client version
  Future<String> clientVersion() async {
    final String method = EthereumRpcMethods.web3ClientVersion;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Returns Keccak-256 (not the standardized SHA3-256) of the given data.
  Future<BigInt> sha3(BigInt data) async {
    if (data == null) {
      throw ArgumentError.notNull("Ethereum::sha3 - data");
    }
    final String method = EthereumRpcMethods.web3Sha3;
    final List params = [EthereumUtilities.bigIntegerToHex(data)];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.safeParse(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Net version
  Future<String> netVersion() async {
    final String method = EthereumRpcMethods.netVersion;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Net listening, true when listening
  Future<bool> netListening() async {
    final String method = EthereumRpcMethods.netListening;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Net peer count,
  Future<int> netPeerCount() async {
    final String method = EthereumRpcMethods.netPeerCount;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Protocol version
  Future<String> protocolVersion() async {
    final String method = EthereumRpcMethods.protocolVersion;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Sync status, an object with data about the sync status if syncing or false if not.
  Future<EthereumSyncStatus> syncStatus() async {
    final String method = EthereumRpcMethods.syncing;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumSyncStatus.fromMap(res);
    }
    _client.processError(method, res);
    return null;
  }

  /// The client coinbase address.
  Future<BigInt> coinbaseAddress() async {
    final String method = EthereumRpcMethods.coinbaseAddress;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.safeParse(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Mining, true when mining
  Future<bool> mining() async {
    final String method = EthereumRpcMethods.mining;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Hashrate, returns the number of hashes per second that the node is mining with.
  Future<int> hashrate() async {
    final String method = EthereumRpcMethods.hashrate;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// The current price per gas in wei.
  Future<int> gasPrice() async {
    final String method = EthereumRpcMethods.gasPrice;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Accounts,  a list of addresses owned by client.
  Future<List<BigInt>> accounts() async {
    final String method = EthereumRpcMethods.accounts;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToBigIntList(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Block number, the number of most recent block.
  Future<int> blockNumber() async {
    final String method = EthereumRpcMethods.blockNumber;
    final res = await _client.rpcClient.request(method);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get balance, the balance of the account of the given address.
  Future<int> getBalance(
      BigInt accountNumber, EthereumDefaultBlock block) async {
    if (accountNumber == null) {
      throw ArgumentError.notNull("Ethereum::getBalance - accountNumber");
    }
    if (block == null) {
      throw ArgumentError.notNull("Ethereum::getBalance - block");
    }
    final String method = EthereumRpcMethods.balance;
    final String blockString = block.getSelection();
    final List params = [
      EthereumUtilities.bigIntegerToHex(accountNumber),
      blockString
    ];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get Storage at, the value from a storage position at a given address.
  /// Parameters are the address of the storage, the integer position of the storage and
  // the default block parameter.
  Future<BigInt> getStorageAt(
      BigInt address, int pos, EthereumDefaultBlock block) async {
    if (address == null) {
      throw ArgumentError.notNull("Ethereum::getStorageAt - address");
    }
    if (pos == null) {
      throw ArgumentError.notNull("Ethereum::getStorageAt - pos");
    }
    if (block == null) {
      throw ArgumentError.notNull("Ethereum::getStorageAt - block");
    }
    final String method = EthereumRpcMethods.storageAt;
    final String blockString = block.getSelection();
    final List params = [
      EthereumUtilities.bigIntegerToHex(address),
      EthereumUtilities.intToHex(pos),
      blockString
    ];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.safeParse(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Transaction count, returns the number of transactions sent from an address.
  Future<int> getTransactionCount(
      BigInt address, EthereumDefaultBlock block) async {
    if (address == null) {
      throw ArgumentError.notNull("Ethereum::getTransactionCount - address");
    }
    if (block == null) {
      throw ArgumentError.notNull("Ethereum::getTransactionCount - block");
    }
    final String method = EthereumRpcMethods.transactionCount;
    final String blockString = block.getSelection();
    final List params = [
      EthereumUtilities.bigIntegerToHex(address),
      blockString
    ];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Block Transaction Count By Hash
  /// The number of transactions in a block from a block matching the given block hash.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getBlockTransactionCountByHash(BigInt blockHash) async {
    if (blockHash == null) {
      throw ArgumentError.notNull(
          "Ethereum::getBlockTransactionCountByHash - blockHash");
    }
    final String method = EthereumRpcMethods.blockTransactionCountByHash;
    final List params = [EthereumUtilities.bigIntegerToHex(blockHash)];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      if (res[ethResultKey] != null) {
        return EthereumUtilities.hexToInt(res[ethResultKey]);
      } else {
        return 0;
      }
    }
    _client.processError(method, res);
    return null;
  }

  /// Block Transaction Count By Number
  /// The number of transactions in a block matching the given block number.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getBlockTransactionCountByNumber(
      EthereumDefaultBlock blockNumber) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Ethereum::getBlockTransactionCountByNumber - blockNumber");
    }
    final String method = EthereumRpcMethods.blockTransactionCountByNumber;
    final String blockString = blockNumber.getSelection();
    final List params = [blockString];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      if (res[ethResultKey] != null) {
        return EthereumUtilities.hexToInt(res[ethResultKey]);
      } else {
        return 0;
      }
    }
    _client.processError(method, res);
    return null;
  }

  /// Block Uncle Count By Hash
  /// The number of uncles in a block from a block matching the given block hash.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getUncleCountByHash(BigInt blockHash) async {
    if (blockHash == null) {
      throw ArgumentError.notNull("Ethereum::getUncleCountByHash - blockHash");
    }
    final String method = EthereumRpcMethods.blockUncleCountByBlockHash;
    final List params = [EthereumUtilities.bigIntegerToHex(blockHash)];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      if (res[ethResultKey] != null) {
        return EthereumUtilities.hexToInt(res[ethResultKey]);
      } else {
        return 0;
      }
    }
    _client.processError(method, res);
    return null;
  }

  /// Block Uncle Count By Number
  /// The number of uncles in a block matching the given block number.
  /// If the method returns null a count of 0 is returned, this is to distinguish between
  /// this and an error.
  Future<int> getUncleCountByNumber(EthereumDefaultBlock blockNumber) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Ethereum::getUncleCountByNumber - blockNumber");
    }
    final String method = EthereumRpcMethods.blockUncleCountByBlockNumber;
    final String blockString = blockNumber.getSelection();
    final List params = [blockString];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      if (res[ethResultKey] != null) {
        return EthereumUtilities.hexToInt(res[ethResultKey]);
      } else {
        return 0;
      }
    }
    _client.processError(method, res);
    return null;
  }

  /// Get code, the code at the given address.
  Future<int> getCode(BigInt address, EthereumDefaultBlock block) async {
    if (address == null) {
      throw ArgumentError.notNull("Ethereum::getCode - address");
    }
    if (block == null) {
      throw ArgumentError.notNull("Ethereum::getCode - block");
    }
    final String method = EthereumRpcMethods.code;
    final String blockString = block.getSelection();
    final List params = [
      EthereumUtilities.bigIntegerToHex(address),
      blockString
    ];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Sign
  /// The sign method calculates an Ethereum specific signature with:
  /// sign(keccak256("\x19Ethereum Signed Message:\n" + len(message) + message))).
  /// Note the address to sign with must be unlocked.
  Future<int> sign(BigInt account, int message) async {
    if (account == null) {
      throw ArgumentError.notNull("Ethereum::sign - account");
    }
    if (message == null) {
      throw ArgumentError.notNull("Ethereum::sign - message");
    }
    final String method = EthereumRpcMethods.sign;
    final List params = [
      EthereumUtilities.bigIntegerToHex(account),
      EthereumUtilities.intToHex(message)
    ];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
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
  Future<int> sendTransaction(BigInt address, BigInt data,
      {BigInt to, int gas = 9000, int gasPrice, int value, int nonce}) async {
    if (address == null) {
      throw ArgumentError.notNull("Ethereum::sendTransaction - address");
    }
    if (data == null) {
      throw ArgumentError.notNull("Ethereum::sendTransaction - data");
    }
    final String method = EthereumRpcMethods.sendTransaction;
    Map<String, String> paramBlock = {
      "from": EthereumUtilities.bigIntegerToHex(address),
      "to": to == null ? null : EthereumUtilities.bigIntegerToHex(to),
      "gas": EthereumUtilities.intToHex(gas),
      "gasPrice":
          gasPrice == null ? null : EthereumUtilities.intToHex(gasPrice),
      "value": value == null ? null : EthereumUtilities.intToHex(value),
      "data": EthereumUtilities.bigIntegerToHex(data),
      "nonce": nonce == null ? null : EthereumUtilities.intToHex(nonce)
    };
    paramBlock = EthereumUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Send raw transaction
  /// Creates new message call transaction or a contract creation for signed transactions.
  /// Takes the signed transaction data.
  /// Returns the transaction hash, or the zero hash if the transaction is not yet available.
  Future<int> sendRawTransaction(BigInt signedTransaction) async {
    if (signedTransaction == null) {
      throw ArgumentError.notNull(
          "Ethereum::sendRawTransaction - signedTransaction");
    }
    final String method = EthereumRpcMethods.sendRawTransaction;
    final dynamic params = [
      EthereumUtilities.bigIntegerToHex(signedTransaction)
    ];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
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
  /// block: default block parameter
  /// Returns the return value of executed contract.
  Future<int> call(BigInt address, EthereumDefaultBlock block,
      {BigInt from, int gas, int gasPrice, int value, BigInt data}) async {
    if (address == null) {
      throw ArgumentError.notNull("Ethereum::call - address");
    }
    if (block == null) {
      throw ArgumentError.notNull("Ethereum::call - block");
    }
    final String method = EthereumRpcMethods.call;
    final String blockString = block.getSelection();
    Map<String, String> paramBlock = {
      "from": from == null ? null : EthereumUtilities.bigIntegerToHex(from),
      "to": EthereumUtilities.bigIntegerToHex(address),
      "gas": gas == null ? null : EthereumUtilities.intToHex(gas),
      "gasPrice":
          gasPrice == null ? null : EthereumUtilities.intToHex(gasPrice),
      "value": value == null ? null : EthereumUtilities.intToHex(value),
      "data": data == null ? null : EthereumUtilities.bigIntegerToHex(data)
    };
    paramBlock = EthereumUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock, blockString];
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
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
  Future<int> estimateGas(
      {BigInt address,
      BigInt from,
      int gas,
      int gasPrice,
      int value,
      BigInt data}) async {
    Map<String, String> paramBlock = {
      "from": from == null ? null : EthereumUtilities.bigIntegerToHex(from),
      "to": address == null ? null : EthereumUtilities.bigIntegerToHex(address),
      "gas": gas == null ? null : EthereumUtilities.intToHex(gas),
      "gasPrice":
          gasPrice == null ? null : EthereumUtilities.intToHex(gasPrice),
      "value": value == null ? null : EthereumUtilities.intToHex(value),
      "data": data == null ? null : EthereumUtilities.bigIntegerToHex(data)
    };
    paramBlock = EthereumUtilities.removeNull(paramBlock);
    final dynamic params = [paramBlock];
    final String method = EthereumRpcMethods.estimateGas;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get block by hash
  /// Returns information about a block by hash
  /// Hash of a block and a boolean, if true it returns the full transaction objects,
  /// if false only the hashes of the transactions, defaults to true.
  /// Returns A block object, or null when no block was found :
  Future<EthereumBlock> getBlockByHash(BigInt blockHash,
      [bool full = true]) async {
    if (blockHash == null) {
      throw ArgumentError.notNull("Ethereum::getBlockByHash - blockHash");
    }
    final dynamic params = [EthereumUtilities.bigIntegerToHex(blockHash), full];
    final String method = EthereumRpcMethods.getBlockByHash;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumBlock.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get block by number
  /// Returns information about a block by block number.
  /// blockNumber - defualt block parameter
  /// as in the default block parameter.
  /// A boolean, if true it returns the full transaction objects,
  /// if false only the hashes of the transactions, defaults to true.
  /// Returns See getBlockByHash
  Future<EthereumBlock> getBlockByNumber(EthereumDefaultBlock blockNumber,
      [bool full = true]) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull("Ethereum::getBlockByNumber - blockNumber");
    }
    final String blockString = blockNumber.getSelection();
    final dynamic params = [blockString, full];
    final String method = EthereumRpcMethods.getBlockByNumber;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumBlock.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get transaction by hash
  /// Returns the information about a transaction requested by transaction hash.
  /// Hash of a transaction
  /// Returns a transaction object, or null when no transaction was found:
  Future<EthereumTransaction> getTransactionByHash(BigInt hash) async {
    if (hash == null) {
      throw ArgumentError.notNull("Ethereum::getTransactionByHash - hash");
    }
    final dynamic params = [EthereumUtilities.bigIntegerToHex(hash)];
    final String method = EthereumRpcMethods.getTransactionByHash;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumTransaction.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get transaction by block hash and index.
  /// Returns information about a transaction by block hash and transaction index position.
  /// Hash of a block and integer of the transaction index position.
  /// Returns see getTransactionByHash.
  Future<EthereumTransaction> getTransactionByBlockHashAndIndex(
      BigInt blockHash, int index) async {
    if (blockHash == null) {
      throw ArgumentError.notNull(
          "Ethereum::getTransactionByBlockHashAndIndex - blockHash");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Ethereum::getTransactionByBlockHashAndIndex - index");
    }
    final dynamic params = [
      EthereumUtilities.bigIntegerToHex(blockHash),
      EthereumUtilities.intToHex(index)
    ];
    final String method = EthereumRpcMethods.getTransactionByBlockHashAndIndex;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumTransaction.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get transaction by block number and index.
  /// Returns information about a transaction by block number and transaction index position.
  /// A block number as in the default block parameter.
  /// Returns see getTransactionByHash.
  Future<EthereumTransaction> getTransactionByBlockNumberAndIndex(
      EthereumDefaultBlock blockNumber, int index) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Ethereum::getTransactionByBlockNumberAndIndex - blockNumber");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Ethereum::getTransactionByBlockNumberAndIndex - index");
    }
    final String blockNumberString = blockNumber.getSelection();
    final dynamic params = [
      blockNumberString,
      EthereumUtilities.intToHex(index)
    ];
    final String method =
        EthereumRpcMethods.getTransactionByBlockNumberAndIndex;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumTransaction.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get transaction receipt
  /// Returns the receipt of a transaction by transaction hash.
  /// Note That the receipt is not available for pending transactions.
  /// Hash of a transaction
  /// Returns a transaction receipt object, or null when no receipt was found:
  Future<EthereumTransactionReceipt> getTransactionReceipt(
      BigInt transactionHash) async {
    if (transactionHash == null) {
      throw ArgumentError.notNull(
          "Ethereum::getTransactionReceipt - transactionHash");
    }
    final dynamic params = [EthereumUtilities.bigIntegerToHex(transactionHash)];
    final String method = EthereumRpcMethods.getTransactionReceipt;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumTransactionReceipt.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get uncle by block hash and index.
  /// Returns information about an uncle by block hash and uncle index position.
  /// Note: An uncle doesn't contain individual transactions.
  /// Hash of a block and integer of the uncle index position.
  /// Returns see getBlockByHash.
  Future<EthereumBlock> getUncleByBlockHashAndIndex(
      BigInt blockHash, int index) async {
    if (blockHash == null) {
      throw ArgumentError.notNull(
          "Ethereum::getUncleByBlockHashAndIndex - blockHash");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Ethereum::getUncleByBlockHashAndIndex - index");
    }
    final dynamic params = [
      EthereumUtilities.bigIntegerToHex(blockHash),
      EthereumUtilities.intToHex(index)
    ];
    final String method = EthereumRpcMethods.getUncleByBlockHashAndIndex;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumBlock.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get uncle by block number and index.
  /// Returns information about an uncle by block number and uncle index position.
  /// Note: An uncle doesn't contain individual transactions.
  /// A block number as in the default block parameter.
  /// Returns see getBlockByHash.
  Future<EthereumBlock> getUncleByBlockNumberAndIndex(
      EthereumDefaultBlock blockNumber, int index) async {
    if (blockNumber == null) {
      throw ArgumentError.notNull(
          "Ethereum::getUncleByBlockNumberAndIndex - blockNumber");
    }
    if (index == null) {
      throw ArgumentError.notNull(
          "Ethereum::getUncleByBlockNumberAndIndex - index");
    }
    final String blockNumberString = blockNumber.getSelection();
    final dynamic params = [
      blockNumberString,
      EthereumUtilities.intToHex(index)
    ];
    final String method = EthereumRpcMethods.getUncleByBlockNumberAndIndex;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumBlock.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// New filter
  /// Creates a filter object, based on filter options, to notify when the state changes (logs).
  /// To check if the state has changed, call getFilterChanges.
  /// note on specifying topic filters:
  /// Topics are order-dependent. A transaction with a log with topics [A, B] will be matched by the following topic filters:
  /// [] "anything"
  /// ['A'] "A in first position (and anything after)"
  /// [null, B] "anything in first position AND B in second position (and anything after)"
  /// [A, B] "A in first position AND B in second position (and anything after)"
  /// [[A, B], [A, B]] "(A OR B) in first position AND (A OR B) in second position (and anything after)"
  /// fromBlock: - (optional, default: "latest") Integer block number, or "latest" for the last mined block or "pending",
  /// "earliest" for not yet mined transactions.
  /// toBlock: - (optional, default: "latest") Integer block number, or "latest" for the last mined block or "pending", "earliest" for not
  /// yet mined transactions.
  /// address: - (optional) Contract address or a list of addresses from which logs should originate.
  /// topics: - (optional) topics. Topics are order-dependent.
  /// Note: the user must build this structure using the utilities in the EthereumUtilities class. See the Ethereum
  /// Wiki RPC page for examples.
  /// Returns a filter id.
  Future<int> newFilter(
      {EthereumDefaultBlock fromBlock,
      EthereumDefaultBlock toBlock,
      dynamic address,
      List<BigInt> topics}) async {
    final String fromBlockString = fromBlock.getSelection();
    final String toBlockString = toBlock.getSelection();
    final Map params = {"toBlock": toBlockString, "fromBlock": fromBlockString};
    if (address != null) {
      if (address is List) {
        final List<String> addresses =
            EthereumUtilities.bigIntegerToHexList(address);
        params["address"] = addresses;
      } else {
        params["address"] = (EthereumUtilities.bigIntegerToHex(address));
      }
    }
    if (topics != null) {
      params["topics"] = EthereumUtilities.bigIntegerToHexList(topics);
    }
    final List paramBlock = [params];
    final String method = EthereumRpcMethods.newFilter;
    final res = await _client.rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// New block filter
  /// Creates a filter in the node, to notify when a new block arrives.
  /// To check if the state has changed, call getFilterChanges.
  /// Returns a filter id.
  Future<int> newBlockFilter() async {
    final List params = [];
    final String method = EthereumRpcMethods.newBlockFilter;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// New pending transaction filter
  /// Creates a filter in the node, to notify when a new pending transaction arrives.
  /// To check if the state has changed, call getFilterChanges.
  /// Returns a filter id.
  Future<int> newPendingTransactionFilter() async {
    final List params = [];
    final String method = EthereumRpcMethods.newPendingTransactionFilter;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumUtilities.hexToInt(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Uninstall filter
  /// Uninstalls a filter with given id. Should always be called when watch is no longer needed.
  /// Additionally Filters timeout when they aren't requested with getFilterChanges for a period of time.
  /// Filter id
  /// Returns true if the filter was successfully uninstalled, otherwise false.
  Future<bool> uninstallFilter(int filterId) async {
    if (filterId == null) {
      throw ArgumentError.notNull("Ethereum::uninstallFilter - filterId");
    }
    final List params = [EthereumUtilities.intToHex(filterId)];
    final String method = EthereumRpcMethods.uninstallFilter;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Get filter changes
  /// Polling method for a filter, which returns an list of logs which occurred since last poll.
  /// Filter Id
  /// Returns an EthereumFilter object or null
  Future<EthereumFilter> getFilterChanges(int filterId) async {
    if (filterId == null) {
      throw ArgumentError.notNull("Ethereum::getFilterChanges - filterId");
    }
    final List params = [EthereumUtilities.intToHex(filterId)];
    final String method = EthereumRpcMethods.getFilterChanges;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumFilter.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get filter logs
  /// Filter Id
  /// Returns see getFilterChanges
  Future<EthereumFilter> getFilterLogs(int filterId) async {
    if (filterId == null) {
      throw ArgumentError.notNull("Ethereum::getFilterLogs - filterId");
    }
    final List params = [EthereumUtilities.intToHex(filterId)];
    final String method = EthereumRpcMethods.getFilterLogs;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumFilter.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get logs
  /// The filter definition, see newFilter parameters.
  /// Returns see getFilterChanges
  Future<EthereumFilter> getLogs(
      {EthereumDefaultBlock fromBlock,
      EthereumDefaultBlock toBlock,
      dynamic address,
      List<BigInt> topics}) async {
    final String fromBlockString = fromBlock.getSelection();
    final String toBlockString = toBlock.getSelection();
    final Map params = {"toBlock": toBlockString, "fromBlock": fromBlockString};
    if (address != null) {
      if (address is List) {
        final List<String> addresses =
            EthereumUtilities.bigIntegerToHexList(address);
        params["address"] = addresses;
      } else {
        params["address"] = (EthereumUtilities.bigIntegerToHex(address));
      }
    }
    if (topics != null) {
      params["topics"] = EthereumUtilities.bigIntegerToHexList(topics);
    }
    final List paramBlock = [params];
    final String method = EthereumRpcMethods.getLogs;
    final res = await _client.rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumFilter.fromMap(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Get work
  /// Returns the hash of the current block, the seedHash, and the boundary condition to be met ("target").
  /// Returns an EthereumWork object or null
  Future<EthereumWork> getWork() async {
    final List paramBlock = [];
    final String method = EthereumRpcMethods.getWork;
    final res = await _client.rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(ethResultKey)) {
      return EthereumWork.fromList(res[ethResultKey]);
    }
    _client.processError(method, res);
    return null;
  }

  /// Submit work
  /// Used for submitting a proof-of-work solution.
  /// The nonce found
  /// The header's pow-hash
  /// The mix digest
  /// Returns  true if the provided solution is valid, otherwise false.
  Future<bool> submitWork(BigInt nonce, BigInt powHash, BigInt digest) async {
    if (nonce == null) {
      throw ArgumentError.notNull("Ethereum::submitWork - nonce");
    }
    if (powHash == null) {
      throw ArgumentError.notNull("Ethereum::submitWork - powHash");
    }
    if (digest == null) {
      throw ArgumentError.notNull("Ethereum::submitWork - digest");
    }
    final List params = [
      EthereumUtilities.bigIntegerToHex(nonce),
      EthereumUtilities.bigIntegerToHex(powHash),
      EthereumUtilities.bigIntegerToHex(digest)
    ];
    final String method = EthereumRpcMethods.submitWork;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// Submit hash rate
  /// Used for submitting mining hashrate.
  /// Hash rate
  /// Id, a random hexadecimal(32 bytes) string identifying the client
  /// Returns true if submitting went through successfully and false otherwise.
  Future<bool> submitHashrate(BigInt hashRate, String id) async {
    if (hashRate == null) {
      throw ArgumentError.notNull("Ethereum::submitHashRate - hashRate");
    }
    if (id == null) {
      throw ArgumentError.notNull("Ethereum::submitHashRate - id");
    }
    final List params = [EthereumUtilities.bigIntegerToHex(hashRate), id];
    final String method = EthereumRpcMethods.submitHashrate;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// SHH version
  /// Returns the current whisper protocol version.
  Future<String> shhVersion() async {
    final List params = [];
    final String method = EthereumRpcMethods.shhVersion;
    final res = await _client.rpcClient.request(method, params);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }

  /// SHH post
  /// Sends a whisper message
  /// from: - (optional) The identity of the sender.
  /// to: - (optional) The identity of the receiver. When present whisper will encrypt the message so that only
  ///  the receiver can decrypt it.
  /// topics: - List of topics, for the receiver to identify messages.
  /// payload: - The payload of the message.
  /// priority: - The integer of the priority in a range from ... (?).
  /// ttl: - integer of the time to live in seconds.
  /// Returns true if the message was send, otherwise false.
  Future<bool> shhPost(
      List<BigInt> topics, BigInt payload, int priority, int ttl,
      {BigInt to, BigInt from}) async {
    if (topics == null) {
      throw ArgumentError.notNull("Ethereum::shhPost - topics");
    }
    if (payload == null) {
      throw ArgumentError.notNull("Ethereum::shhPost - payload");
    }
    if (priority == null) {
      throw ArgumentError.notNull("Ethereum::shhPost - priority");
    }
    if (ttl == null) {
      throw ArgumentError.notNull("Ethereum::shhPost - ttl");
    }
    Map<String, dynamic> params = {
      "topics": EthereumUtilities.bigIntegerToHexList(topics),
      "payload": EthereumUtilities.bigIntegerToHex(payload),
      "priority": EthereumUtilities.intToHex(priority),
      "ttl": ttl,
      "to": EthereumUtilities.bigIntegerToHex(to),
      "from": EthereumUtilities.bigIntegerToHex(from)
    };
    params = EthereumUtilities.removeNull(params);
    final List paramBlock = [params];
    final String method = EthereumRpcMethods.shhPost;
    final res = await _client.rpcClient.request(method, paramBlock);
    if (res != null && res.containsKey(ethResultKey)) {
      return res[ethResultKey];
    }
    _client.processError(method, res);
    return null;
  }
}