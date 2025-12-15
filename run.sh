#!/bin/bash
trap 'exit 130' INT

export TIME='time reprts: \t%E real,\t%U user,\t%S sys,\t%M mmem'
export AMARU_LOG=''


echo "Compiling with ptmalloc"

rm -rf *.preprod.db
cargo run --profile profiling -- bootstrap --network=preprod

cargo build --profile profiling

echo "try with time and 127.0.0.1:3001"
for i in {160..250..10}; do
  export INGEST_MAXIMUM_EPOCH="$i"
  /usr/bin/time target/profiling/amaru run --network=preprod --peer-address 127.0.0.1:3001
done

echo "Compiling with jemalloc"

rm -rf *.preprod.db
cargo run --profile profiling --features jemalloc -- bootstrap --network=preprod

cargo build --profile profiling --features jemalloc

echo "try with time and 127.0.0.1:3001"
for i in {160..250..10}; do
  export INGEST_MAXIMUM_EPOCH="$i"
  /usr/bin/time target/profiling/amaru run --network=preprod --peer-address 127.0.0.1:3001
done

# echo "Compiling with mimalloc"

# rm -rf *.preprod.db
# cargo run --profile profiling --features mimalloc -- bootstrap --network=preprod

# cargo build --profile profiling --features mimalloc

# echo "try with time and 127.0.0.1:3001"
# for i in {160..250..10}; do
#   export INGEST_MAXIMUM_EPOCH="$i"
#   /usr/bin/time target/profiling/amaru run --network=preprod --peer-address 127.0.0.1:3001
# done