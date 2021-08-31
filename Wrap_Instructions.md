1. First, see which IKB tokens you own by checking the original IKB contract on [Etherscan](https://etherscan.io/address/0x88ae96845e157558ef59e9ff90e766e22e480390#readContract). Call the function getHolderEditions(), enter your own wallet address in as an argument.

![getHolderEditions](https://chan.gallery/assets/getHolderEditions.png)


### To wrap all your IKB tokens

1. Visit the original IKB contract on [Etherscan by following this link](https://etherscan.io/address/0x88ae96845e157558ef59e9ff90e766e22e480390#readContract).
2. Ensure that Metamask is connected.
3. Under the "Write Contract" tab, call the function `approve`, and enter `0x80F1Ed6A1Ac694317dC5719dB099a440627D1ea7` as `spender`. As `value`, enter however many tokens you own, or just enter 999. This gives the Wrapped IKB contract permission to hold your IKB tokens.  

![approve function](https://chan.gallery/assets/approveNew.png)  

4. Visit the Wrapped IKB contract on [Etherscan by following this link](https://etherscan.io/address/0x80f1ed6a1ac694317dc5719db099a440627d1ea7#writeContract).
5. Ensure that you are connected to your wallet on Metamask.
6. Under the "Write Contract" tab, Call the `2. mint` function. Your wrapped IKB will appear on Rarible and Mintable after a short wait. 

![wrapAll function](https://chan.gallery/assets/2_mint.png)  

7. To get OpenSea to recognize the tokens `5. SafeTransferFrom` and just send each token to yourself. Be sure to enter the tokenID you just wrapped. OpenSea has a weird blind spot about this contract until it sees a Transfer event.




### To wrap a specific IKB edition

1. Visit the original IKB contract on [Etherscan by following this link](https://etherscan.io/address/0x88ae96845e157558ef59e9ff90e766e22e480390#readContract).
2. Ensure that Metamask is connected.
3. Under the "Write Contract" tab, Call the function `specificApprove()`, and enter `0x80F1Ed6A1Ac694317dC5719dB099a440627D1ea7` as the `address` parameter, and the edition number of the token you'd like to wrap. This gives the Wrapped IKB contract permission to hold only that specific token.

![wrapAll function](https://chan.gallery/assets/specificApproveNew.png)  

4. Visit the Wrapped IKB contract on [Etherscan by following this link](https://etherscan.io/address/0x80f1ed6a1ac694317dc5719db099a440627d1ea7#writeContract).
5. Ensure that you are connected to your wallet on Metamask.
6. Under the "Write Contract" tab, Call the `3. mint` function, entering the edition number of the token you'd like to wrap.

![wrapSpecific function](https://chan.gallery/assets/3_mint.png) 

Your wrapped IKB will appear on Rarible and Mintable after a short wait.

7. To get OpenSea to recognize the tokens `SafeTransferFrom` and just send each token to yourself. Be sure to enter the tokenID you just wrapped. OpenSea has a weird blind spot about this contract until it sees a Transfer event.

### To show your token on Opensea

The IKB Cachet de Garantie automatically shows up on other trading and NFT gallery platforms, but OpenSea is currently having difficulty with it. OpenSea will recognize the NFT now only if it signals a `SafeTransferFrom` event to the blockchain. To do this:

1. Visit (or stay on) the Wrapped IKB contract on [Etherscan by following this link](https://etherscan.io/address/0x80f1ed6a1ac694317dc5719db099a440627d1ea7#writeContract).

2. Under the "Write Contract" tab, `5. SafeTransferFrom` and just send the token to yourself. Be sure to enter the tokenID you just wrapped.

![push to OpenSea](http://chan.gallery/assets/openseaFix.png) 

Your wrapped IKB will appear on Opensea after a short wait. 
