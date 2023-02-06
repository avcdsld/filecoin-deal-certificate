require("hardhat-deploy");
require("hardhat-deploy-ethers");

const private_key = network.config.accounts[0];
const wallet = new ethers.Wallet(private_key, ethers.provider);

module.exports = async ({ deployments }) => {
    console.log("Wallet Ethereum Address:", wallet.address)

    const FilecoinDealCertificate = await ethers.getContractFactory('FilecoinDealCertificate', wallet);
    console.log('Deploying FilecoinDealCertificate...');
    const filecoinDealCertificate = await FilecoinDealCertificate.deploy();
    await filecoinDealCertificate.deployed();
    console.log('FilecoinDealCertificate deployed to:', filecoinDealCertificate.address);
}