pragma solidity >= 0.5.0 < 0.6.0;

// ----------------------------------------------------------------------------
// SafeMat library
// ----------------------------------------------------------------------------
library SafeMath {
  /** @dev Multiplies two numbers, throws on overflow.*/
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {return 0;}
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }

  /** @dev Integer division of two numbers, truncating the quotient.*/
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

  /**@dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).*/
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

  /** @dev Adds two numbers, throws on overflow.*/
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

}

contract application{
    function arbitrate(bytes memory data) public returns(address[2] memory, uint256[2] memory);
}







contract mulisig {
    
    using SafeMath for uint256;
    
    address[] public owners;
    mapping(address => bool) public isOwner;
    mapping(address => uint256) public balances;
    application App;
    
    constructor() public payable{
        owners.push(msg.sender);
        balances[msg.sender] = msg.value;
        isOwner[msg.sender] = true;
    }
    

    function adjudicate(address appAddress, bytes calldata data) external {
        App = application(appAddress);
        (address[2] memory users, uint256[2] memory values) = App.arbitrate(data);
        transfer(users[0], users[1], values[0]);
        transfer(users[1], users[0], values[1]);
    }
    
    
    function transfer(address to_, address from_, uint256 amount) internal {
        require(isOwner[to_]);
        require(isOwner[from_]);
        balances[from_] = balances[from_].sub(amount);
        balances[to_] = balances[to_].add(amount);
    }
    

    function () payable external{
        if(isOwner[msg.sender]) {
            balances[msg.sender] = balances[msg.sender].add(msg.value);
        } else{
            owners.push(msg.sender);
            balances[msg.sender] = msg.value;
            isOwner[msg.sender] = true;
        }
    }
    
    function withdraw() external {
        /* To be implemented */
    }
    
}