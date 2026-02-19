// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

// Interface for ERC20 token standard
interface ERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract SaveERC20_and_Ether {
    mapping(address => uint256) public etherBalances;
    
    // Mapping to track ERC20 token balances for each user for each token
    mapping(address => mapping(address => uint256)) public tokenBalances;

    event EtherDeposited(address indexed user, uint256 amount);
    event EtherWithdrawn(address indexed user, uint256 amount);
    event TokenDeposited(address indexed user, address indexed token, uint256 amount);
    event TokenWithdrawn(address indexed user, address indexed token, uint256 amount);
    

    function depositEther() external payable {
        require(msg.value > 0, "Cannot deposit zero ether");
        etherBalances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }
    
    // Withdraw ether from the contract
    function withdrawEther(uint256 _amount) external {
        require(etherBalances[msg.sender] >= _amount, "Insufficient ether balance");
        require(_amount > 0, "Cannot withdraw zero amount");
        
        etherBalances[msg.sender] -= _amount;
        
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Ether transfer failed");
        
        emit EtherWithdrawn(msg.sender, _amount);
    }
    
    // Check user's ether balance
    function getEtherBalance(address _user) external view returns (uint256) {
        return etherBalances[_user];
    }
    
    // Get contract's ether balance
    function getContractEtherBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    function depositToken(address _token, uint256 _amount) external {
        require(_token != address(0), "Invalid token address");
        require(_amount > 0, "Cannot deposit zero tokens");
        
        // Check user's token balance
        require(ERC20(_token).balanceOf(msg.sender) >= _amount, "Insufficient token balance");
           bool success = ERC20(_token).transferFrom(msg.sender, address(this), _amount);
        require(success, "Token transfer failed");
        
        tokenBalances[msg.sender][_token] += _amount;
        emit TokenDeposited(msg.sender, _token, _amount);
    }
    
    // Withdraw ERC20 tokens from the contract
    function withdrawToken(address _token, uint256 _amount) external {
        require(_token != address(0), "Invalid token address");
        require(_amount > 0, "Cannot withdraw zero tokens");
        require(tokenBalances[msg.sender][_token] >= _amount, "Insufficient token balance");
        
        tokenBalances[msg.sender][_token] -= _amount;
        
        bool success = ERC20(_token).transfer(msg.sender, _amount);
        require(success, "Token transfer failed");
        
        emit TokenWithdrawn(msg.sender, _token, _amount);
    }
    
    // Check user's token balance for a specific token
    function getTokenBalance(address _user, address _token) external view returns (uint256) {
        return tokenBalances[_user][_token];
    }
    
    // Get contract's token balance for a specific token
    function getContractTokenBalance(address _token) external view returns (uint256) {
        return ERC20(_token).balanceOf(address(this));
    }
   
    receive() external payable {
        require(msg.value > 0, "Cannot send zero ether");
        etherBalances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }
    
    // Fallback function for handling unexpected calls
    fallback() external payable {
        require(msg.value > 0, "Cannot send zero ether");
        etherBalances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }
}
