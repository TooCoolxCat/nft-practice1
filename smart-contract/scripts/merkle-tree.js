const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

let whitelistAddresses = [
    "0x48cE884A1ecead469c50b42370aF2983D59Bbb94", 
    "0xd01B3098483Ada04e133C8A3B9912D4cBfFb8C7E",
    "0xd38796bd8455c30632929B4384a0b5865aeBb9DB"
];

// Create a new array of `leafNodes` by hashing all indexes of the `whitelistAddresses`
// using `keccak256`. Then creates a Merkle Tree object using keccak256 as the algorithm.
//
// The leaves, merkleTree, and rootHas are all PRE-DETERMINED prior to whitelist claim

const leafNodes = whitelistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true});

//Get root hash of the `merkleeTree` in hexadecimal format (0x)
// Print out the Entire Merkle Tree.
const rootHash = '0x' + merkleTree.getRoot().toString('hex');
//console.log('Whitelist Merkle Tree\n', merkleTree.toString());
console.log("Root Hash: ", rootHash);


//const claimingAddress = leafNodes[0];

//string -> buffer
//const claimingAddress1 = keccak256("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2");
//console.log("address:",claimingAddress, typeof claimingAddress);

//hex buffer
//const hexProof1 = merkleTree.getHexProof(claimingAddress1);
// console.log("proof1:",hexProof1);


////
//const claimingAddress2 = keccak256("0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db");
//console.log("address:",claimingAddress, typeof claimingAddress);

//hex buffer
//const hexProof2 = merkleTree.getHexProof(claimingAddress2);
//console.log("proof2:",hexProof2);
//console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));


//Root Hash:  0x108928b18910db126ca1df62ca7362596c18303437ee639bde80b34ac477a84b