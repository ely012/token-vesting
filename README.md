# Token Vesting Smart Contract

## Description
The **Token Vesting Smart Contract** is a Clarity-based smart contract that enables secure, automated, and transparent distribution of tokens over a fixed schedule on the Stacks blockchain. It is designed to manage token release based on predefined vesting parameters, reducing the risk of token dumps and encouraging long-term commitment from stakeholders. The contract supports customizable cliff periods, vesting durations, and periodic release mechanisms.

## Features
- **Time-Based Vesting:** Tokens are released gradually over a set schedule.
- **Cliff Support:** Optional cliff period before vesting begins.
- **Customizable Schedules:** Define vesting duration, interval, and total allocation.
- **Revoke & Withdraw:** Supports revocable schedules and token withdrawals by beneficiaries.
- **On-Chain Enforcement:** All operations are transparent and verifiable on-chain.

## Installation
Ensure you have the Stacks blockchain development environment set up with Clarinet.

```sh
# Clone the repository
git clone https://github.com/yourusername/token-vesting-contract.git
cd token-vesting-contract

# Install dependencies
clarinet check
```

## Usage
### Deploy the Contract
```sh
clarinet deploy
```

### Create a Vesting Schedule
```sh
(contract-call? .token-vesting create-schedule beneficiary total-amount start-time cliff-duration vesting-duration interval)
```

### Claim Vested Tokens
```sh
(contract-call? .token-vesting claim vested-id)
```

### Revoke a Vesting Schedule
```sh
(contract-call? .token-vesting revoke vested-id)
```

## Testing
Run unit tests using Clarinet:
```sh
clarinet test
```

## License
This project is licensed under the MIT License.

## Contributing
Feel free to open issues or submit pull requests for improvements.

## Contact
For inquiries, reach out via GitHub issues.

