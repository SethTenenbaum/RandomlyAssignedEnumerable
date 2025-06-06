// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WithLimitedSupply.sol";

/// @author 1001.digital
/// @title Randomly assign tokenIDs from a given set of tokens.
abstract contract RandomlyAssigned is WithLimitedSupply {
    // Used for random index assignment
    mapping(uint256 => uint256) private tokenMatrix;

    // The initial token ID
    uint256 private startFrom;

    /// Instanciate the contract
    /// @param _totalSupply how many tokens this collection should hold
    /// @param _startFrom the tokenID with which to start counting
    constructor (uint256 _totalSupply, uint256 _startFrom)
        WithLimitedSupply(_totalSupply)
    {
        startFrom = _startFrom;
    }

    /// Get the next token ID
    /// @dev Randomly gets a new token ID and keeps track of the ones that are still available.
    /// @return the next token ID
    function nextToken() internal override ensureAvailability returns (uint256) {
        uint256 maxIndex = availableTokenCount(); // FIXED LINE
        uint256 random = uint256(keccak256(
            abi.encodePacked(
                msg.sender,
                block.coinbase,
                block.prevrandao,
                block.gaslimit,
                block.timestamp
            )
        )) % maxIndex;

        uint256 value = 0;
        if (tokenMatrix[random] == 0) {
            value = random;
        } else {
            value = tokenMatrix[random];
        }

        if (tokenMatrix[maxIndex - 1] == 0) {
            tokenMatrix[random] = maxIndex - 1;
        } else {
            tokenMatrix[random] = tokenMatrix[maxIndex - 1];
        }

        super.nextToken();

        return value + startFrom;
    }
}
