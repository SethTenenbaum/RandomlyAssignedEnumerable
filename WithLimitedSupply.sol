// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/// @author 1001.digital
/// @title A token tracker that limits the token supply and increments token IDs on each new mint.
abstract contract WithLimitedSupply is ERC721Enumerable {
    /// @dev Emitted when the supply of this collection changes
    event SupplyChanged(uint256 indexed supply);

    /// @dev The maximum count of tokens this token tracker will hold.
    uint256 private _maxSupply;

    /// @param maxSupply_ The maximum number of tokens this collection should hold
    constructor(uint256 maxSupply_) {
        _maxSupply = maxSupply_;
    }

    /// @dev Get the total supply
     /// @return The maximum token count
    function totalSupply() public view override returns (uint256) {
        return super.totalSupply(); // Returns the number of tokens minted so far
    }

    /// @dev Get the current token count
    /// @return The number of tokens minted so far
    function tokenCount() public view returns (uint256) {
        return super.totalSupply(); // Use ERC721Enumerable's totalSupply
    }

    /// @dev Check whether tokens are still available
    /// @return The available token count
    function availableTokenCount() public view returns (uint256) {
        return _maxSupply - tokenCount();
    }

    /// @dev Increment the token count and fetch the latest count
    /// @return The next token ID
    function nextToken() internal virtual returns (uint256) {
        require(availableTokenCount() > 0, "No more tokens available");
        return tokenCount() + 1; // Use the next available token ID
    }

    /// @dev Check whether another token is still available
    modifier ensureAvailability() {
        require(availableTokenCount() > 0, "No more tokens available");
        _;
    }

    /// @param amount Check whether the number of tokens is still available
    /// @dev Check whether tokens are still available
    modifier ensureAvailabilityFor(uint256 amount) {
        require(availableTokenCount() >= amount, "Requested number of tokens not available");
        _;
    }

    /// Update the supply for the collection
    /// @param newSupply The new token supply
    /// @dev Create additional token supply for this collection
    function _setSupply(uint256 newSupply) internal virtual {
        require(newSupply > tokenCount(), "Can't set the supply to less than the current token count");
        _maxSupply = newSupply;

        emit SupplyChanged(_maxSupply);
    }
}