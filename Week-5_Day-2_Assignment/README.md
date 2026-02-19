## ASSIGNMENT -1 ANSWERS;

## Where are your structs, mappings and arrays stored.
Structs, mappings, and arrays are stored in storage when declared as state variables, and in memory or calldata when used as function-local variables (except mappings, which always live in storage).

##  How they behave when executed or called.
When executed, storage data persists and costs gas to modify, memory data exists only during the function call, calldata is read-only input data, and mappings are accessed by key directly from storage.

## Why don't you need to specify memory or storage with mappings
Because mappings are only allowed in storage in Solidity, the compiler automatically assigns them to storage, so specifying `memory` or `storage` is unnecessary and not allowed.
