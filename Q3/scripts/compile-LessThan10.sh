#!/bin/bash

# [assignment] create your own bash script to compile Multipler3.circom using PLONK below

cd contracts/circuits

mkdir LessThan10

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling Multiplier3Verifier.circom..."

# compile circuit

circom LessThan10.circom --r1cs --wasm --sym -o LessThan10
snarkjs r1cs info LessThan10/LessThan10.r1cs


snarkjs plonk setup LessThan10/LessThan10.r1cs powersOfTau28_hez_final_10.ptau LessThan10/circuit_final.zkey
snarkjs zkey export verificationkey LessThan10/circuit_final.zkey LessThan10/verification_key.json

snarkjs zkey export solidityverifier LessThan10/circuit_final.zkey ../LessThan10.sol

# generate witness for checking 3-1-2
node LessThan10/LessThan10_js/generate_witness.js LessThan10/LessThan10_js/LessThan10.wasm LessThan10/input.json LessThan10/witness.wtns

# create proof for checking 3-1-2
snarkjs plonk prove LessThan10/circuit_final.zkey LessThan10/witness.wtns LessThan10/proof.json LessThan10/public.json

# verify proof for checking 3-1-2
snarkjs plonk verify LessThan10/verification_key.json LessThan10/public.json LessThan10/proof.json

cd ../..