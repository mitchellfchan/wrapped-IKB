// SPDX-License-Identifier: MIT

pragma solidity ^0.7.6;
pragma abicoder v2;

import "./ERC721.sol";
import "./IKlein.sol";
import "./ProxyRegistry.sol";

contract WrappedIKB is ERC721, ERC721Burnable, Ownable {

  string[101] private _tokenIPFSHashes = [
"QmZ6USmEdQFBseMTxWw6QK6STHGVU5XKXP1xv654F69cGs",
"QmT9mcqtBLwPg4388u4LMbG3PdLqnTJRRCMfkr2jE6KvdU",
"QmddAk9ELXEJeuQTPkajBep5gBAosKzA3araPTnyXmetoz",
"QmezCxZ1FCNJ6eF237Y1npyRCMKR5Adjdd6SptGebcNv9S",
"QmcpBKYVLnatVtXgyXjsatbEFNGXS6APe26ZhkpNHhp6an",
"QmX9b9rXUmv26LdGPww1rtxycdPjS12yFD3x7Qj266xpdP",
"QmYBsSAR6kHeccAyGN8j8d7pqYm53bXb8ASRTvPkLgSwpu",
"QmbeZ5zYBnAF1Uhp258vyDCZgKx4TdK9mSPWMXZSSkmTva",
"QmcCXrdjBTLMSCSwQ73YgUit6zjDG6Z6dA6F2iGCUXjMJA",
"QmQKMQcurN4NHgdhKdyrXEQHUhcMuANX4SZ4NEPsPEfwtN",
"QmWbKWntztpdRWGsobsTMiU2KY3Mn19eTt4Kg9AKFPkatR",
"QmU1sr3ymWB2Jpsm2UXQD9nwLgNHsmPo4kduAPeB2kBqMy",
"Qmba3JVWq8sLHx1LPcxiFtLDWN13f8uGdpZeYwBiSTCAju",
"QmUdpiA3hCe36MiTNA6xDSEwcBF9yAASsFe6t7n3Kz2bMq",
"QmdP2BgXg2zoh57u7spVa4wE57nmkbGSJXuZefzgbpPZYF",
"QmYvAdGt2NdmntcHMg9pNS1cXsafJZ2GUnDuyEviCBgJat",
"QmU3Q8AYuDwzwPXZzawaJosjBHCDPAsZCuU4ysXrXmx864",
"QmbHMdiaTqHYvc4ho7yGMRZ5XNVRTrrVMs656YeyFDy13A",
"QmaivaZLzaatJggUmW4TbXL1TJQ1PkgLVShSv1nsj8xCWc",
"QmetUJ8WZQggs5F1SVsxYD2Zv1wR4cYCKejx9mDJQYv6RW",
"QmYTyjotUEQ3fi6u1psJ1pYKLt9toHfvyvtZfzkzwukTF2",
"QmUS6Vqk5u6CaJWk4ie7Ypvpw3kuCYREa1xKSfZakrvH1D",
"QmYh3FAnCKDKXzxx455XofDyezZ9eqjTrM9S37zq3WBh4t",
"QmQre1twNhehVAfERckWhbH7B6z8RvjhZLJqn6eQv8WFAL",
"QmSe2qfwmMkchoA1gJoRDnPE5aAj1MT8EkbvALDznhozab",
"QmV3Ve4Nkb1oUYMYe9wy2LyKrLDuKVfRYpyn2B9Zcp4Wy1",
"QmSNYxRV7EJ2a1tn7ruECmgM81T2wLcVGT4QDevmx4DqTq",
"QmZrbQxio4zittbiw9ShfL3zq9anf9aJuHGd3v3Cpid8Cp",
"QmZ77c93fjS2DgBC5LYNNcZimiRoRiujtcYJFEzmwM7TYM",
"QmcHr13jsaBQJWhVXkhWYZcrXtfKhFyLPkztAEg1PEgatu",
"QmVuo6qaor3SXCpvjVJ8WLMzVzGcUDzoBWXFZXPz3KaxTf",
"QmdsWzHQuUH7foCbc8Vzh7sjv1Yq1BDekhBLD4i2TgWHDD",
"QmZtxZVaVeZUR6SLS2xcSwXBRQAeQea4s2FqazAKycKRX8",
"QmczvjeVDJZQ2egx6ZuaUyyhsXxzTAyncGvm8KkTAQcUun",
"QmTqhywJDQ5ypoiaS3MpcqXq3DQs3yfyMQRLXy8fVRevSm",
"QmZ1D7pWhQuzzeFNf13wvmSER3W3gpk4amEwPmc33FqbBm",
"QmRd727ZSnBDKCEheySgvHGeEdv71jcgMVkCBPJCzi9NWH",
"QmauJaN7RPo7nAnsSHuKNCqpCSLMdBKPzq6ZEPxjyB7wY2",
"QmSJn5QUorBF1WDqpw7iPvL7rUmL3Y3zoatsSA3YUWeMLo",
"QmQBTYPG5kyuBHn1G3e1Z4K7sdGDbVpPnkYZL6Uw6QLHpb",
"QmXCKGkBuqgEDdF8ufbZLYffEr6ZETRMLqzY2yNJCZfeVM",
"QmbTsMEKtPAruHKmvXXu38tJjoJ7vkns6THMRojiXWPDLe",
"QmZYru5rEbJFhjXHz5KzKHScjsjTFUkymvGXQVBA56rjPi",
"QmUb46u7GuAfdhpL4qVkLme5NBSvmLmAKCN4FiEbgRjtbe",
"QmV9ci7KUpvxjKjEatbyfh17YCkGV4StyWTnDupvPKcC3F",
"QmVjf7k1j33yW6UQnNNXXAD6uc3RuHV1NCU7cuFHRJMn8A",
"QmNfERi5y28Qdc2vzvMADpYmkPKLpLNY3eSqwJ9Gyej4wy",
"Qme371atif5bQ7i9HGoAQT2xv9MZyHvquHNbJN5EbW8nPn",
"QmT3pb9ig9Hcbf4Z6Sv74rc7RcKBawt3quGvEPk25mjmFB",
"QmNaXPc8Hk5g8BjyD4anj8Cn5z41bgWqpnBjvzYKPXHpLr",
"QmVZDbg3wG8u3khpvJv7wA9ooPm4F7q2vmxWXSz7KgDTsZ",
"QmSG4fBjqzPPruYpaHPWkEtAFnnspjpWSboBcA5jdvxKsJ",
"QmR7pDedkzSFu5U69jKzy4QHc7LZc6SaFdiMojCDKuX6CB",
"QmPMNwbs3JqVNMFY5gusRxG8SbnhXAbVCr8hwGeviXQwtr",
"QmQGpQAr2MB6aiDDG1iNUA3CFAUV6XHCwmpAVuA31AwDqA",
"QmVFNFCoygESyFJeeutE5Eo3Y8vMC3QyzUWBACx5sHZRDB",
"QmfWnT6sYMmMMNzgcSKwaU1efUN1nht5XLxHueRHVLb6Rt",
"QmQdz5m6ohNibWSb9Q2Tx7X2LngkUJ9e7HS7tpoS381YVZ",
"Qmcmxys6gNfzi4pGXk4ZwRxvF1JyPoshipCEogKaZ67bgx",
"QmeJs3SJ9pQLUuPQx9BbHVmvfh52zx45wtLaTNGCq4Pa67",
"QmTmiP5ui2SLV1qN5Ss64R4UMLj27526mWmygugsDYaYxj",
"QmapEKZC5B1zN7iTGpjMmfzvmrBsi8VezMZSBxdArPEdsn",
"QmRuX3NQFvihXCcC56oHhmEi8aF5Q8zATqKg5wYMNS8bfF",
"QmPedwQHr3hhsaZPWu5XKw8wdokSkSMum7uebogYJxm7Jr",
"QmYQgFGAN83XjBuAdRcD3McayQGHBCAsqR9CbFnBddvp7Q",
"QmeRWoqFP89KDfbM43L94aeQhURaJ4mmJ13AhYNuWku4sN",
"QmePNeDd44SD5PxEQitpdV4PfwFsRbduLbCRbYv4MXaXDZ",
"QmdpajgoTiy8HSB553KhVgoVM6tgsmYrpJkZ3LwaZaEPUd",
"QmUFaapA1mttwQE8npdP7GiNNkSwJtRG517kW94Fm7Y3Tc",
"QmTtoETGHALDQNgNjwEu5LBBCgyHBnnRVjKCf42HdWN657",
"QmWSpSxcJSfmAenFADMBxqqPGToS2Vx1gZtYtYvmavyfjt",
"QmaxAYEixdXfW8i14aK6QaMCzK1BuXpwPgc4yq4NbRiy8W",
"QmXFK8KPRqgvpMHZHTK6NwEznAtaatsHJ1XZKcDMu43KpR",
"QmQyqikeBJ5pEginWiTtvrLz2FmUAupVz1RP6yPEsdk4jA",
"QmSpfLWac5Rr3gEFYx3PeL6F7gi8CKJEcJ3nqCdESeRBfK",
"QmW6z8fVVitFU7ryrdggnjthwrWWMdcCR9nsoby28NJWpX",
"QmfAPmCpm9hv4BifxbSVq7eYixLX5Ye4UA4GSipbrdW1wd",
"Qma4Uv5iX9s4dJaADp3MRoYJDs6y7788Ww3B4uA4FscfS2",
"QmQXerGsyMXFE2GVQw1EmzVoSfKUfjZ2A2XP4J8u5drv4E",
"QmdLEkEgaKUPWrTUTqvYn7oTKoYQ3nnGTb4QzHGzwLvKEZ",
"QmQrY7h3qwsCVb9Gb1pJvGmh5vTvTWdPaWoriNviu1iR3Z",
"QmZjevaC42EAC6hBUvTTDxPwyGRX8Peni1WGELnitE7CQr",
"QmYNEBSEhibKJYJUdcaPfeivSVmVAgUgb7kAPcEKMfg43j",
"QmXktRYwzRxuuuDALjMzpMgSQWKaLmVC8m7Yk85dnJQfdx",
"QmceGxXy7Ydo9hBFk3zfCTBYSLEDnA51KTuypjWDewHmUz",
"QmaWwuz1UgYpChsobfdtUfAZDg8tvVPhJoB27zoWQ8w2sw",
"Qme4DLrG9QfpxDNxuvaNqsYEJKCMe5a5aZkKRb5AyAQTBw",
"QmNcBiSbHfjfHithvfVze1KwdNnsNDCAkHFDf6kc6fQvQM",
"QmYm7S48j3EsRKq7gtnKvCocZTDXTicN38zXUhBUCKEup6",
"QmW5BU4QfSwbhuScUbGDqMXDo7DkoRHHbfQfmF4Lh6WXai",
"QmUEagTLBayDf8mLe2xXLCm9wxXGFjvFx6oNPAuBj61ffA",
"QmXfjGV6LUymdohAyY4P3KbXowFaVswcJ8Pi4zW1yq68p7",
"QmfBJaEK7MsBZ3AFvdQpbZUBBQf4qKduaBnc4VCnsDrvL6",
"QmRqZ6YXJ7caEh4mpDkj4jsBWoqTTMYXvPFY2WvSJxncQe",
"QmcUQU6E9be46hPGdGnv6L91hsWcvVCkanJ7nwWC33urQm",
"QmUDBe2WwMR4xa6Q9Daj29mNNNEiyct7oDZWt2kjSJiQsw",
"QmfH7iM5yaeG4iy2SdEN3ncSr7Qj6oZAt82tsuikXbGu2N",
"Qme5E6zTTq7imn68R8xpcfBM7L3qH1QAbcD4gAKiBMAZrv",
"QmQwzcQGFoFDeN5TKKvNoiriaNFxpe7H53DHvijU4hswrQ",
"QmZfqzCxJrJjePqsKSWX1BwN2owp2SqisSMgW4z8Ab1xUm",
"QmcriD2wZAwgphUbaX1tBk8J6swG41pRJt3Kj4kdJ6r6or"];

  string private _baseURI = "https://ipfs.io/ipfs/";

  string private constant _contractURI = "https://ipfs.io/ipfs/QmXgAWQ3mUexm4Jctfc5x7S6rbCaueEaZnxKsegemUjfac";

  IKlein public immutable Klein;

  address public proxyRegistryAddress;

  constructor(address _IKBAddress, address _proxyRegistryAddress)
    ERC721("WrappedIKB", "wIKB")
    Ownable()
    public
  {
    Klein = IKlein(_IKBAddress);
    proxyRegistryAddress = _proxyRegistryAddress;
  }

  /**************************************************************************
   * Opensea-specific methods
   *************************************************************************/

  function contractURI() external view returns (string memory) {
      return _contractURI;
  }

  /**
   * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
   */
  function isApprovedForAll(address owner, address operator)
    public
    override
    view
    returns (bool)
  {
    // Whitelist OpenSea proxy contract for easy trading.
    ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
    if (address(proxyRegistry.proxies(owner)) == operator) {
        return true;
    }

    return super.isApprovedForAll(owner, operator);
  }

  /**************************************************************************
    * ERC721 methods
    *************************************************************************/

  /**
  * @dev Returns the base URI set via {_setBaseURI}. This will be
  * automatically added as a prefix in {tokenURI} to each token's URI, or
  * to the token ID if no specific URI is set for that token ID.
  */
  function baseURI() public view override returns (string memory) {
      return _baseURI;
  }

  /**
    * @dev Allows owner to set `_baseURI`
  */
  function setbaseURI(string memory baseURI_) public onlyOwner {
    _setBaseURI(baseURI_);
  }

  /**
   * @dev `tokenURIs` is private but it's helpful for owner to check the
   * `tokenURI` of a `tokenId` when `tokenId` is not minted yet by its owner.
  */
  function tokenIPFSHash(uint256 tokenId_) public view returns(string memory){
    return _tokenIPFSHashes[tokenId_];
  }

  /**
   * @dev Modifies Open Zeppelin's `tokenURI()` to read from `_tokenIPFSHashes`
   * instead of `_tokenUris`
   */
  function tokenURI(uint256 tokenId) public view override returns (string memory) {
      require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

      string memory _tokenURI = _tokenIPFSHashes[tokenId];
      string memory base = baseURI();

      return string(abi.encodePacked(base, _tokenURI));
  }


  /**************************************************************************
   * WrappedIKB-specific methods
   *************************************************************************/

  /**
   * @dev Uses `transferFrom` to transer all IKB Tokens from `msg.sender` to
   * this wrapper. Once the wrapper owns all editions, it mints new tokens with
   * the same `id` and sets `msg.sender` as the owner.
   *
   * Requirements:
   *
   * - All IKB tokens owned by `msg.sender` must be allowed to be transfered by WrappedIKB.
   *   To do this, call `approve()` with the address of WrappedIKB and the current
   *   balance of the owner
  */
  function wrapAll() public returns (bool){
    uint256[] memory ownedRecords = Klein.getHolderEditions(_msgSender());
    uint ownedRecordsLength = ownedRecords.length;

    require(Klein.allowance(_msgSender(),address(this)) >= ownedRecordsLength, "WrappedIKB: must approve all IKB tokens to be transfered");

    require(Klein.transferFrom(_msgSender(),address(this), ownedRecordsLength), "WrappedIKB: IKB Token did not transferFrom");

    for (uint i = 0; i < ownedRecordsLength; i++){
      _safeMint(_msgSender(), ownedRecords[i]);
    }

    return true;
  }

  /**
   * @dev Uses `specificTransferFrom` to transer specific a IKB Token edition from
   * `msg.sender` to this wrapper. Once the wrapper owns the specified edition,
   *  it mints new tokens with
   * the same `id` and sets `msg.sender` as the owner.
   *
   * Requirements:
   *
   * - None. There is no way to check if the IKB contract allows a specific transfer.
   *   The transfer will fail on the IKB contract `specificApprove()` is not called
   *   with the correct edition.
  */
  function wrapSpecific(uint edition) public {
    require(Klein.specificTransferFrom(_msgSender(), address(this), edition), "WrappedIKB: IKB Token did not specificTransferFrom");
    _safeMint(_msgSender(), edition);
  }

  /**
   * @dev Transfers the specified IKB token editions back to `msg.sender`
   * and burns the corresponding WrappedIKB tokens
   *
   * Requirements:
   *
   * - `msg.sender` must be the owner of the WrappedIKB tokens
  */
  function unwrapSpecific(uint tokenId) public{
    require(ownerOf(tokenId) == _msgSender(), "WrappedIKB: Token not owned by sender");
    require(Klein.specificTransfer(_msgSender(), tokenId), "WrappedIKB: Token transfer failed");
    burn(tokenId);
  }

  /**
   * @dev Convenience function transfers all IKB token editions back to
   * `msg.sender` and burns the corresponding WrappedIKB tokens.
   * See `unwrapSpecific()` for implementation.
  */
  function unwrapAll() public{
    uint256 balance = balanceOf(_msgSender());

    uint[] memory tokenIds = new uint[](balance);

    for (uint256 i = 0; i < balance; i++){
      tokenIds[i] = (tokenOfOwnerByIndex(_msgSender(), i));
    }
    for (uint256 i = 0; i < balance; i++){
      unwrapSpecific(tokenIds[i]);
    }
  }



}