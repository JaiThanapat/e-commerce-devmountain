// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ProductERC20.sol";

contract ProductDeployERC20 is Ownable{
    address[] public productERC20Addresses;
    mapping(address => address) public productERC20OwnerAddresses; // ERC20 address ===> externally owned account (EOA)
    mapping(address => uint256) public productERC20ValueAddresses; // ERC20 address ===> value of token (Ex. 1x10^18 = 1THB)
    mapping(address => uint256) public productERC20AmountAddresses; // ERC20 address ===> amount of product (Ex. 1x10^18 = 1THB)

    event DeployProductERC20(address indexed deployer, address indexed tokenAddress, string name, string symbol, uint256 amount, uint256 indexed timestamp);
    event OrderReceipt(address indexed deployer, address indexed tokenAddress, uint256 totalPrice, uint256 amount, uint256 indexed timestamp);
    
    function deployERC20Token(string memory name, string memory symbol, uint256 amount, uint256 value) 
    external returns(bool) {
        ProductERC20 erc20Token = new ProductERC20(msg.sender,name, symbol, amount);
        productERC20Addresses.push(address(erc20Token));
        productERC20OwnerAddresses[address(erc20Token)] = msg.sender; 
        productERC20ValueAddresses[address(erc20Token)] = value; 
        productERC20AmountAddresses[address(erc20Token)] = amount; 
        emit DeployProductERC20(msg.sender, address(erc20Token), name, symbol, amount, block.timestamp);
        return true;
    }

    function getProductERC20AddressesLength() external view returns(uint256){
        return productERC20Addresses.length;
    }

    function getProductDetail(address productContract) public view returns(string memory,string memory){
        return (ProductERC20(productContract).name()
        ,ProductERC20(productContract).symbol()); 
    }

    function buyProduct(address to,address productContract , uint amount_) public payable returns (bool){
        require(msg.value == getTotalPrice(productContract,amount_),"Not Enough Balance");
        require(checkStock(productContract,amount_),"Out of Stock");
        payable(to).transfer(msg.value);
        productERC20AmountAddresses[address(productContract)] -= amount_;
        emit OrderReceipt(msg.sender , productContract,getTotalPrice(productContract,amount_),amount_,block.timestamp);
        return true;
    }

    function setPrice(address productContract,uint256 price_) public onlyOwner{
        productERC20ValueAddresses[address(productContract)] = price_; 
    }

    function AddAmount(address productContract,uint amount_) public onlyOwner{
        productERC20AmountAddresses[address(productContract)] += amount_;
    }

    function getPrice(address productContract) public view returns (uint256){
        return productERC20ValueAddresses[address(productContract)];
    }

    function getAmount(address productContract) public view returns (uint256){
        return productERC20AmountAddresses[address(productContract)];
    }

    function getTotalPrice(address productContract,uint amount_) public view returns (uint256) {
        return amount_ * (getPrice(productContract) * 10 ** 18);
    }

    function checkStock(address productContract,uint amount_) public view returns (bool) {
        return amount_ <= productERC20AmountAddresses[address(productContract)];
    }

   
}