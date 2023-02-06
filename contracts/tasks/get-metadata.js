task("get-metadata", "Get FilecoinDealCertificate NFT Metadata")
  .addParam("contract", "The deployed contract address")
  .addParam("tokenid", "The tokenId")
  .setAction(async (taskArgs) => {
    const contractAddr = taskArgs.contract;
    const tokenId = taskArgs.tokenid;

    const wallet = new ethers.Wallet(network.config.accounts[0], ethers.provider);
    const FilecoinDealCertificate = await ethers.getContractFactory("FilecoinDealCertificate", wallet);
    const filecoinDealCertificate = await FilecoinDealCertificate.attach(contractAddr);

    console.log('Getting metadata...');
    const tokenURI = await filecoinDealCertificate.tokenURI(tokenId);
    console.log("tokenURI:", tokenURI);
    const metadata = await filecoinDealCertificate.metadata(tokenId);
    console.log("metadata:", metadata);
  });
