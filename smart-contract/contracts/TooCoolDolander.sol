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

    // modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root){
    //   require(
    //     MerkleProof.verify(
    //       merkleProof,
    //       root,
    //       keccak256(abi.encodePacked(msg.sender))
    //     ),
    //     "Address does not exist in list"
    //   );
    //   _;
    // }

  function whitelistMint(bool isValid) 
    public 
    payable 
    onlyWhenNotPaused{
      // require(
      //   MerkleProof.verify(
      //     merkleProof,
      //     root,
      //     keccak256(abi.encodePacked(msg.sender))
      //   ),
      //   "Address does not exist in list"
      // );
        require(tokenIds < maxSupply, "Exceed  supply");
        require(msg.value >= cost, "Ether sent is not correct");
    
        require(isValid, 'Invalid proof!');
        //update the whitelist to be ture
        whitelistClaimed[msg.sender] = true;
        tokenIds += 1;
        
        _safeMint(msg.sender, 1);
  }

  function mint() public payable onlyWhenNotPaused {
            require(tokenIds < maxSupply, "Exceed maximum supply");
            require(msg.value >= cost, "Ether sent is not correct");
            require(whitelistMintEnded, 'The whitelist sale has ended!');

            tokenIds += 1;
            _safeMint(msg.sender, tokenIds);
    }
  
  function _baseURI() internal view virtual override returns (string memory) {
     return _baseTokenURI;
 }

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

  function setNotRevealedURI (string memory initNotRevealedURI) public onlyOwner{
    notRevealedURI = initNotRevealedURI;
  }
 
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

    function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
    tokenIds += _mintAmount;
    _safeMint(_receiver, _mintAmount);
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
