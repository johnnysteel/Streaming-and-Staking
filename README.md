# Jonathan Bissu Open Avenues Final Project 2023

## Streaming and Staking Smart Contract

## Introduction

The Streaming and Staking Smart Contract is a decentralized application (DApp) that showcases the concepts of real-time salary streaming and token staking with interest. This contract enables employees to receive their salary in real-time as they work, eliminating the need to wait for fixed pay periods. Additionally, users can stake their tokens in the contract and earn interest over a specified period.

The project demonstrates the potential of smart contracts in the realm of financial technology, offering insights into how blockchain technology can revolutionize traditional payroll and investment processes.

## Features

- Real-time salary streaming: Employees can initiate a pay cycle and receive their salary in real-time as they work, eliminating the wait for fixed pay periods.

- Token staking with interest: Users can lock up their tokens in the contract for a specific period and earn interest on their staked amount.

- Automated token minting: The contract can mint new tokens over time based on the elapsed time since the last mint, showcasing an automated supply generation mechanism.

- Tax on transfers: A 2% tax is applied to every token transfer, contributing to a decentralized treasury.

- Transparency: The contract provides transparency in tracking total token supply, balances, staked amounts, and earnings.

## Getting Started

1. Clone the repository: `git clone https://github.com/johnnysteel/final-project`
2. Install dependencies: `npm install`
3. Deploy the smart contract: Deploy the smart contract to a blockchain network of your choice.

## Usage

To use the Streaming and Staking Smart Contract:

1. Initiate pay cycles for employees using the `initiatePayCycle` function.
2. Stake tokens with the `stake` function to earn interest.
3. Transfer tokens with the `transfer` function, applying a 2% tax.
4. Monitor earned salaries and pending earnings using `balanceOf` and `getPendingEarnings`.
5. Withdraw earned salaries with the `withdrawSalary` function.
6. Mint new tokens using the `mint` function to increase the token supply.
7. Adjust tax rates and employee salaries using the `setTaxRate` and `changeSalary` functions.
8. Simulate time passage for testing with the `fastForwardTime` function.

## Contributions

Contributions to the project are welcome! If you find any issues or have suggestions for improvements, feel free to open a GitHub issue or submit a pull request.

---

For more details on the functions and usage of the smart contract, please refer to the contract's source code and the provided testing script.

For any inquiries or support, contact Jonathan Bissu at jnbissu589@gmail.com

