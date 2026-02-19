// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract SchoolManagement {
    
    address public owner;
    
    // Student info
    struct Student {
        string name;
        uint8 level; 
        bool paid;
        uint256 paidAt;   
    }
    
    // Staff info
    struct Staff {
        string name;
        uint256 salary;
    }
    
    // Storage
    mapping(uint8 => uint256) public fees;    
    mapping(address => Student) public students;    
    mapping(address => Staff) public staffs;      
    
    address[] public allStudents;
    address[] public allStaffs;
    
    // Events (for tracking)
    event StudentAdded(address student, string name, uint8 level);
    event FeePaid(address student, uint256 amount);
    event StaffAdded(address staff, string name);
    event SalaryPaid(address staff, uint256 amount);
    
    constructor() {
        owner = msg.sender;
        
        // Set fees (you can change these)
        fees[100] = 1 ether;
        fees[200] = 2 ether;
        fees[300] = 3 ether;
        fees[400] = 4 ether;
    }
    
    // Only owner can call
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    // Register student + pay fee in one step
    function registerStudent(string memory _name, uint8 _level) public payable {
        require(_level == 100 || _level == 200 || _level == 300 || _level == 400, "Bad level");
        require(bytes(students[msg.sender].name).length == 0, "Already registered");
        require(msg.value == fees[_level], "Wrong fee");
        
        students[msg.sender] = Student(_name, _level, true, block.timestamp);
        allStudents.push(msg.sender);
        
        emit StudentAdded(msg.sender, _name, _level);
        emit FeePaid(msg.sender, msg.value);
    }
    
    // Owner adds staff
    function addStaff(address _staff, string memory _name, uint256 _salary) public onlyOwner {
        require(bytes(staffs[_staff].name).length == 0, "Already exists");
        
        staffs[_staff] = Staff(_name, _salary);
        allStaffs.push(_staff);
        
        emit StaffAdded(_staff, _name);
    }
    
    // Owner pays staff
    function paySalary(address _staff) public onlyOwner {
        require(bytes(staffs[_staff].name).length > 0, "Staff not found");
        require(address(this).balance >= staffs[_staff].salary, "Not enough money");
        
        payable(_staff).transfer(staffs[_staff].salary);
        emit SalaryPaid(_staff, staffs[_staff].salary);
    }
    
    // Pay fee if you forgot
    function payFee() public payable {
        require(bytes(students[msg.sender].name).length > 0, "Not registered");
        require(!students[msg.sender].paid, "Already paid");
        require(msg.value == fees[students[msg.sender].level], "Wrong amount");
        
        students[msg.sender].paid = true;
        students[msg.sender].paidAt = block.timestamp;
        
        emit FeePaid(msg.sender, msg.value);
    }
    
    // Get all student addresses
    function getStudents() public view returns (address[] memory) {
        return allStudents;
    }
    
    // Get all staff addresses
    function getStaffs() public view returns (address[] memory) {
        return allStaffs;
    }
    
    // Change fee (owner only)
    function changeFee(uint8 _level, uint256 _newFee) public onlyOwner {
        fees[_level] = _newFee;
    }
    
    // Check school money
    function balance() public view returns (uint256) {
        return address(this).balance;
    }
    
    // Owner withdraws money
    function withdraw(uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Not enough");
        payable(owner).transfer(_amount);
    }
}
