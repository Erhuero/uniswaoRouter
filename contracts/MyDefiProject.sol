pragma solidity ^0.8.6;
//SPDX-License-Identifier:UNLICENSED

//interface for a router contract
interface IUniswap{
function swapExactTokensForETH(
        uint amountIn, 
        uint amountOutMin, 
        address[] calldata path, 
        address to, 
        uint deadline)
        external
        
        returns (uint[] memory amounts);
        //reach the address ow wrapped ether
        function WETH() external pure returns (address);
}

interface IERC20{
    //from openZeppelin
      function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    
    function approve(address spender, uint256 amount) external returns (bool);
}

contract MyDefiProject{
    //pointer to Uniswap
    IUniswap uniswap;
    
    constructor(address _uniswap){
        uniswap = IUniswap(_uniswap);
        
    }
    
    //able exvhange tokens by uniswap
    function swapTokensForEth(
        address token,
        //amount of token we provide in input or spend
        uint amountIn,
        //minimum amount of ether we want 
        uint amountOutMin,
        //deadline when the trade is not valid anymore
        uint deadline)
        external {
            //move tokens from the sending address to the address of this smart contract
            //before calling the function we call a approve on ERC20 token we want to send
            IERC20(token).transferFrom(msg.sender, address(this), amountIn);
            //array of addresses of length 2
            address[] memory path = new address[](2);
            path[0] = token;
            path[1] = uniswap.WETH();
            //operation need to approve uniswap to spend our token
            //not gonna work unless we approve it
            IERC20(token).approve(address(uniswap), amountIn);
            uniswap.swapExactTokensForETH(
                //first argument 
                amountIn,
                amountOutMin,
                path,
                //send direct to the sender and not stay in the contract
                msg.sender,
                deadline
                );
        }
    
    
}






















