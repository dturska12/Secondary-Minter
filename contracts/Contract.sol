// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RandomNFTMinter is Ownable, IERC721Receiver {
    using EnumerableSet for EnumerableSet.UintSet;

    IERC721 public nftContract;
    uint256 public maxSupply;
    uint256 public mintPrice;
    uint256 public mintedCount;
    mapping(uint256 => bool) public mintedTokens;
    EnumerableSet.UintSet private availableTokens;

    event NFTMinted(address indexed recipient, uint256 tokenId);

    constructor(IERC721 _nftContract, uint256 _maxSupply, uint256 _mintPrice) {
        nftContract = _nftContract;
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        mintedCount = 0;
    }

    function mintNFT(address recipient) external payable {
        require(msg.value >= mintPrice, "Insufficient funds to mint NFT.");
        require(mintedCount < maxSupply, "All NFTs have been minted.");
        uint256 tokenId = getRandomTokenId();
        mintedTokens[tokenId] = true;
        mintedCount++;
        availableTokens.remove(tokenId);
        nftContract.safeTransferFrom(address(this), recipient, tokenId);
        emit NFTMinted(recipient, tokenId);
    }

    function getRandomTokenId() private returns (uint256) {
        uint256 length = availableTokens.length();
        require(length > 0, "No available tokens to mint.");
        uint256 randomIndex = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.difficulty))
        ) % length;
        return availableTokens.at(randomIndex);
    }

    function addAvailableToken(uint256 tokenId) external onlyOwner {
        require(!mintedTokens[tokenId], "Token has already been minted.");
        availableTokens.add(tokenId);
    }

    function removeAvailableToken(uint256 tokenId) external onlyOwner {
        availableTokens.remove(tokenId);
    }

    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
