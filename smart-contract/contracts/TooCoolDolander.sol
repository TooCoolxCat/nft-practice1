// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract TooCoolDolander is ERC721Enumerable, Ownable{
    
    using Strings for uint256;
    
     /**
     * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`.
     */
    string _baseTokenURI;
    uint256 public cost = 0.01 ether; 
    uint256 public tokenIds;
    uint256 public maxSupply = 333; 

    bool public _paused = true;
    //Constructor takes in the baseURI to set _baseTokenURI for the collection.
    constructor(
    string memory baseURI
      ) ERC721("TooCoolDolander", "TCD") {
    _baseTokenURI = baseURI;
  }


    modifier onlyWhenNotPaused {
            require(!_paused, "Contract currently paused");
            _;
        }

    function mint() public payable onlyWhenNotPaused {
            require(tokenIds < maxSupply, "Exceed maximum LW3Punks supply");
            require(msg.value >= cost, "Ether sent is not correct");
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

  /**
  * @dev tokenURI overides the Openzeppelin's ERC721 implementation for tokenURI function
  * This function returns the URI from where we can extract the metadata for a given tokenId
  */
 function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

    string memory baseURI = _baseURI();
            // Here it checks if the length of the baseURI is greater than 0, if it is return the baseURI and attach
            // the tokenId and `.json` to it so that it knows the location of the metadata json file for a given 
            // tokenId stored on IPFS
            // If baseURI is empty return an empty string
   return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
}

  // function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
  //   require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');

  //   if (revealed == false) {
  //     return hiddenMetadataUri;
  //   }

  //   string memory currentBaseURI = _baseURI();
  //   return bytes(currentBaseURI).length > 0
  //       ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
  //       : '';
  // }

  function setPaused(bool _state) public onlyOwner {
    _paused = _state;
  }


  function withdraw() public onlyOwner {

    // (bool os, ) = payable(owner()).call{value: address(this).balance}('');
    // require(os);
    address _owner = owner();
    uint256 amount = address(this).balance;
     (bool sent, ) =  _owner.call{value: amount}("");
    require(sent, "Failed to send Ether");
  }

  receive() external payable {}

  fallback() external payable {}

}
