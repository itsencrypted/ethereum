/*
 * Package : Ethereum
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 08/01/2017
 * Copyright :  S.Hamblett
 *
 * A JSON RPC 2.0 client for Ethereum
 */

part of ethereum;

/// An ethereum block descriptor message
class EthereumBlock {
  EthereumBlock();

  EthereumBlock.fromMap(Map result) {
    construct(result);
  }

  /// The block number. Null when its a pending block.
  int _number;

  int get number => _number;

  /// Hash of the block. Null when its a pending block.
  BigInt _hash;

  BigInt get hash => _hash;

  /// Parent hash. Hash of the parent block.
  BigInt _parentHash;

  BigInt get parentHash => _parentHash;

  /// nonce. Hash of the generated proof-of-work. Null when its pending block.
  BigInt _nonce;

  BigInt get nonce => _nonce;

  /// Sha3 Uncles. SHA3 of the uncles data in the block.
  BigInt _sha3Uncles;

  BigInt get sha3Uncles => _sha3Uncles;

  /// Logs bloom. The bloom filter for the logs of the block. Null when its pending block.
  BigInt _logsBloom;

  BigInt get logsBloom => _logsBloom;

  /// Transactions root. The root of the transaction tree of the block.
  BigInt _transactionsRoot;

  BigInt get transactionsRoot => _transactionsRoot;

  /// State root. The root of the final state tree of the block.
  BigInt _stateRoot;

  BigInt get stateRoot => _stateRoot;

  /// Receipts root. The root of the receipts tree of the block.
  BigInt _receiptsRoot;

  BigInt get receiptsRoot => _receiptsRoot;

  /// Miner. The address of the beneficiary to whom the mining rewards were given.
  BigInt _miner;

  BigInt get miner => _miner;

  /// Difficulty. Integer of the difficulty for this block.
  int _difficulty;

  int get difficulty => _difficulty;

  /// Total difficulty. Integer of the total difficulty of the chain until this block.
  int _totalDifficulty;

  int get totalDifficulty => _totalDifficulty;

  /// Extra data. The "extra data" field of this block.
  BigInt _extraData;

  BigInt get extraData => _extraData;

  /// Size. Integer the size of this block in bytes.
  int _size;

  int get size => _size;

  /// Gas limit. The maximum gas allowed in this block.
  int _gasLimit;

  int get gasLimit => _gasLimit;

  /// Gas used. The total used gas by all transactions in this block.
  int _gasUsed;

  int get gasUsed => _gasUsed;

  /// Timestamp. The unix timestamp for when the block was collated.
  DateTime _timestamp;

  DateTime get timestamp => _timestamp;

  /// Transactions. A list of transaction objects, or 32 Bytes transaction hashes
  /// depending on the last given parameter.
  List<dynamic> _transactions;

  List<dynamic> get transactions => _transactions;

  /// Indicates if the transactions are hashes or transaction objects
  bool _transactionsAreHashes = false;

  bool get transactionsAreHashes => _transactionsAreHashes;

  /// Uncles. A list of uncle hashes.
  List<BigInt> _uncles;

  List<BigInt> get uncles => _uncles;

  /// Construct from the supplied Map, only check for the keys we need.
  void construct(Map data) {
    if ((data == null) || (data[EthereumConstants.ethResultKey] == null)) {
      return;
    }
    if (data[EthereumConstants.ethResultKey].containsKey('number')) {
      _number = EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['number']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('hash')) {
      _hash = EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['hash']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('parentHash')) {
      _parentHash =
          EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['parentHash']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('nonce')) {
      _nonce = EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['nonce']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('sha3Uncles')) {
      _sha3Uncles =
          EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['sha3Uncles']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('logsBloom')) {
      _logsBloom = EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['logsBloom']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('transactionsRoot')) {
      _transactionsRoot =
          EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['transactionsRoot']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('stateRoot')) {
      _stateRoot = EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['stateRoot']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('receiptsRoot')) {
      _receiptsRoot =
          EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['receiptsRoot']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('miner')) {
      _miner = EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['miner']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('difficulty')) {
      _difficulty =
          EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['difficulty']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('totalDifficulty')) {
      _totalDifficulty =
          EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['totalDifficulty']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('extraData')) {
      _extraData = EthereumUtilities.safeParse(data[EthereumConstants.ethResultKey]['extraData']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('size')) {
      _size = EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['size']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('gasLimit')) {
      _gasLimit = EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['gasLimit']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('gasUsed')) {
      _gasUsed = EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['gasUsed']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('timestamp')) {
      _timestamp = DateTime.fromMillisecondsSinceEpoch(
          EthereumUtilities.hexToInt(data[EthereumConstants.ethResultKey]['timestamp']));
    }
    if (data[EthereumConstants.ethResultKey].containsKey('uncles')) {
      _uncles = EthereumUtilities.hexToBigIntList(data[EthereumConstants.ethResultKey]['uncles']);
    }
    if (data[EthereumConstants.ethResultKey].containsKey('transactions')) {
      if ((data[EthereumConstants.ethResultKey]['transactions'] != null) &&
          (data[EthereumConstants.ethResultKey]['transactions'].isNotEmpty)) {
        if (data[EthereumConstants.ethResultKey]['transactions'][0] is String) {
          // Hashes
          _transactionsAreHashes = true;
          _transactions = EthereumUtilities.hexToBigIntList(
              data[EthereumConstants.ethResultKey]['transactions']);
        } else {
          // Transaction objects
          _transactions = List<EthereumTransaction>();
          for (Map transaction in data[EthereumConstants.ethResultKey]['transactions']) {
            final Map buildTrans = {EthereumConstants.ethResultKey: transaction};
            final EthereumTransaction entry =
                EthereumTransaction.fromMap(buildTrans);
            _transactions.add(entry);
          }
        }
      }
    }
  }

  // To string
  String toString() {
    final String ret = "Ethereum Block :" +
        "\n" +
        "  Number : $number" +
        "\n" +
        "  Hash : $hash" +
        "\n" +
        "  Parent Hash : $parentHash" +
        "\n" +
        "  Miner : $miner" +
        "\n" +
        "  Difficulty : $difficulty" +
        "\n" +
        "  Gas Used : $gasUsed" +
        "\n" +
        "  Time : $timestamp" +
        "\n";
    return ret;
  }
}
