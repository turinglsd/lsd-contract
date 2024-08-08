const ethers = require('ethers');

// Configuration
const rpcUrl = 'https://sepolia-rollup.arbitrum.io/rpc';
const privateKey = '0x3ba66a28e4c32d086e168539441b1c1695e9d4a3922e4f5166dd744980e20a59';
const tokenAddress = '0xE67a74cBf98Aa6B577Db1349D7607A95D7e3aE19';

// Security warning
console.warn("WARNING: This script contains sensitive information (private key). Do not use or share this script in public environments.");

// ERC20 token ABI
const erc20Abi = [
  "function transfer(address recipient, uint256 amount) external returns (bool)",
  "function balanceOf(address account) external view returns (uint256)",
  "function decimals() external view returns (uint8)"
];

async function transferTokens(recipientAddress, amount) {
  // Set up provider and signer
  const provider = new ethers.JsonRpcProvider(rpcUrl);
  const signer = new ethers.Wallet(privateKey, provider);

  // Get faucet address (derived from private key)
  const faucetAddress = await signer.getAddress();

  // Create contract instance
  const tokenContract = new ethers.Contract(tokenAddress, erc20Abi, signer);

  try {
    // Get token decimals
    const decimals = await tokenContract.decimals();

    // Check balance
    const balance = await tokenContract.balanceOf(faucetAddress);
    if (balance < amount) {
      throw new Error("Insufficient faucet balance");
    }

    // Execute transfer
    const tx = await tokenContract.transfer(recipientAddress, amount);
    await tx.wait();

    console.log(`Successfully transferred ${ethers.formatUnits(amount, decimals)} tokens to ${recipientAddress}`);
    console.log(`Transaction hash: ${tx.hash}`);
  } catch (error) {
    console.error("Error transferring tokens:", error);
  }
}

// Usage example
async function main() {
  const recipientAddress = '0x742d35Cc6634C0532925a3b844Bc454e4438f44e'; // replace your addr 
  const amount = ethers.parseUnits('10', 18);

  await transferTokens(recipientAddress, amount);
}

main().catch(console.error);