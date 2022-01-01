const sleep = (milliseconds) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('EpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the function.
  let txn = await nftContract.makeAnEpicNFT()
  // Wait for it to be mined.
  await txn.wait()

  await sleep(5000)

  txn = await nftContract.makeAnEpicNFT()
  await txn.wait()

  await sleep(2000)

  txn = await nftContract.makeAnEpicNFT()
  await txn.wait()

  console.log("Minted NFT #1")
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
