// SPDX-License-Identifier: MIT

// ,---------.    ,-----.        ,-----.        _______      ,-----.        ,-----.      .---.           _░▒███████
// \          \ .'  .-,  '.    .'  .-,  '.     /   __  \   .'  .-,  '.    .'  .-,  '.    | ,_|           ░██▓▒░░▒▓██
//  `--.  ,---'/ ,-.|  \ _ \  / ,-.|  \ _ \   | ,_/  \__) / ,-.|  \ _ \  / ,-.|  \ _ \ ,-./  )          ██▓▒░__░▒▓██___██████
//     |   \  ;  \  '_ /  | :;  \  '_ /  | :,-./  )      ;  \  '_ /  | :;  \  '_ /  | :\  '_ '`)        ██▓▒░___░▓██▓_____░▒▓██
//     :_ _:  |  _`,/ \ _/  ||  _`,/ \ _/  |\  '_ '`)    |  _`,/ \ _/  ||  _`,/ \ _/  | > (_)  )        ██▓▒░_______________░▒▓██
//     (_I_)  : (  '\_/ \   ;: (  '\_/ \   ; > (_)  )  __: (  '\_/ \   ;: (  '\_/ \   ;(  .  .-'        _██▓▒░______________░▒▓██
//    (_(=)_)  \ `"/  \  ) /  \ `"/  \  ) / (  .  .-'_/  )\ `"/  \  ) /  \ `"/  \  ) /  `-'`-'|___      __██▓▒░____________░▒▓██
//     (_I_)    '. \_/``".'    '. \_/``".'   `-'`-'     /  '. \_/``".'    '. \_/``".'    |        \     ___██▓▒░__________░▒▓██
//     '---'      '-----'        '-----'       `._____.'     '-----'        '-----'      `--------`     ____██▓▒░________░▒▓██
//                                                                                                      _____██▓▒░_____░▒▓██
//    ______         ,-----.      .---.       ____   ,---.   .--.______         .-''-.  .-------.       ______██▓▒░__░▒▓██
//   |    _ `''.   .'  .-,  '.    | ,_|     .'  __ `.|    \  |  |    _ `''.   .'_ _   \ |  _ _   \      _______█▓▒░░▒▓██
//   | _ | ) _  \ / ,-.|  \ _ \ ,-./  )    /   '  \  \  ,  \ |  | _ | ) _  \ / ( ` )   '| ( ' )  |      _________░▒▓██
//   |( ''_'  ) |;  \  '_ /  | :\  '_ '`)  |___|  /  |  |\_ \|  |( ''_'  ) |. (_ o _)  ||(_ o _) /      _______░▒▓██
//   | . (_) `. ||  _`,/ \ _/  | > (_)  )     _.-`   |  _( )_\  | . (_) `. ||  (_,_)___|| (_,_).' __    _____░▒▓██
//   |(_    ._) ': (  '\_/ \   ;(  .  .-'  .'   _    | (_ o _)  |(_    ._) ''  \   .---.|  |\ \  |  | 
//   |  (_.\.' /  \ `"/  \  ) /  `-'`-'|___|  _( )_  |  (_,_)\  |  (_.\.' /  \  `-'    /|  | \ `'   / 
//   |       .'    '. \_/``".'    |        \ (_ o _) /  |    |  |       .'    \       / |  |  \    /  
//   '-----'`        '-----'      `--------`'.(_,_).''--'    '--'-----'`       `'-..-'  ''-'   `'-'                                                                                         

// ✨The most fashionable cat in WEB3✨ 
//  Made with Beauty and Love;



pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract TooCoolDolander is ERC721Enumerable, Ownable, ReentrancyGuard{
    
    using Strings for uint256;
    
    bytes32 public merkleRoot;

    mapping(address => bool) public fashionlistClaimed;

    string selfie;
    string public hiddenMessage;

    uint256 public cost = 0.0 ether; 
    uint256 public tokenIds;
    uint256 public immutable maxSupply = 3333; 
    uint256 public immutable reserveSupply = 333;

    bool public _paused = false;
    bool public isValid = false;
    bool public catWalkStarted = false;
    bool public catWalkEnded = false;
    bool public revealed = false;
    bool public champagneFinished = false;

    constructor(
    string memory selfieURI,
    string memory hiddenMessageURL
      ) ERC721("TooCoolDolander", "TOOCOOL") {
    selfie = selfieURI;
    hiddenMessage = hiddenMessageURL;
  }

    modifier onlyWhenNotPaused {
            require(!_paused, "CONTRACT PAUSED");
            _;
        }

    modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 merkleRoot){
      require(
        MerkleProof.verify(
          merkleProof,
          merkleRoot,
          keccak256(abi.encodePacked(msg.sender))
        ),
        "NOT ON FASHIION LIST"
      );
      _;
    }

  function fashionlistMint(bytes32[] calldata merkleProof)
        external
        payable
        onlyWhenNotPaused
        nonReentrant
        isValidMerkleProof(merkleProof, merkleRoot){

        require(tokenIds < maxSupply, "EXCEED  SUPPLY");
        require(catWalkStarted&&!catWalkEnded, 'NOT RIGHT TIME');
        require(msg.value >= cost, "ETHER SENT NOT CORRECT");
        require(balanceOf(msg.sender) == 0, 'ONE TOOCOOL PER WALLET');

        fashionlistClaimed[msg.sender] = true;
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
  }

  function beTooCool() external payable nonReentrant onlyWhenNotPaused {
        require(tokenIds < maxSupply, "EXCEED  SUPPLY");
        require(msg.value >= cost, "ETHER SENT NOT CORRECT");
        require(balanceOf(msg.sender) == 0, 'ONE TOOCOOL PER WALLET');
        require(catWalkEnded, 'NOT RIGHT TIME');

        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
  }
  
  function _baseURI() internal view virtual override returns (string memory) {
     return selfie;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
    if(revealed == false){
      return hiddenMessage;
    }
    else{
    string memory selfieURI = _baseURI();

    return bytes(selfieURI).length > 0 ? string(abi.encodePacked(selfieURI, tokenId.toString(), ".json")) : "";
    }
  }

/////onlyOwner////

  // function setNotRevealedURI (string memory initNotRevealedURI) public onlyOwner{
  //   hiddenMessage = hiddenMessageURL;
  // }
 
    function setPaused(bool _state) external onlyOwner {
    _paused = _state;
  }
   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
    merkleRoot = _merkleRoot;
  }
    function setcatWalkStarted(bool _state) external onlyOwner {
    catWalkStarted = _state;
  }
   function setcatWalkEnded(bool _state) external onlyOwner {
    catWalkEnded = _state;
  }
  function reveal () external onlyOwner(){
    revealed = true;
  }
  function champagneBeforeParty() external onlyOwner {
        require(!champagneFinished, "RESERVE MINT COMPLETED");

        for (uint256 tokenId = 1; tokenId <= maxSupply; tokenId++) {
            _safeMint(owner(), tokenId);
        }
       champagneFinished = true;
    }

  function mintForAddress(uint256 _mintAmount, address _receiver) external onlyOwner {
    tokenIds += _mintAmount;
    _safeMint(_receiver, _mintAmount);
  }

  function withdraw() external payable onlyOwner {
    (bool success, ) = payable(owner()).call{value: address(this).balance}('');
    require(success, "SEND ETHER FAILED");
  }

  receive() external payable {}

  fallback() external payable {}

}