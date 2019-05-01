# Tyslinchain

[![Build Status](https://travis-ci.org/tyslinchain/tyslinchain.svg?branch=master)](https://travis-ci.org/tyslinchain/tyslinchain)
[![Join the chat at https://gitter.im/tyslinchain/tyslinchain](https://badges.gitter.im/tyslinchain/tyslinchain.svg)](https://gitter.im/tyslinchain/tyslinchain?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## About Tyslinchain

TyslinChain is an innovative solution to the scalability problem with the Ethereum blockchain.
Our mission is to be a leading force in building the Internet of Value, and its infrastructure.
We are working to create an alternative, scalable financial system which is more secure, transparent, efficient, inclusive, and equitable for everyone.

TyslinChain relies on a system of 150 Masternodes with a Proof of Stake Voting consensus that can support near-zero fee, and 2-second transaction confirmation times.
Security, stability, and chain finality are guaranteed via novel techniques such as double validation, staking via smart-contracts, and "true" randomization processes.

Tyslinchain supports all EVM-compatible smart-contracts, protocols, and atomic cross-chain token transfers.
New scaling techniques such as sharding, private-chain generation, and hardware integration will be continuously researched and incorporated into Tyslinchain's masternode architecture. This architecture will be an ideal scalable smart-contract public blockchain for decentralized apps, token issuances, and token integrations for small and big businesses.

More details can be found at our [technical white paper](https://tyslinchain.com/docs/technical-whitepaper---1.0.pdf)

Read more about us on:

- our website: http://tyslinchain.com
- our blogs and announcements: https://medium.com/tyslinchain
- our documentation portal: https://docs.tyslinchain.com

## Building the source

Tyslinchain provides a client binary called `tyslin` for both running a masternode and running a full-node.
Building `tyslin` requires both a Go (1.7+) and C compiler; install both of these.

Once the dependencies are installed, just run the below commands:

```bash
$ git clone https://github.com/tyslinchain/tyslinchain tyslinchain
$ cd tyslinchain
$ make tyslin
```

Alternatively, you could quickly download our pre-complied binary from our [github release page](https://github.com/tyslinchain/tyslinchain/releases)

## Running tyslin

### Running a tyslin masternode

Please refer to the [official documentation](https://docs.tyslinchain.com/get-started/run-node/) on how to run a node if your goal is to run a masternode.
The recommanded ways of running a node and applying to become a masternode are explained in detail there.

### Attaching to the Tyslinchain test network

We published our test network 2.0 with full implementation of PoSV consensus at https://stats.testnet.tyslinchain.com.
If you'd like to experiment with smart contract creation and DApps, you might be interested to give these a try on our Testnet.

In order to connect to one of the masternodes on the Testnet, just run the command below:

```bash
$ tyslin attach https://testnet.tyslinchain.com
```

This will open the JavaScript console and let you query the blockchain directly via RPC.

### Running tyslin locally

If you would like to run tyslin locally to see how it works under the hood and have a copy of the blockchain, you can try it on our Testnet by running the commands below:

```bash
// 1. create a folder to store tyslinchain data on your machine
$ export DATA_DIR=/path/to/your/data/folder
$ mkdir -p $DATA_DIR/tyslin

// 2. download our genesis file
$ export GENESIS_PATH=$DATA_DIR/genesis.json
$ curl -L https://raw.githubusercontent.com/tyslinchain/tyslinchain/master/genesis/testnet.json -o $GENESIS_PATH

// 3. init the chain from genesis
$ tyslin init $GENESIS_PATH --datadir $DATA_DIR

// 4. get a test account. Create a new one if you don't have any:
$ export KEYSTORE_DIR=keystore
$ touch $DATA_DIR/password && echo 'your-password' > $DATA_DIR/password
$ tyslin account new \
      --datadir $DATA_DIR \
      --keystore $KEYSTORE_DIR \
      --password $DATA_DIR/password

// if you already have a test account, import it now
$ tyslin  account import ./private_key \
      --datadir $DATA_DIR \
      --keystore $KEYSTORE_DIR \
      --password $DATA_DIR/password

// get the account
$ account=$(
  tyslin account list --datadir $DATA_DIR  --keystore $KEYSTORE_DIR \
  2> /dev/null \
  | head -n 1 \
  | cut -d"{" -f 2 | cut -d"}" -f 1
)

// 5. prepare the bootnodes list
$ export BOOTNODES="enode://4d3c2cc0ce7135c1778c6f1cfda623ab44b4b6db55289543d48ecfde7d7111fd420c42174a9f2fea511a04cf6eac4ec69b4456bfaaae0e5bd236107d3172b013@52.221.28.223:30301,enode://298780104303fcdb37a84c5702ebd9ec660971629f68a933fd91f7350c54eea0e294b0857f1fd2e8dba2869fcc36b83e6de553c386cf4ff26f19672955d9f312@13.251.101.216:30301,enode://46dba3a8721c589bede3c134d755eb1a38ae7c5a4c69249b8317c55adc8d46a369f98b06514ecec4b4ff150712085176818d18f59a9e6311a52dbe68cff5b2ae@13.250.94.232:30301"

// 6. Start up tyslin now
$ export NAME=YOUR_NODE_NAME
$ tyslin \
  --verbosity 4 \
  --datadir $DATA_DIR \
  --keystore $KEYSTORE_DIR \
  --identity $NAME \
  --password $DATA_DIR \
  --networkid 89 \
  --port 30303 \
  --rpc \
  --rpccorsdomain "*" \
  --rpcaddr 0.0.0.0 \
  --rpcport 8545 \
  --rpcvhosts "*" \
  --ws \
  --wsaddr 0.0.0.0 \
  --wsport 8546 \
  --wsorigins "*" \
  --mine \
  --gasprice "1" \
  --targetgaslimit "420000000"
```

*Some explanations on the flags*

```
--verbosity: log level from 1 to 5. Here we're using 4 for debug messages
--datadir: path to your data directory created above.
--keystore: path to your account's keystore created above.
--identity: your full-node's name.
--password: your account's password.
--networkid: our testnet network ID.
--port: your full-node's listening port (default to 30303)
--rpc, --rpccorsdomain, --rpcaddr, --rpcport, --rpcvhosts: your full-node will accept RPC requests at 8545 TCP.
--ws, --wsaddr, --wsport, --wsorigins: your full-node will accept Websocket requests at 8546 TCP.
--mine: your full-node wants to register to be a candidate for masternode selection.
--gasprice: Minimal gas price to accept for mining a transaction.
--targetgaslimit: Target gas limit sets the artificial target gas floor for the blocks to mine (default: 4712388)
```

## Road map

The implementation of the following features is being studied by our research team:

- Layer 2 scalability with state sharding
- DEX integration
- Spam filtering
- Multi-chain interoperabilty

## Contributing and technical discussion

Thank you for considering to try out our network and/or help out with the source code.
We would love to get your help; feel free to lend a hand.
Even the smallest bit of code, bug reporting, or just discussing ideas are highly appreciated.

If you would like to contribute to the tyslinchain source code, please refer to our Developer Guide for details on configuring development environment, managing dependencies, compiling, testing and submitting your code changes to our repo.

Please also make sure your contributions adhere to the base coding guidelines:

- Code must adhere to official Go [formatting](https://golang.org/doc/effective_go.html#formatting) guidelines (i.e uses [gofmt](https://golang.org/cmd/gofmt/)).
- Code comments must adhere to the official Go [commentary](https://golang.org/doc/effective_go.html#commentary) guidelines.
- Pull requests need to be based on and opened against the `master` branch.
- Any code you are trying to contribute must be well-explained as an issue on our [github issue page](https://github.com/tyslinchain/tyslinchain/issues)
- Commit messages should be short but clear enough and should refer to the corresponding pre-logged issue mentioned above.

For technical discussion, feel free to join our chat at [Gitter](https://gitter.im/tyslinchain/tyslinchain).
