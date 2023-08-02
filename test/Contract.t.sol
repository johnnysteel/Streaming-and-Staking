// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import "ds-test/test.sol";
import "src/fancyERC20.sol"; 

contract StreamingAndStakingTest is DSTest {
    StreamingAndStaking public contractToTest;

    // Set up the contract for testing
    function setUp() public {
        contractToTest = new StreamingAndStaking();
    }

    // Test for the mint function
    function test_mintFunction() public {
        // Set up variables
        address recipient = address(this);
        uint256 amount = 100;
        uint256 initialTotalSupply = contractToTest.totalSupply();
        uint256 initialRecipientBalance = contractToTest.getBalance(recipient);

        // Make the function call
        contractToTest.mint(recipient, amount);

        // Test conditions after the function call
        assertEq(contractToTest.totalSupply(), initialTotalSupply + amount);
        assertEq(contractToTest.getBalance(recipient), initialRecipientBalance + amount);
    }

    // Test for the initiatePayCycle function
    function test_initiatePayCycle() public {
        // Set up variables
        address employee = address(this);
        uint256 salary = 1000;

        // Make the function call
        contractToTest.initiatePayCycle(employee, salary);

        // Test conditions after the function call
        assertEq(contractToTest.getSalary(employee), salary);
        assertEq(contractToTest.getStartDate(employee), block.timestamp);
    }

    function test_stake() public {
        // Set up variables
        uint256 amount = 200;
        address staker = address(this);

        // Mint tokens for the test address
        contractToTest.mint(staker, amount + amount / 10); // Mint enough tokens to cover the stake

        // Make the function call
        contractToTest.stake(amount);

        // Test conditions after the function call
        assertEq(contractToTest.getStakes(staker), amount + amount / 10); // Staked amount + 10% interest
        assertEq(contractToTest.getStartDate(staker), block.timestamp);
    }

    // Test for the transfer function
    function test_transfer() public {
        // Set up variables
        address sender = address(this);
        address recipient = 0x1234567890123456789012345678901234567890;
        uint256 amount = 1000;
            
        // Make the function call
        contractToTest.mint(sender, 1500); // Mint tokens for sender
        uint256 initialSenderBalance = contractToTest.getBalance(sender);
        uint256 initialRecipientBalance = contractToTest.getBalance(recipient);

        // Transfer tokens
        contractToTest.transfer(recipient, amount);

        // Test conditions after the function call
        assertEq(contractToTest.getBalance(sender), initialSenderBalance - amount); // Deducted transfer amount and 2% tax
        assertEq(contractToTest.getBalance(recipient), initialRecipientBalance + amount - (amount / 50));
    }
}
