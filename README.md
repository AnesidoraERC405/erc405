# ERC405
A New Approach to runes/inscription/nft tokenization

## Introduction
ERC405 employs a mixed implementation of Runes/Inscription / ERC20 / ERC1155 with native liquidity and tokenization. By fragmenting runes, it becomes possible to add native liquidity and perform swaps similar to ERC20 tokens. This was inspired by the runes and ERC404 protocol.

## Its characteristics

ERC405 assets have ERC20/NFT/Runes three attributes simultaneously, and supports launch large quantities of MEME runes, with gas costs equivalent to ERC20.
This means that you issue a significant amount of MEME runes tokens using the ERC450 protocol. These assets can be traded in the NFT market and liquidity can be added on Uniswap. The gas cost for deploying, transferring, and other interactions is almost identical to a regular ERC20 token.

### The advantages of ERC-405
![image](https://github.com/AnesidoraERC405/resource/blob/main/advantage.png?raw=true)

## How it Works
It’s important to understand the underlying philosophy of ERC405 Protocol.

Let's first examine the challenges faced by the ERC404 protocol in addressing the tokenization liquidity of NFTs:

All ERC721 interface functions respect typical operation whereby users are able to transfer distinct token id’s without friction. As this native fractional balance is transferred, however, whole tokens leave the users account, drawn from a queue when ownership of whole tokens changes.

For example, when a user with a balance of 7.2 tokens transfers a fractional representation of 0.3, their most recently received token would be removed, and their balance would be 6.9.
This begs the question of where whole tokens go under these circumstances. 

The initial solution for 404 was that when tokens were transferred, NFTs were destroyed and minted along with them. While te early 404 protocol could offer a solution where an asset possesses both NFT and ERC20 attributes, once the number of NFTs scaled up, individually destroying and minting each one meant significant gas wastage, it was not economically viable at all.

We all know that the gas cost for transfers is always lower than for minting. Therefore, the correct approach should be: when transferring tokens, transfer the corresponding NFTs. We can see that later versions of the ERC404 protocol proposed a similar solution:

Transfers of full ERC-20 type tokens now transfer ERC-721 type tokens held by the sender to the recipient. In other words, if you transfer 3 full tokens as an ERC-20 transfer, 3 of the ERC-721s in your wallet will transfer directly to the recipient rather than those ERC-721s being burned and new token ids minted to the recipient.

But this doesn't solve the problem, the gas cost for transferring NFTs remains high, and ERC404 assets cannot be tokenized in large quantities. This is the current issue with the ERC404 protocol.
Different from the ERC404 and DN404 protocols, 

ERC405 employs a mixed implementation of Runes/Inscription / ERC20 / ERC1155 with native liquidity and fractionalization. The main issue to address is the fragmented liquidity provided liquidity by the runes.
As is well-known, EVM-class runes are semi-fungible tokens, similar to NFTs, lack of native liquidity. 

The ERC405 protocol inherits and enhances the ERC1155 protocol, within which NFT with Token ID 405, carrying runes information, serves as proof of runes assets.

During the asset minting phase, the ERC405 protocol will mint a hybrid ERC1155 asset with runes content, labeled Token ID 405. Simultaneously, based on the tokenizationparameters, corresponding ERC20 assets will be generated.

![image](https://github.com/AnesidoraERC405/resource/blob/main/erc405.png?raw=true)

During asset transfers under the ERC405 protocol, the solution provided is : Token transfers take place, and NFTs follow in batch transfers, the reverse is also true.

So how do we handle NFTs, when users transferring tokens with decimals?
The answer is over-collateralization!

When the token transfer quantity is less than the ratio coefficient between runes NFTs and tokens,The NFTs sent by the user will be deducted by an extra NFT, but the receiving user will also not receive this NFT.

 Where does it go? It will be collateralized within the token contract.
 
For example,  the ratio coefficient between runes NFTs and tokens is 1 million (meaning one NFT represents 1 million fragmented tokens), when user Bob transfers 1.5 million tokens to Alice, Alice will only receive 1 NFT and 1.5 million tokens, while Bob will be deducted 2 NFTs and 1.5 million tokens, with one NFT held by the token contract.

When will this NFT be given to Alice? As soon as anyone transfers over 500,000 tokens to Alice, this NFT will be transferred from the token contract to Alice.

How is the gas issue addressed then? 

As no burn-mint model is employed, we enhance the ERC1155 protocol to support batch transfers., so the gas fees for asset transfers are almost identical to ERC20 tokens.

Average gas costs per 100NFTs:

![image](https://github.com/AnesidoraERC405/resource/blob/main/compare.png?raw=true)

## Verification
As mentioned, assets issued on ERC405 have triple attributes: runes, NFT, and ERC20. They are tradable on NFT marketplaces, and liquidity can be added on Uniswap. The gas fees for transfers are almost identical to ERC20 tokens.

For this purpose, we have released Anesi on Xlayer(okx mainnet)  to verify the results.

Runes attributes

![image](https://github.com/AnesidoraERC405/resource/blob/main/runes.png?raw=true)

Erc20 attributes (Add Anesi in MetaMask)

![image](https://github.com/AnesidoraERC405/resource/blob/main/okxwallet.png?raw=true)

Anesi NFT in OKX Wallet

![image](https://github.com/AnesidoraERC405/resource/blob/main/nft.png?raw=true)

When you purchase an runes NFT, the rune tokens will be transferred along with it.

![image](https://github.com/AnesidoraERC405/resource/blob/main/buy_on_okx.png?raw=true)

Transfer ERC450 assets in the wallet using the NFT transfer

![image](https://github.com/AnesidoraERC405/resource/blob/main/transfer_nft.png?raw=true)

Transfer ERC450 assets in the wallet using the ERC20 transfer

![image](https://github.com/AnesidoraERC405/resource/blob/main/transfer_nft.png?raw=true)

Transfer ERC450 assets in the wallet using the NFT transfer

![image](https://github.com/AnesidoraERC405/resource/blob/main/transfer_token.png?raw=true)

Add liquidity on Swap

![image](https://github.com/AnesidoraERC405/resource/blob/main/add_liquidity.png?raw=true)

Buy on Swap
![image](https://github.com/AnesidoraERC405/resource/blob/main/buy_on_swap.png?raw=true)

## Result
The final outcome demonstrates that ERC20 assets possess triple attributes: runes, NFT, and ERC20, simultaneously supporting issuance in large quantities and exhibiting MEME properties. They can be traded normally on NFT marketplaces, with very low gas fees for large transfers. 

They are supported in various wallets (such as MetaMask, OKX Wallet, Bitget Wallet) and liquidity can be added and swaps can be completed on swap. In the foreseeable future, this will bring about a revolutionary impact on semi-fungible tokens such as runes and runes!

 It will surely bring a brand new revolution to the runes market and fragmented protocol!
 