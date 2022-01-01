const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('EpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  let mintedNfts = await nftContract.getNumberOfMintedNFTs();
  console.log("Minted NFTs:", mintedNfts);

  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  sleep(1000);

  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  sleep(1000);

  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  sleep(1000);

  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  sleep(1000);

  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
  sleep(1000);

  mintedNfts = await nftContract.getNumberOfMintedNFTs();
  console.log("Minted NFTs:", mintedNfts);

  maxNFTs = await nftContract.getMaxNFTSToMint();
  console.log("Max NFTs:", maxNFTs);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();