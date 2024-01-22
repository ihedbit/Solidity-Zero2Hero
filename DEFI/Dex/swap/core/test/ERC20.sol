pragma solidity =0.5.16;

import '../WingswapERC20.sol';

contract ERC20 is WingswapERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
