#!/bin/bash
trap 'exit 130' INT

export AMARU_LOG=''


echo "Compiling with ptmalloc"

rm -rf *.preprod.db
cargo run --profile profiling -- bootstrap --network=preprod

cargo build --profile profiling

export INGEST_MAXIMUM_EPOCH=210
target/profiling/amaru run --network=preprod --peer-address 127.0.0.1:3001

export INGEST_MAXIMUM_EPOCH=211
LD_PRELOAD=./target/profiling/libbytehound.so target/profiling/amaru run --network=preprod --peer-address 127.0.0.1:3001

# then bytehound server memory-profiling_*.dat