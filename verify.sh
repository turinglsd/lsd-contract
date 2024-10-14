#!/bin/bash

# Set the verification parameters
RPC_URL="https://neoxt4seed1.ngd.network"
VERIFIER="blockscout"
VERIFIER_URL="https://xt4scan.ngd.network:8877/api"
FLATTEN_DIR="flattened_contracts"
JSON_DIR="json_inputs"

# Create directories to store the flattened contracts and JSON inputs
mkdir -p $FLATTEN_DIR $JSON_DIR

# Read JSON file for contract addresses
CONFIG_FILE="deployed_contract.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found"
    exit 1
fi

# Parse JSON file for contract addresses
TUNEO_ADDRESS=$(jq -r '."contract-address".TuNEO' "$CONFIG_FILE")
WTUNEO_ADDRESS=$(jq -r '."contract-address".WtuNEO' "$CONFIG_FILE")
NATIVE_MINTER_ADDRESS=$(jq -r '."contract-address".NativeMinter' "$CONFIG_FILE")
MOCK_ERC20_ADDRESS=$(jq -r '."contract-address".MockERC20' "$CONFIG_FILE")
ERC20_MINTER_ADDRESS=$(jq -r '."contract-address".ERC20Minter' "$CONFIG_FILE")

# Function to compile, flatten, and verify a contract
compile_and_verify_contract() {
    local address=$1
    local contract_file=$2
    local contract_name=$3
    local solc_version="0.8.17"  # Ensure this matches your contract's version
    local json_output="$JSON_DIR/${contract_name}_standard.json"
    local max_retries=3
    local retry_delay=10
    
    if [ -z "$address" ] || [ "$address" == "null" ]; then
        echo "Skipping verification for $contract_name: Address not provided"
        return
    fi

    # Compile the contract to generate the standard JSON input
    echo "Compiling $contract_name with solc to generate standard JSON input..."
    if solc --optimize --combined-json abi,bin,bin-runtime,srcmap,srcmap-runtime,metadata "$contract_file" -o "$JSON_DIR" --overwrite; then
        echo "Standard JSON input generated successfully: $json_output"
    else
        echo "Error compiling $contract_name. Check the file path: $contract_file"
        return 1
    fi

    # Verify the contract
    echo "Verifying $contract_name at address $address"
    
    for ((i=1; i<=max_retries; i++)); do
        if forge verify-contract \
            --rpc-url "$RPC_URL" \
            --verifier "$VERIFIER" \
            --verifier-url "$VERIFIER_URL" \
            "$address" \
            "$contract_file:$contract_name"; then
            echo "Verification successful for $contract_name"
            return 0
        else
            echo "Attempt $i failed. Retrying in $retry_delay seconds..."
            sleep $retry_delay
        fi
    done
    
    echo "Failed to verify $contract_name after $max_retries attempts"
    return 1
}

echo "Using RPC URL: $RPC_URL"
echo "Using Verifier: $VERIFIER"
echo "Using Verifier URL: $VERIFIER_URL"

# Compile and verify contracts
compile_and_verify_contract "$TUNEO_ADDRESS" "src/tokens/tuNEO.sol" "TuNEO"
compile_and_verify_contract "$WTUNEO_ADDRESS" "src/staking/wtuNEO.sol" "WtuNEO"
compile_and_verify_contract "$NATIVE_MINTER_ADDRESS" "src/minters/Minter.sol" "NativeMinterWithdrawal"
compile_and_verify_contract "$MOCK_ERC20_ADDRESS" "src/tokens/tuNEO.sol" "MERC20"
compile_and_verify_contract "$ERC20_MINTER_ADDRESS" "src/minters/Minter.sol" "ERC20MinterWithdrawal"

echo "Verification process completed."
