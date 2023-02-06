// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import {MarketAPI} from "@zondax/filecoin-solidity/contracts/v0.8/MarketAPI.sol";
import {MarketTypes} from "@zondax/filecoin-solidity/contracts/v0.8/types/MarketTypes.sol";

contract FilecoinDealCertificate is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;

    struct Metadata {
        uint64 dealId;
        bytes data;
        uint64 size;
        uint64 clientActorId;
        uint64 providerActorId;
    }

    mapping(uint256 => Metadata) public metadata;
    mapping(bytes => uint256) public dataToTokenIds;

    constructor() ERC721("FilecoinDealMonsters", "FDM") {}

    function mint(uint64 dealId) public {
        _tokenId.increment();
        uint256 tokenId = _tokenId.current();

        MarketTypes.GetDealDataCommitmentReturn memory dealCommitment = MarketAPI.getDealDataCommitment(dealId);
        require(dataToTokenIds[dealCommitment.data] == 0, "already minted");
        dataToTokenIds[dealCommitment.data] = tokenId;

        uint64 clientActorId = MarketAPI.getDealClient(dealId).client;
        uint64 providerActorId = MarketAPI.getDealProvider(dealId).provider;

        metadata[tokenId] = Metadata(
            dealId,
            dealCommitment.data,
            dealCommitment.size,
            clientActorId,
            providerActorId
        );

        // TODO: Ensure that only those who have made the deal can mint it.

        _mint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        require(_exists(tokenId), "not exists");
        return string.concat(
            'data:application/json,',
            '{',
            '"name":"FilecoinDealCertificate #",', Strings.toString(tokenId),
            '"description":"This is an NFT that proves that a file coin storage deal has taken place.",',
            '"image":"https://i.imgur.com/H3BiGyG.png"',
            '}'
        );
    }
}
