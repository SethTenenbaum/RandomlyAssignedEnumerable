# RandomlyAssignedEnumerable

## Overview

This project is a **fork of [1001.digital's RandomlyAssigned ERC721 design](https://github.com/1001-digital/erc721-extensions)**, with a key change to improve compatibility with the OpenZeppelin ERC721 standard.

## Key Differences from the Original

- **OpenZeppelin-Compatible `totalSupply()`**  
  In this fork, the `totalSupply()` function now follows the OpenZeppelin ERC721Enumerable definition:  
  > `totalSupply()` returns the number of tokens minted so far (the circulating supply), **not** the maximum supply.
- **Maximum Supply via `_maxSupply`**  
  The maximum number of tokens that can ever be minted is stored in the private variable `_maxSupply`.  
  If you want to expose this value, use a public getter:
  ```solidity
  function maxSupply() public view returns (uint256) {
      return _maxSupply;
  }
  ```
- **Why this change?**  
  The original 1001.digital implementation used `totalSupply()` to mean "maximum supply," which is not compatible with OpenZeppelin's ERC721Enumerable and can cause confusion or integration issues with tools and libraries that expect the OpenZeppelin definition.

## Usage

- Use `totalSupply()` to get the number of tokens minted so far.
- Use `maxSupply()` (or `_maxSupply` internally) to get the maximum number of tokens that can ever be minted.

## Credits

- Forked from [1001.digital/erc721-extensions](https://github.com/1001-digital/erc721-extensions)
- OpenZeppelin ERC721Enumerable standard for supply tracking

## License

MIT