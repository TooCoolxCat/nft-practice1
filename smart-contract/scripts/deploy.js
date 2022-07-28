const { ethers } = require("hardhat");
const { METADATA_URL,PREVIEW_URL} = require("../constants");

async function main() {

  console.log('Deploying contract...');

   // URL from where we can extract the metadata for a Crypto Dev NFT
   const metadataURL = METADATA_URL;
   const previewURL = PREVIEW_URL;
   const Contract = await ethers.getContractFactory("TooCoolDolander");
 
   const contract = await Contract.deploy(
     metadataURL, previewURL
    
   );

   await contract.deployed();
   
   console.log('Contract deployed to:', contract.address);

//    console.log("sleeping");

//    await sleep(10000);

//    await hre.run ("verify:verify", {
//     address: contract.address,
//     constructorArguments:[],
//    });

 }

// function sleep(ms){
//   return new Promise((resolve) => setTimeout (resolve, ms));
// }

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
.then(()=>process.exit(0))
.catch((error) => {
  console.error(error);
  process.exitCode(1);
});
