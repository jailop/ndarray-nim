# ndarray-c-nim Documentation

Nim bindings for the [ndarray-c](https://github.com/jailop/ndarray-c) library - a numpy-like ndarray library for C with multi-dimensional arrays, OpenMP parallelization, and BLAS-optimized operations.

## Overview

ndarray-c-nim provides a clean, idiomatic Nim interface to the ndarray-c library with automatic memory management through Nim's destructors and move semantics.

## Features

- **Multi-dimensional arrays** (ndim >= 2)
- **OpenMP parallelization** for performance
- **BLAS-optimized operations** for linear algebra
- **Automatic memory management** - no manual cleanup needed!
- **Simple API** - use `@[2, 3]` instead of `@[2.csize_t, 3]`
- **Type-safe** Nim bindings
- **Zero-copy operations** where possible

## Quick Start

```nim
import ndarray

# Create a 2x3 array of ones
let arr = newOnes(@[2, 3])

# Set value at position (1, 2)
arr.set(@[1, 2], 42.0)

# Print the array
arr.print("My Array", 2)

# No cleanup needed - automatic memory management!
```

## Installation

### Prerequisites

First, install the ndarray-c library:

```bash
git clone https://github.com/jailop/ndarray-c.git
cd ndarray-c
mkdir build && cd build
cmake ..
make
sudo make install
```

### Install Nim bindings

```bash
nimble install ndarray_c_nim
```

## API Documentation

### [Module Reference](ndarray.html)

Complete API documentation with all available functions, types, and examples.

## Key Concepts

### Automatic Memory Management

Arrays are automatically freed when they go out of scope:

```nim
proc example() =
  let arr = newOnes(@[100, 100])
  # Use arr...
  # arr is automatically freed here when function returns
```

### Copy Semantics

Assignment creates a deep copy:

```nim
let a = newOnes(@[2, 2])
a.set(@[0, 0], 10.0)

let b = a  # Deep copy
b.set(@[0, 0], 20.0)

# a[0,0] is still 10.0
# b[0,0] is now 20.0
```

### In-place vs New Array Operations

Some operations modify arrays in-place and return the array for chaining:

```nim
let arr = newOnes(@[2, 3])
arr.addScalar(5.0)    # Modifies arr in place
   .mulScalar(2.0)    # Can be chained
```

Others create new arrays:

```nim
let a = newOnes(@[2, 3])
let b = newOnes(@[3, 4])
let c = a.newMatmul(b)  # Returns new array
```

## Main API Categories

### Array Creation
- `newZeros`, `newOnes`, `newFull`
- `newFromData`
- `newRandomUniform`, `newRandomNormal`
- `newArange`, `newLinspace`

### Element Access
- `get(pos)`, `set(pos, value)`
- `setSlice`, `fillSlice`, `getSlicePtr`, `copySlice`

### Arithmetic Operations (In-place)
- `add`, `mul` - element-wise operations
- `addScalar`, `mulScalar` - scalar operations
- `axpby` - linear combination
- `scaleShift`, `mulScaled` - combined operations
- `clipMin`, `clipMax`, `clip` - clipping
- `abs`, `sign` - element-wise functions

### Comparison and Logical (Returns new array)
- `newEqual`, `newLess`, `newGreater`
- `newEqualScalar`, `newLessScalar`, `newGreaterScalar`
- `newLogicalAnd`, `newLogicalOr`, `newLogicalNot`
- `newWhere` - conditional selection

### Linear Algebra (Returns new array)
- `newMatmul` - matrix multiplication
- `newTensordot` - tensor contraction
- `newTranspose` - transpose

### Array Manipulation
- `reshape` - reshape in-place
- `newTake` - extract slice
- `newStack` - stack arrays along new axis
- `newConcat` - concatenate arrays

### Aggregation
- `newAggregate(axis, type)` - aggregate along axis
- `scalarAggregate(type)` - aggregate all elements
- Types: `aggrSum`, `aggrMean`, `aggrStd`, `aggrMax`, `aggrMin`

### I/O Operations
- `save(filename)` - save to binary file
- `newLoad(filename)` - load from binary file

### Properties
- `ndim` - number of dimensions
- `shape` - dimension sizes as seq

## Examples

### Matrix Multiplication

```nim
import ndarray

let a = newOnes(@[2, 3])
let b = newOnes(@[3, 4])
let c = a.newMatmul(b)

c.print("Result", 2)
# Result [2, 4]:
# [[    3.00     3.00     3.00     3.00]
#  [    3.00     3.00     3.00     3.00]]
```

### Aggregation

```nim
import ndarray

let arr = newArange(@[3, 4], 0.0, 12.0, 1.0)

# Sum along axis 0
let sumAxis0 = arr.newAggregate(0, aggrSum)
sumAxis0.print("Sum axis 0", 2)

# Mean of all elements
let meanAll = arr.scalarAggregate(aggrMean)
echo "Mean: ", meanAll  # 5.5
```

### Conditional Operations

```nim
import ndarray

let data = newArange(@[2, 3], 0.0, 6.0, 1.0)
let mask = data.newGreaterScalar(2.5)
let zeros = newZeros(@[2, 3])
let filtered = newWhere(mask, data, zeros)

filtered.print("Filtered", 2)
# Elements > 2.5 kept, others set to 0
```

### Chained Operations

```nim
import ndarray

let result = newOnes(@[2, 3])
  .mulScalar(5.0)      # result *= 5
  .addScalar(10.0)     # result += 10
  .clipMax(12.0)       # clip to max 12

result.print("Result", 2)
```

## Performance Tips

1. **Use in-place operations** when you don't need to preserve the original array
2. **Compile with release mode** for production: `nim c -d:release yourfile.nim`
3. **Leverage BLAS** - matrix operations use optimized BLAS routines
4. **Avoid unnecessary copies** - use move semantics when possible

## Building and Testing

```bash
# Build examples
nim c -d:release example.nim

# Run tests
nimble test

# Generate documentation
nim doc --project --index:on --outdir:docs ndarray.nim
```

## Important Notes

- **Minimum dimension**: All arrays must have `ndim >= 2`
- **Type casting**: The library works with `cdouble` (C double precision floats)
- **Thread safety**: Depends on underlying ndarray-c library OpenMP settings
- **Memory**: Arrays use C heap allocation, managed by Nim destructors

## Troubleshooting

### Library not found

If you get linking errors:

```bash
nim c --passL:"-L/usr/local/lib" --passL:"-lndarray" yourfile.nim
```

Or add to your `nim.cfg`:
```
--passL:"-lndarray"
--passL:"-L/usr/local/lib"
```

### Shape mismatches

Check array shapes before operations:

```nim
echo "Shape: ", arr.shape
echo "Dimensions: ", arr.ndim
```

## Links

- [API Reference](ndarray.html) - Complete module documentation
- [ndarray-c repository](https://github.com/jailop/ndarray-c)
- [ndarray-c API docs](https://jailop.github.io/ndarray-c/)
- [GitHub Issues](https://github.com/jailop/ndarray-c-nim/issues)

## License

BSD 3-Clause License (same as ndarray-c)

## Contributing

Contributions welcome! Please submit pull requests or open issues on GitHub.
