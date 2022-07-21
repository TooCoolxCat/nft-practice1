const { ethers } = require("hardhat");
const { METADATA_URL, FASHIONLIST } = require("../constants");
require("dotenv").config({ path: ".env" });

async function main() {

  console.log('Deploying contract...');

   // URL from where we can extract the metadata for a Crypto Dev NFT
   const metadataURL = METADATA_URL;
   const fashionlist = FASHIONLIST;

   const Contract = await ethers.getContractFactory("TooCoolDolander");
 
   const contract = await Contract.deploy(
     metadataURL,
     fashionlist
   );

   await contract.deployed();

   console.log('Contract deployed to:', contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
