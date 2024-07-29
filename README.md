## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/DeployToken.s.sol:DeployScript --chain-id 421614 --rpc-url $RPC_URL \
    --etherscan-api-key $SCAN_API_KEY --verifier-url $EXPLORER_URL \
    --broadcast --verify -vvvv
```

```markdown
example:
- **Network**: https://sepolia-rollup.arbitrum.io/rpc
- **Explorer API Key**: Use your own
- **Explorer**: https://api-sepolia.arbiscan.io/api
- **Chain ID**: 421614
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
