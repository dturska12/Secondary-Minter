In this contract, the `SecondaryMinter` contract allows users to randomly mint already minted(secondary) NFTs from another smart contract, specified by the nftContract variable. The maximum supply of NFTs that can be minted is set by the `maxSupply` variable, and the price to mint each NFT is set by the `mintPrice` variable. The `mintedCount` and `mintedTokens` mapping keep track of which tokens have already been minted.

The `addAvailableToken` and `removeAvailableToken` functions allow the contract owner to specify which tokens are available to be minted, and the `getRandomTokenId` function selects a random available token to be minted.

The `mintNFT` function is the main function that allows users to mint an NFT. It requires that the user pay the specified `mintPrice`

The case use for this would be with the **RugRescue**🛟 wrapper contract that allows communities to migrate their rugged nft collection, to a new community owned contarct. The secondary minter is designed to allow the `tokenIds` blacklisted from the original rugged collection, to be randomized and put into a paid mint, thus adding a chance for additional revenue for the recovering community. 
