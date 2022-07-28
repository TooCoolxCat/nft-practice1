const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

let whitelistAddresses = [
    "0x48cE884A1ecead469c50b42370aF2983D59Bbb94",
    "0xd38796bd8455c30632929B4384a0b5865aeBb9DB",
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"
];

// Create a new array of `leafNodes` by hashing all indexes of the `whitelistAddresses`
// using `keccak256`. Then creates a Merkle Tree object using keccak256 as the algorithm.
//
// The leaves, merkleTree, and rootHas are all PRE-DETERMINED prior to whitelist claim
const leafNodes = whitelistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});


//Get root hash of the `merkleeTree` in hexadecimal format (0x)
// Print out the Entire Merkle Tree.
const rootHash = merkleTree.getRoot();
console.log('Whitelist Merkle Tree\n', merkleTree.toString());
console.log("Root Hash: ", rootHash);


// ***** ***** ***** ***** ***** ***** ***** ***** //
const claimingAddress = leafNodes[3];

const hexProof = merkleTree.getHexProof(claimingAddress);
console.log(hexProof);

console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));