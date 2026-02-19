// SPDX-License-Identifier: MIT
// Declares the license type for this contract (MIT is permissive and common)
pragma solidity ^0.8.33;
// Specifies the Solidity compiler version (0.8.33 or compatible)

// Define the Token smart contract
contract Token {
    
    // Define a struct to hold basic token metadata
    struct TokenNeeds {
        string name;     // Token name (e.g., "MyToken")
        string symbol;   // Token symbol (e.g., "MTK")
        uint8 decimal;   // Number of decimal places (e.g., 18)
    }

    // Public state variable of type TokenNeeds (stored in storage)
    // Solidity automatically creates a getter for this
    TokenNeeds public token;

    // Total supply of tokens (stored in storage)
    uint public totalSupply;
    
    // Mapping that stores balances for each address
    // balances[address] => amount of tokens owned
    mapping(address => uint) public balances;

    // Nested mapping for allowances
    // allowance[owner][spender] => amount spender is allowed to spend
    mapping(address => mapping(address => uint)) public allowance;

    // Event emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event emitted when an approval is made
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Constructor runs once at deployment
    constructor(
        string memory _name,       // Token name passed at deployment
        string memory _symbol,     // Token symbol passed at deployment
        uint8 _decimal,            // Decimal places
        uint _totalSupply          // Initial supply before decimals
    ) {
        // Set token name
        token.name = _name;

        // Set token symbol
        token.symbol = _symbol;

        // Set token decimals
        token.decimal = _decimal;

        // Calculate total supply with decimals applied
        totalSupply = _totalSupply * (10 ** _decimal);
        
        // Assign all tokens to the contract deployer
        balances[msg.sender] = totalSupply;
    }

    // Returns the token name
    function getterName() public view returns (string memory) {
        return token.name;
    }
    
    // Returns the token symbol
    function getterSymbol() public view returns (string memory) {
        return token.symbol;
    }
    
    // Returns the token decimals
    function getterDecimal() public view returns (uint8) {
        return token.decimal;
    }
    
    // Returns the total token supply
    function getTotalSupply() public view returns (uint) {
        return totalSupply;
    }

    // Returns the balance of a given address
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    // Transfer tokens from the caller to another address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // Prevent sending tokens to the zero address
        require(_to != address(0), "Cannot send to zero address");

        // Ensure sender has enough tokens
        require(balances[msg.sender] >= _value, "Insufficient balance");
        
        // Subtract tokens from sender
        balances[msg.sender] -= _value;

        // Add tokens to recipient
        balances[_to] += _value;
        
        // Emit Transfer event for off-chain tracking
        emit Transfer(msg.sender, _to, _value);

        // Indicate successful transfer
        return true;
    }

    // Approve another address to spend tokens on your behalf
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // Prevent approving the zero address
        require(_spender != address(0), "Cannot approve zero address");
        
        // Set allowance for spender
        allowance[msg.sender][_spender] = _value;
        
        // Emit Approval event
        emit Approval(msg.sender, _spender, _value);

        // Indicate successful approval
        return true;
    }

    // Transfer tokens using an allowance
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // Ensure source address is valid
        require(_from != address(0), "Cannot transfer from zero address");

        // Ensure destination address is valid
        require(_to != address(0), "Cannot transfer to zero address");

        // Ensure source has enough balance
        require(balances[_from] >= _value, "Insufficient balance");

        // Ensure caller is allowed to spend this amount
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        
        // Deduct tokens from source
        balances[_from] -= _value;

        // Add tokens to destination
        balances[_to] += _value;

        // Reduce remaining allowance
        allowance[_from][msg.sender] -= _value;
        
        // Emit Transfer event
        emit Transfer(_from, _to, _value);

        // Indicate successful transfer
        return true;
    }
}
