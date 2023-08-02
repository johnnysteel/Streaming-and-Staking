// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract StreamingAndStaking {
    // Contract owner
    address private owner;

    // Pay period duration
    uint256 public period = 30 days;

    // Time of the last mint
    uint256 public lastMintTime;

    // Total token supply
    uint256 public totalSupply;

    // Maximum token supply limit
    uint256 public maxSupply = 10000;

    // Tax rate for transfers
    uint256 public taxRate = 2; // 2% tax

    // Mapping to track the start date for streaming
    mapping(address => uint256) private startDate;

    // Mapping to store employee salaries
    mapping(address => uint256) private salary;

    // Mapping to track balances of each address
    mapping(address => uint256) private balances;

    // Mapping to track staked amounts
    mapping(address => uint256) private stakes;

    // Array to keep track of stakers
    address[] private stakers;

    // Modifier to restrict certain functions to only the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    // Constructor
    constructor() {
        owner = msg.sender;
        lastMintTime = block.timestamp;
    }

    // Function to get the balance of an address
    function getBalance(address _account) public view returns (uint256) {
        return balances[_account];
    }
    
    // Function to initiate a pay cycle for an employee
    function initiatePayCycle(address _employee, uint256 _salary) public onlyOwner {
        startDate[_employee] = block.timestamp;
        salary[_employee] = _salary;
    }
    
    // Function to calculate the balance of an address based on the streaming mechanism
    function balanceOf(address _account) public view returns (uint256) {
        uint256 fullSalary = salary[_account];
        uint256 secondsPassed = block.timestamp - startDate[_account];
        return fullSalary * (secondsPassed / period);
    }
    
    function getStartDate(address _employee) public view returns (uint256) {
        return startDate[_employee];
    }
    
    function getSalary(address _employee) public view returns (uint256) {
        return salary[_employee];
    }
    
    // Function to withdraw earned salary
    function withdrawSalary() public {
        uint256 earnedSalary = balanceOf(msg.sender); // Calculate earned salary
        require(earnedSalary > 0, "No salary earned yet"); // Ensure there's something to withdraw
        balances[msg.sender] -= earnedSalary; // Deduct the earned salary from the balance
        // Transfer the deducted amount to the employee's address
        payable(msg.sender).transfer(earnedSalary);
    }
    
    // Function for the owner to pay employees
    function pay(address _to, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Amount must be greater than 0");
        balances[_to] += _amount;
    }
    
    // Function to change the salary of an employee
    function changeSalary(address _employee, uint256 _newSalary) public onlyOwner {
        require(_newSalary > 0, "Salary must be greater than 0");
        salary[_employee] = _newSalary;
    }

    // Function to calculate pending earnings for an employee
    function getPendingEarnings(address _employee) public view returns (uint256) {
        uint256 fullSalary = salary[_employee];
        uint256 secondsPassed = block.timestamp - startDate[_employee];
        return fullSalary * (secondsPassed / period) - balances[_employee];
    }

    // Function for an employee to stake tokens
    function stake(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        uint256 interest = (_amount * 10) / 100; // 10% interest
        stakes[msg.sender] += _amount + interest;
        startDate[msg.sender] = block.timestamp;
        stakers.push(msg.sender); // Add to stakers array
    }

    function getStakes(address _staker) public view returns (uint256) {
        return stakes[_staker];
    }

    // Function for an employee to unstake tokens
    function unstake() public {
        uint256 stakedAmount = stakes[msg.sender];
        require(stakedAmount > 0, "No stakes to withdraw");
        uint256 stakingPeriod = 1 weeks; // 1 week staking period
        require(block.timestamp >= startDate[msg.sender] + stakingPeriod, "Staking period not over yet");
        uint256 interest = (stakedAmount * 10) / 100; // 10% interest
        balances[msg.sender] += stakedAmount + interest;
        stakes[msg.sender] = 0;
        removeStaker(msg.sender); // Remove from stakers array
    }

    // Function to get the staked amount of an address
    function getStakedAmount(address _staker) public view returns (uint256) {
        return stakes[_staker];
    }

    // Function for token transfer with tax
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        uint256 taxAmount = (_amount * taxRate) / 100;
        uint256 afterTaxAmount = _amount - taxAmount;
        balances[msg.sender] -= _amount;
        balances[_to] += afterTaxAmount;
    }

    // Function for token transfer from one address to another with tax
    function transferFrom(address _from, address _to, uint256 _amount) public {
        require(balances[_from] >= _amount, "Insufficient balance");
        require(_from != address(0), "Invalid address");
        uint256 taxAmount = (_amount * taxRate) / 100;
        uint256 afterTaxAmount = _amount - taxAmount;
        balances[_from] -= _amount;
        balances[_to] += afterTaxAmount;
    }
    
    // Function to set the tax rate
    function setTaxRate(uint256 _newTaxRate) public onlyOwner {
        require(_newTaxRate <= 100, "Tax rate must be 100 or less");
        taxRate = _newTaxRate;
    }
    
    // Function to mint new tokens
    function mint(address _recipient, uint256 _amount) public onlyOwner {
        require(totalSupply + _amount <= maxSupply, "Max supply exceeded");
        balances[_recipient] += _amount;
        totalSupply += _amount;
    }

    // Function to mint tokens over time
    function mintTokensOverTime() public onlyOwner {
        require(block.timestamp >= lastMintTime + period, "Minting not allowed yet");
        uint256 timePassed = block.timestamp - lastMintTime;
        uint256 newTokens = (totalSupply * timePassed) / period;
        mint(owner, newTokens);
        lastMintTime = block.timestamp;
    }

    // Function to mint tokens based on time passed
    function mintTokensByTimePassed() public onlyOwner {
        uint256 timePassed = block.timestamp - lastMintTime;
        uint256 newTokens = (totalSupply * timePassed) / period;
        mint(owner, newTokens);
        lastMintTime = block.timestamp;
    }

    // Function to mint tokens based on elapsed time
    function mintTokensByElapsedTime(uint256 _elapsedTime) public onlyOwner {
        uint256 newTokens = (totalSupply * _elapsedTime) / period;
        mint(owner, newTokens);
    }

    // Function to fast forward time for testing purposes
    function fastForwardTime(uint256 _seconds) public onlyOwner {
        require(_seconds > 0, "Time must be greater than 0");
        lastMintTime += _seconds;
        for (uint256 i = 0; i < stakers.length; i++) {
            address _staker = stakers[i];
            startDate[_staker] += _seconds;
        }
    }

    // Function to burn tokens from the sender's address
    function burn(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
    }

    // Internal function to remove staker from stakers array
    function removeStaker(address _staker) internal {
        for (uint256 i = 0; i < stakers.length; i++) {
            if (stakers[i] == _staker) {
                stakers[i] = stakers[stakers.length - 1];
                stakers.pop();
                break;
            }
        }
    }
}
