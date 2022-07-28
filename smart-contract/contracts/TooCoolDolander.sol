// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract TooCoolDolander is ERC721Enumerable, Ownable{
    
    using Strings for uint256;
    
    bytes32 public merkleRoot;

    mapping(address => bool) public whitelistClaimed;

    string _baseTokenURI;
    string public notRevealedURI;

    uint256 public cost = 0.001 ether; 
    uint256 public tokenIds;
    uint256 public maxSupply = 333; 

    bool public _paused = false;
    bool public whitelistMintStarted = false;
    bool public whitelistMintEnded = false;
    bool public revealed = false;

    //Constructor takes in the baseURI to set _baseTokenURI for the collection.
    constructor(
    string memory baseURI,
    string memory initNotRevealedURI
      ) ERC721("TooCoolDolander", "TCD") {
    _baseTokenURI = baseURI;
    notRevealedURI = initNotRevealedURI;
  }


    modifier onlyWhenNotPaused {
            require(!_paused, "Contract currently paused");
            _;
        }

  function whitelistMint(bytes32[] calldata _merkleProof) public payable {

    require(whitelistMintStarted, 'The whitelist sale is not enabled!');
    require(!whitelistClaimed[msg.sender],'Address already claimed');

    //create a leaf node
    bytes32 leaf = keccak256(abi.encodePacked(msg.sender));

    //check if the verification is correct or not
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');

    //update the whitelist to be ture
    whitelistClaimed[msg.sender] = true;
    tokenIds += 1;
    _safeMint(msg.sender, 1);
  }

    function mint() public payable onlyWhenNotPaused {
            require(tokenIds < maxSupply, "Exceed maximum LW3Punks supply");
            require(msg.value >= cost, "Ether sent is not correct");
            require(whitelistMintEnded, 'The whitelist sale has ended!');

            tokenIds += 1;
            _safeMint(msg.sender, tokenIds);
    }
  
  function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
    tokenIds += _mintAmount;
    _safeMint(_receiver, _mintAmount);
  }

  /**
  * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
  * returned an empty string for the baseURI
  */
  function _baseURI() internal view virtual override returns (string memory) {
     return _baseTokenURI;
 }

  function setNotRevealedURI (string memory initNotRevealedURI) public onlyOwner{
    notRevealedURI = initNotRevealedURI;
  }
  /**
  * @dev tokenURI overides the Openzeppelin's ERC721 implementation for tokenURI function
  * This function returns the URI from where we can extract the metadata for a given tokenId
  */
 function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    if(revealed == false){
      return notRevealedURI;
    }
    else{
    string memory baseURI = _baseURI();

    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";

    }
}

/////onlyOwner////

    function setPaused(bool _state) public onlyOwner {
    _paused = _state;
  }
   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
    merkleRoot = _merkleRoot;
  }
    function setWhitelistMintStarted(bool _state) public onlyOwner {
    whitelistMintStarted = _state;
  }

   function setWhitelistMintEnded(bool _state) public onlyOwner {
    whitelistMintEnded = _state;
  }

  function reveal () public onlyOwner(){
    revealed = true;
  }

  function withdraw() public payable onlyOwner {

    (bool success, ) = payable(owner()).call{value: address(this).balance}('');
    require(success);
    // address _owner = owner();
    // uint256 amount = address(this).balance;
    //  (bool sent, ) =  _owner.call{value: amount}("");
    // require(sent, "Failed to send Ether");
  }

  receive() external payable {}

  fallback() external payable {}

}
