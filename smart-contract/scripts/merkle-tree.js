const keccak256 = require("keccak256");
const { MerkleTree } = require("merkletreejs");

let whitelistAddresses = [
    "0x48cE884A1ecead469c50b42370aF2983D59Bbb94", 
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
console.log('Whitelist Merkle Tree\n', merkleTree.toString());
console.log("Root Hash: ", rootHash);



//  const claimingAddress = leafNodes[0];

// string -> buffer
const claimingAddress = keccak256("0x48cE884A1ecead469c50b42370aF2983D59Bbb94");
console.log("address:",claimingAddress, typeof claimingAddress);
const hexProof1 = merkleTree.getHexProof(keccak256(claimingAddress));

  //hex buffer
  const hexProof2 = merkleTree.getHexProof(claimingAddress);
  console.log("proof1:",hexProof1);
  //need to change ' to "
  console.log("proof2:",hexProof2, typeof hexProof2);

console.log(merkleTree.verify(hexProof2, claimingAddress, rootHash));