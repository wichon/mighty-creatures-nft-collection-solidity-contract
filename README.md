# Mighty Creatures NFT Collection - Etherum/Solidity Contract

An awesome NFT collection of Mighty Creatures "randomly" created with a limited minting (configurable) of NFTs.

## Play 👽

A working web3 app interacting with this contract can be found on: https://nft-starter-project.wichon.repl.co/

And the code the for it can be found in: [mighty-creatures-nft-collection-web-app](https://github.com/wichon/mighty-creatures-nft-collection-web-app) (Developed in [Replit](https://replit.com/))


## Instructions

### 1. Setup

This project depends on Node 16, so install it using nvm or your favorite tool to handle Node versions.

Nvm install Node 16 (In case you dont have it):
```
nvm install 16
```

Nvm use Node 16:
```
nvm use 16 
```

Install npm packages and dependencies:
```
npm install
```

Rename the dummy hardhat config file
```
mv hardhat.config.dummy.js hardhat.config.js
```

Configure your hardhat config file, with the appropiate keys and api urls
```
hardhat.config.js
```

### 2. Test

```
npx hardhat run scripts/run.js
```

### 3. Deploy

```
npx hardhat run scripts/deploy.js --network rinkeby
```

**Save your deployed contract address, it is useful to access your contract in Etherscan or OpenSea**

### 4. Verify

Verify your code with Etherscan (Once deployed)

```
npx hardhat verify {Your awesome contract address} --network rinkeby
```

### 5. Have fun 🛸!!

🤓

### 6. WARNING

**Don't commit your hardhat.config.js once you set your api keys, those are private for you only**

### Thanks to [Buildspace 🦄](https://buildspace.so/) for their amazing courses!!