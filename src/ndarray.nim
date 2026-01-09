## Nim bindings for ndarray-c library
## 
## A numpy-like ndarray library for C with multi-dimensional arrays,
## OpenMP parallelization, and BLAS-optimized operations.
## 
## Features automatic memory management using Nim's destructors and move semantics.
## 
## Examples
## --------
## 
## Basic usage:
## 
## .. code-block:: nim
##   import ndarray
##   
##   # Create a 2x3 array of ones (simple int syntax)
##   let arr = newOnes(@[2, 3])
##   
##   # Set value at position (1, 2)
##   arr.set(@[1, 2], 42.0)
##   
##   # Get value at position
##   let val = arr.get(@[1, 2])
##   
##   # Print the array
##   arr.print("My Array", 2)
##   
##   # No manual cleanup needed - automatic memory management!
##   
## Note: You can use regular int arrays (`@[2, 3]`) or csize_t arrays 
## (`@[2.csize_t, 3]`) - both work!

{.push dynlib: "libndarray.so".}

type
  NdarrayInternal {.importc: "NDArray_", header: "ndarray.h".} = object
    data: ptr cdouble
    dims: ptr csize_t
    ndim: csize_t
  
  NdarrayPtr = ptr NdarrayInternal
  
  NDArray* = object
    ## A handle to a ndarray structure with automatic memory management
    handle: NdarrayPtr

  AggrType* = enum
    ## Aggregation types
    aggrSum = 0
    aggrMean = 1
    aggrStd = 2
    aggrMax = 3
    aggrMin = 4

const
  ALL_AXES* = -1
    ## Constant to indicate operations on all axes

# Low-level C bindings
proc c_new(dims: ptr csize_t): NdarrayPtr {.
  importc: "ndarray_new", header: "ndarray.h".}

proc c_free(t: NdarrayPtr) {.
  importc: "ndarray_free", header: "ndarray.h".}

proc c_set(t: NdarrayPtr, pos: ptr csize_t, value: cdouble) {.
  importc: "ndarray_set", header: "ndarray.h".}

proc c_get(t: NdarrayPtr, pos: ptr csize_t): cdouble {.
  importc: "ndarray_get", header: "ndarray.h".}

proc c_set_slice(arr: NdarrayPtr, axis: cint, index: csize_t, values: ptr cdouble) {.
  importc: "ndarray_set_slice", header: "ndarray.h".}

proc c_fill_slice(arr: NdarrayPtr, axis: cint, index: csize_t, value: cdouble) {.
  importc: "ndarray_fill_slice", header: "ndarray.h".}

proc c_get_slice_ptr(arr: NdarrayPtr, axis: cint, index: csize_t): ptr cdouble {.
  importc: "ndarray_get_slice_ptr", header: "ndarray.h".}

proc c_copy_slice(src: NdarrayPtr, srcAxis: cint, srcIdx: csize_t,
                  dst: NdarrayPtr, dstAxis: cint, dstIdx: csize_t) {.
  importc: "ndarray_copy_slice", header: "ndarray.h".}

proc c_get_slice_size(arr: NdarrayPtr, axis: cint): csize_t {.
  importc: "ndarray_get_slice_size", header: "ndarray.h".}

proc c_print(arr: NdarrayPtr, name: cstring, precision: cint) {.
  importc: "ndarray_print", header: "ndarray.h".}

proc c_new_copy(t: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_copy", header: "ndarray.h".}

proc c_new_zeros(dims: ptr csize_t): NdarrayPtr {.
  importc: "ndarray_new_zeros", header: "ndarray.h".}

proc c_new_from_data(dims: ptr csize_t, data: ptr cdouble): NdarrayPtr {.
  importc: "ndarray_new_from_data", header: "ndarray.h".}

proc c_new_ones(dims: ptr csize_t): NdarrayPtr {.
  importc: "ndarray_new_ones", header: "ndarray.h".}

proc c_new_full(dims: ptr csize_t, value: cdouble): NdarrayPtr {.
  importc: "ndarray_new_full", header: "ndarray.h".}

proc c_new_arange(dims: ptr csize_t, start: cdouble, stop: cdouble, step: cdouble): NdarrayPtr {.
  importc: "ndarray_new_arange", header: "ndarray.h".}

proc c_new_linspace(dims: ptr csize_t, start: cdouble, stop: cdouble, num: csize_t): NdarrayPtr {.
  importc: "ndarray_new_linspace", header: "ndarray.h".}

proc c_new_randnorm(dims: ptr csize_t, mean: cdouble, stddev: cdouble): NdarrayPtr {.
  importc: "ndarray_new_randnorm", header: "ndarray.h".}

proc c_new_randunif(dims: ptr csize_t, low: cdouble, high: cdouble): NdarrayPtr {.
  importc: "ndarray_new_randunif", header: "ndarray.h".}


# Arithmetic operations
proc c_add(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_add", header: "ndarray.h".}

proc c_mul(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_mul", header: "ndarray.h".}

proc c_add_scalar(A: NdarrayPtr, scalar: cdouble): NdarrayPtr {.
  importc: "ndarray_add_scalar", header: "ndarray.h".}

proc c_mul_scalar(A: NdarrayPtr, scalar: cdouble): NdarrayPtr {.
  importc: "ndarray_mul_scalar", header: "ndarray.h".}

proc c_mapfnc(A: NdarrayPtr, fn: proc(x: cdouble): cdouble {.cdecl.}): NdarrayPtr {.
  importc: "ndarray_mapfnc", header: "ndarray.h".}

proc c_axpby(A: NdarrayPtr, alpha: cdouble, B: NdarrayPtr, beta: cdouble): NdarrayPtr {.
  importc: "ndarray_axpby", header: "ndarray.h".}

proc c_scale_shift(A: NdarrayPtr, alpha: cdouble, beta: cdouble): NdarrayPtr {.
  importc: "ndarray_scale_shift", header: "ndarray.h".}

proc c_mul_scaled(A: NdarrayPtr, B: NdarrayPtr, scalar: cdouble): NdarrayPtr {.
  importc: "ndarray_mul_scaled", header: "ndarray.h".}

proc c_map_mul(A: NdarrayPtr, fn: proc(x: cdouble): cdouble {.cdecl.}, 
               B: NdarrayPtr, alpha: cdouble): NdarrayPtr {.
  importc: "ndarray_map_mul", header: "ndarray.h".}

proc c_mul_add(A: NdarrayPtr, B: NdarrayPtr, C: NdarrayPtr, alpha: cdouble, beta: cdouble): NdarrayPtr {.
  importc: "ndarray_mul_add", header: "ndarray.h".}

proc c_gemv(A: NdarrayPtr, x: NdarrayPtr, alpha: cdouble, beta: cdouble, y: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_gemv", header: "ndarray.h".}

proc c_clip_min(A: NdarrayPtr, minVal: cdouble): NdarrayPtr {.
  importc: "ndarray_clip_min", header: "ndarray.h".}

proc c_clip_max(A: NdarrayPtr, maxVal: cdouble): NdarrayPtr {.
  importc: "ndarray_clip_max", header: "ndarray.h".}

proc c_clip(A: NdarrayPtr, minVal: cdouble, maxVal: cdouble): NdarrayPtr {.
  importc: "ndarray_clip", header: "ndarray.h".}

proc c_abs(A: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_abs", header: "ndarray.h".}

proc c_sign(A: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_sign", header: "ndarray.h".}

# Comparison operations
proc c_new_equal(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_equal", header: "ndarray.h".}

proc c_new_less(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_less", header: "ndarray.h".}

proc c_new_greater(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_greater", header: "ndarray.h".}

proc c_new_equal_scalar(A: NdarrayPtr, value: cdouble): NdarrayPtr {.
  importc: "ndarray_new_equal_scalar", header: "ndarray.h".}

proc c_new_less_scalar(A: NdarrayPtr, value: cdouble): NdarrayPtr {.
  importc: "ndarray_new_less_scalar", header: "ndarray.h".}

proc c_new_greater_scalar(A: NdarrayPtr, value: cdouble): NdarrayPtr {.
  importc: "ndarray_new_greater_scalar", header: "ndarray.h".}

proc c_logical_and(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_logical_and", header: "ndarray.h".}

proc c_logical_or(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_logical_or", header: "ndarray.h".}

proc c_logical_not(A: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_logical_not", header: "ndarray.h".}

proc c_where(condition: NdarrayPtr, x: NdarrayPtr, y: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_where", header: "ndarray.h".}

# Linear algebra operations
proc c_new_tensordot(A: NdarrayPtr, B: NdarrayPtr, axesA: ptr cint, axesB: ptr cint): NdarrayPtr {.
  importc: "ndarray_new_tensordot", header: "ndarray.h".}

proc c_new_matmul(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_matmul", header: "ndarray.h".}

# Manipulation operations
proc c_new_stack(axis: cint, arrList: ptr NdarrayPtr) : NdarrayPtr {.
  importc: "ndarray_new_stack", header: "ndarray.h".}

proc c_new_concat(axis: cint, arrList: ptr NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_concat", header: "ndarray.h".}

proc c_new_take(arr: NdarrayPtr, axis: cint, start: csize_t, endIdx: csize_t): NdarrayPtr {.
  importc: "ndarray_new_take", header: "ndarray.h".}

proc c_new_transpose(A: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_new_transpose", header: "ndarray.h".}

proc c_reshape(arr: NdarrayPtr, newDims: ptr csize_t) {.
  importc: "ndarray_reshape", header: "ndarray.h".}

# Aggregation operations
proc c_new_aggr(A: NdarrayPtr, axis: cint, aggrType: cint): NdarrayPtr {.
  importc: "ndarray_new_aggr", header: "ndarray.h".}

proc c_scalar_aggr(A: NdarrayPtr, aggrType: cint): cdouble {.
  importc: "ndarray_scalar_aggr", header: "ndarray.h".}

# I/O operations
proc c_save(arr: NdarrayPtr, filename: cstring): cint {.
  importc: "ndarray_save", header: "ndarray.h".}

proc c_load(filename: cstring): NdarrayPtr {.
  importc: "ndarray_new_load", header: "ndarray.h".}

{.pop.}

# Destructor for automatic memory management
proc `=destroy`(arr: var NDArray) =
  ## Automatic destructor called by Nim's memory management
  if arr.handle != nil:
    when defined(debugDestructor):
      echo "=destroy called, freeing handle: ", cast[uint](arr.handle)
    c_free(arr.handle)
    arr.handle = nil

proc `=copy`(dest: var NDArray, src: NDArray) =
  ## Copy hook - creates a deep copy of the array
  if dest.handle != nil and dest.handle != src.handle:
    c_free(dest.handle)
  if src.handle != nil:
    dest.handle = c_new_copy(src.handle)
  else:
    dest.handle = nil

proc `=sink`(dest: var NDArray, src: NDArray) =
  ## Sink/move hook - transfers ownership
  if dest.handle != nil and dest.handle != src.handle:
    c_free(dest.handle)
  dest.handle = src.handle

# Helper to create NDArray from raw pointer
proc wrapHandle(handle: NdarrayPtr): NDArray =
  NDArray(handle: handle)

# High-level Nim API with idiomatic names
const MAX_DIMS = 16
const MAX_ARRAYS = 64

proc toCDims(dims: openArray[csize_t]): array[MAX_DIMS + 1, csize_t] =
  ## Convert Nim array to C-style zero-terminated array
  if dims.len > MAX_DIMS:
    raise newException(ValueError, "Too many dimensions")
  for i in 0..<dims.len:
    result[i] = dims[i]
  result[dims.len] = 0

proc toCPos(pos: openArray[csize_t]): array[MAX_DIMS, csize_t] =
  ## Convert Nim array to C position array
  if pos.len > MAX_DIMS:
    raise newException(ValueError, "Too many dimensions")
  for i in 0..<pos.len:
    result[i] = pos[i]

proc toCAxes(axes: openArray[cint]): array[MAX_DIMS + 1, cint] =
  ## Convert Nim array to C-style axes array with -1 sentinel
  if axes.len > MAX_DIMS:
    raise newException(ValueError, "Too many axes")
  for i in 0..<axes.len:
    result[i] = axes[i]
  result[axes.len] = -1

proc toCArrayList(arrays: openArray[NDArray]): array[MAX_ARRAYS + 1, NdarrayPtr] =
  ## Convert Nim array to C-style NULL-terminated array
  if arrays.len > MAX_ARRAYS:
    raise newException(ValueError, "Too many arrays")
  for i in 0..<arrays.len:
    result[i] = arrays[i].handle
  result[arrays.len] = nil

# Creation functions
proc newNDArray*(dims: openArray[csize_t]): NDArray =
  ## Creates a new ndarray with specified dimensions.
  ##
  ## All elements are uninitialized. Use `newZeros`, `newOnes`, or
  ## `newFull` for initialized arrays.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ##
  ## **Returns:** New NDArray with uninitialized data
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newNDArray(@[3, 4])  # 3x4 uninitialized array
  var c_dims = toCDims(dims)
  let handle = c_new(addr c_dims[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newZeros*(dims: openArray[csize_t]): NDArray =
  ## Creates a new ndarray filled with zeros.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ##
  ## **Returns:** New NDArray filled with 0.0
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newZeros(@[3, 4])  # 3x4 array of zeros
  var c_dims = toCDims(dims)
  let handle = c_new_zeros(addr c_dims[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newOnes*(dims: openArray[csize_t]): NDArray =
  ## Creates a new ndarray filled with ones.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ##
  ## **Returns:** New NDArray filled with 1.0
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[3, 4])  # 3x4 array of ones
  var c_dims = toCDims(dims)
  let handle = c_new_ones(addr c_dims[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newFull*(dims: openArray[csize_t], value: cdouble): NDArray =
  ## Creates a new ndarray filled with a specific value.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ## * `value` - The value to fill the array with
  ##
  ## **Returns:** New NDArray filled with the specified value
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newFull(@[3, 4], 5.0)  # 3x4 array filled with 5.0
  var c_dims = toCDims(dims)
  let handle = c_new_full(addr c_dims[0], value)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newFromData*(dims: openArray[csize_t], data: openArray[cdouble]): NDArray =
  ## Creates a new ndarray from existing data.
  ##
  ## The data is copied into the new array. Data should be in row-major order.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ## * `data` - Array of values to copy (size must match product of dims)
  ##
  ## **Returns:** New NDArray with copied data
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let data = @[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
  ##   let arr = newFromData(@[2, 3], data)  # 2x3 array from data
  var c_dims = toCDims(dims)
  let handle = c_new_from_data(addr c_dims[0], unsafeAddr data[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newRandomUniform*(dims: openArray[csize_t], low: cdouble, high: cdouble): NDArray =
  ## Creates a new ndarray with random values from uniform distribution.
  ##
  ## Values are uniformly distributed in the range [low, high).
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ## * `low` - Lower bound (inclusive)
  ## * `high` - Upper bound (exclusive)
  ##
  ## **Returns:** New NDArray with random uniform values
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newRandomUniform(@[3, 4], 0.0, 1.0)  # Random values in [0, 1)
  var c_dims = toCDims(dims)
  let handle = c_new_randunif(addr c_dims[0], low, high)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newRandomNormal*(dims: openArray[csize_t], mean: cdouble, stddev: cdouble): NDArray =
  ## Creates a new ndarray with random values from normal distribution.
  ##
  ## Values follow a Gaussian distribution with specified mean and standard deviation.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ## * `mean` - Mean of the distribution
  ## * `stddev` - Standard deviation of the distribution
  ##
  ## **Returns:** New NDArray with random normal values
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newRandomNormal(@[3, 4], 0.0, 1.0)  # Standard normal distribution
  var c_dims = toCDims(dims)
  let handle = c_new_randnorm(addr c_dims[0], mean, stddev)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newArange*(dims: openArray[csize_t], start: cdouble, stop: cdouble, step: cdouble): NDArray =
  ## Creates a new ndarray with evenly spaced values in a range.
  ##
  ## Values are generated sequentially: start, start+step, start+2*step, ...
  ## and filled in row-major order.
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ## * `start` - Starting value (inclusive)
  ## * `stop` - Ending value (exclusive)
  ## * `step` - Step size between values
  ##
  ## **Returns:** New NDArray with evenly spaced values
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 5], 0.0, 10.0, 1.0)  # Values 0 to 9
  var c_dims = toCDims(dims)
  let handle = c_new_arange(addr c_dims[0], start, stop, step)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newLinspace*(dims: openArray[csize_t], start: cdouble, stop: cdouble, num: csize_t): NDArray =
  ## Creates a new ndarray with linearly spaced values.
  ##
  ## Values are evenly distributed between start and stop (both inclusive).
  ##
  ## **Parameters:**
  ## * `dims` - Array of dimension sizes (must have at least 2 elements)
  ## * `start` - Starting value (inclusive)
  ## * `stop` - Ending value (inclusive)
  ## * `num` - Number of values to generate
  ##
  ## **Returns:** New NDArray with linearly spaced values
  ##
  ## **Raises:** ValueError if creation fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newLinspace(@[2, 5], 0.0, 1.0, 10)  # 10 values from 0 to 1
  var c_dims = toCDims(dims)
  let handle = c_new_linspace(addr c_dims[0], start, stop, num)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

# Convenience overloads that accept int instead of csize_t
proc newNDArray*(dims: openArray[int]): NDArray =
  ## Creates a new ndarray with specified dimensions (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newNDArray<#newNDArray,openArray[csize_t]>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newNDArray(c_dims)

proc newZeros*(dims: openArray[int]): NDArray =
  ## Creates a new ndarray filled with zeros (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newZeros<#newZeros,openArray[csize_t]>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newZeros(c_dims)

proc newOnes*(dims: openArray[int]): NDArray =
  ## Creates a new ndarray filled with ones (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newOnes<#newOnes,openArray[csize_t]>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newOnes(c_dims)

proc newFull*(dims: openArray[int], value: cdouble): NDArray =
  ## Creates a new ndarray filled with a specific value (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newFull<#newFull,openArray[csize_t],cdouble>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newFull(c_dims, value)

proc newFromData*(dims: openArray[int], data: openArray[cdouble]): NDArray =
  ## Creates a new ndarray from existing data (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newFromData<#newFromData,openArray[csize_t],openArray[cdouble]>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newFromData(c_dims, data)

proc newRandomUniform*(dims: openArray[int], low: cdouble, high: cdouble): NDArray =
  ## Creates a new ndarray with random uniform values (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newRandomUniform<#newRandomUniform,openArray[csize_t],cdouble,cdouble>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newRandomUniform(c_dims, low, high)

proc newRandomNormal*(dims: openArray[int], mean: cdouble, stddev: cdouble): NDArray =
  ## Creates a new ndarray with random normal values (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newRandomNormal<#newRandomNormal,openArray[csize_t],cdouble,cdouble>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newRandomNormal(c_dims, mean, stddev)

proc newArange*(dims: openArray[int], start: cdouble, stop: cdouble, step: cdouble): NDArray =
  ## Creates a new ndarray with evenly spaced values (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newArange<#newArange,openArray[csize_t],cdouble,cdouble,cdouble>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newArange(c_dims, start, stop, step)

proc newLinspace*(dims: openArray[int], start: cdouble, stop: cdouble, num: csize_t): NDArray =
  ## Creates a new ndarray with linearly spaced values (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `newLinspace<#newLinspace,openArray[csize_t],cdouble,cdouble,csize_t>`_
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newLinspace(c_dims, start, stop, num)

# Core methods
proc free*(arr: NDArray) =
  ## Manually frees the ndarray.
  ##
  ## Normally not needed thanks to automatic memory management via destructors.
  ## Only use this if you need explicit control over memory deallocation.
  ##
  ## **Warning:** Do not use the array after calling this function.
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newOnes(@[3, 4])
  ##   # ... use arr ...
  ##   arr.free()  # Manual cleanup
  ## Note: With automatic memory management, this is not needed as arrays
  ## are freed automatically when they go out of scope via the =destroy hook
  if arr.handle != nil:
    c_free(arr.handle)

proc copy*(arr: NDArray): NDArray =
  ## Creates a deep copy of the array.
  ##
  ## Allocates a new array with the same dimensions and copies all data.
  ##
  ## **Returns:** New NDArray with copied data
  ##
  ## **Raises:** ValueError if copy fails
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[3, 4])
  ##   let arrCopy = arr.copy()  # Independent copy
  ##   arrCopy.set(@[0, 0], 5.0)  # Doesn't affect arr
  let handle = c_new_copy(arr.handle)
  if handle.isNil:
    raise newException(ValueError, "Failed to copy ndarray")
  wrapHandle(handle)

proc get*(arr: NDArray, pos: openArray[csize_t]): cdouble =
  ## Gets the value at the specified position.
  ##
  ## **Parameters:**
  ## * `pos` - Array of indices for each dimension
  ##
  ## **Returns:** The value at the specified position
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[3, 4])
  ##   let val = arr.get(@[1.csize_t, 2])
  var c_pos = toCPos(pos)
  c_get(arr.handle, addr c_pos[0])

proc set*(arr: NDArray, pos: openArray[csize_t], value: cdouble) =
  ## Sets the value at the specified position.
  ##
  ## **Parameters:**
  ## * `pos` - Array of indices for each dimension
  ## * `value` - The value to set
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newZeros(@[3, 4])
  ##   arr.set(@[0.csize_t, 0], 42.0)
  var c_pos = toCPos(pos)
  c_set(arr.handle, addr c_pos[0], value)

proc get*(arr: NDArray, pos: openArray[int]): cdouble =
  ## Gets the value at the specified position (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `get<#get,NDArray,openArray[csize_t]>`_
  var c_pos: seq[csize_t]
  for p in pos: c_pos.add(csize_t(p))
  arr.get(c_pos)

proc set*(arr: NDArray, pos: openArray[int], value: cdouble) =
  ## Sets the value at the specified position (int version).
  ##
  ## Convenience overload that accepts int arrays instead of csize_t.
  ##
  ## See also:
  ## * `set<#set,NDArray,openArray[csize_t],cdouble>`_
  var c_pos: seq[csize_t]
  for p in pos: c_pos.add(csize_t(p))
  arr.set(c_pos, value)

proc setSlice*(arr: NDArray, axis: cint, index: csize_t, values: openArray[cdouble]) =
  ## Sets values along a slice at a specific index on an axis.
  ##
  ## For 2D: axis=0 sets a row, axis=1 sets a column.
  ## For higher dimensions: sets the hyperplane perpendicular to the axis.
  ##
  ## **Parameters:**
  ## * `axis` - The axis along which to set the slice
  ## * `index` - The index along the axis
  ## * `values` - Array of values to set (size must match slice size)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newZeros(@[3, 4])
  ##   let rowData = @[1.0, 2.0, 3.0, 4.0]
  ##   arr.setSlice(0, 0, rowData)  # Set first row
  c_set_slice(arr.handle, axis, index, unsafeAddr values[0])

proc fillSlice*(arr: NDArray, axis: cint, index: csize_t, value: cdouble) =
  ## Fills a slice with a scalar value at a specific index on an axis.
  ##
  ## For 2D: axis=0 fills a row, axis=1 fills a column.
  ## For higher dimensions: fills the hyperplane perpendicular to the axis.
  ##
  ## **Parameters:**
  ## * `axis` - The axis along which to fill the slice
  ## * `index` - The index along the axis
  ## * `value` - The scalar value to fill with
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newZeros(@[3, 4])
  ##   arr.fillSlice(0, 1, 5.0)  # Fill second row with 5.0
  c_fill_slice(arr.handle, axis, index, value)

proc getSlicePtr*(arr: NDArray, axis: cint, index: csize_t): ptr cdouble =
  ## Gets a pointer to a slice along an axis.
  ##
  ## **Warning:** Advanced operation for direct memory access.
  ## Use with caution as it bypasses bounds checking.
  ##
  ## **Parameters:**
  ## * `axis` - The axis along which to get the slice
  ## * `index` - The index along the axis
  ##
  ## **Returns:** Pointer to the first element of the slice
  c_get_slice_ptr(arr.handle, axis, index)

proc copySlice*(src: NDArray, srcAxis: cint, srcIdx: csize_t,
                dst: NDArray, dstAxis: cint, dstIdx: csize_t) =
  ## Copies a slice from one array to another.
  ##
  ## **Parameters:**
  ## * `src` - Source array
  ## * `srcAxis` - Axis in source array
  ## * `srcIdx` - Index along source axis
  ## * `dst` - Destination array
  ## * `dstAxis` - Axis in destination array  
  ## * `dstIdx` - Index along destination axis
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let src = newOnes(@[3, 4])
  ##   let dst = newZeros(@[3, 4])
  ##   copySlice(src, 0, 0, dst, 0, 1)  # Copy first row of src to second row of dst
  c_copy_slice(src.handle, srcAxis, srcIdx, dst.handle, dstAxis, dstIdx)

proc getSliceSize*(arr: NDArray, axis: cint): csize_t =
  ## Gets the size of a slice along an axis.
  ##
  ## **Parameters:**
  ## * `axis` - The axis to query
  ##
  ## **Returns:** Number of elements in a slice along that axis
  c_get_slice_size(arr.handle, axis)

proc print*(arr: NDArray, name: cstring = nil, precision: cint = 2) =
  ## Prints the array to standard output.
  ##
  ## **Parameters:**
  ## * `name` - Optional name to display
  ## * `precision` - Number of decimal places (default: 2)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[2, 3])
  ##   arr.print("My Array", 2)
  c_print(arr.handle, name, precision)

# Arithmetic operations (modifies self in place)
proc add*(arr: var NDArray, other: NDArray): var NDArray {.discardable.} =
  ## Element-wise addition (modifies arr in place).
  ##
  ## Performs arr = arr + other element by element.
  ##
  ## **Parameters:**
  ## * `other` - Array to add (must have same shape)
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var a = newOnes(@[2, 3])
  ##   let b = newFull(@[2, 3], 2.0)
  ##   a.add(b)  # a now contains 3.0 everywhere
  discard c_add(arr.handle, other.handle)
  arr

proc mul*(arr: var NDArray, other: NDArray): var NDArray {.discardable.} =
  ## Element-wise multiplication (modifies arr in place).
  ##
  ## Performs arr = arr * other element by element.
  ##
  ## **Parameters:**
  ## * `other` - Array to multiply (must have same shape)
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var a = newFull(@[2, 3], 5.0)
  ##   let b = newFull(@[2, 3], 2.0)
  ##   a.mul(b)  # a now contains 10.0 everywhere
  discard c_mul(arr.handle, other.handle)
  arr

proc addScalar*(arr: var NDArray, scalar: cdouble): var NDArray {.discardable.} =
  ## Adds scalar to all elements (modifies arr in place).
  ##
  ## Performs arr = arr + scalar for all elements.
  ##
  ## **Parameters:**
  ## * `scalar` - Value to add to each element
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newZeros(@[2, 3])
  ##   arr.addScalar(5.0)  # All elements now 5.0
  discard c_add_scalar(arr.handle, scalar)
  arr

proc mulScalar*(arr: var NDArray, scalar: cdouble): var NDArray {.discardable.} =
  ## Multiplies all elements by scalar (modifies arr in place).
  ##
  ## Performs arr = arr * scalar for all elements.
  ##
  ## **Parameters:**
  ## * `scalar` - Value to multiply each element by
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newOnes(@[2, 3])
  ##   arr.mulScalar(10.0)  # All elements now 10.0
  discard c_mul_scalar(arr.handle, scalar)
  arr

proc axpby*(arr: var NDArray, alpha: cdouble, other: NDArray, beta: cdouble): var NDArray {.discardable.} =
  ## Linear combination: arr = alpha*arr + beta*other.
  ##
  ## BLAS-style operation for efficient linear combinations.
  ##
  ## **Parameters:**
  ## * `alpha` - Scalar multiplier for arr
  ## * `other` - Second array (must have same shape)
  ## * `beta` - Scalar multiplier for other
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var a = newFull(@[2, 3], 2.0)
  ##   let b = newFull(@[2, 3], 3.0)
  ##   a.axpby(2.0, b, 3.0)  # a = 2*a + 3*b = 4 + 9 = 13
  discard c_axpby(arr.handle, alpha, other.handle, beta)
  arr

proc scaleShift*(arr: var NDArray, alpha: cdouble, beta: cdouble): var NDArray {.discardable.} =
  ## Scale and shift: arr = alpha*arr + beta.
  ##
  ## Combines scaling and addition in one operation.
  ##
  ## **Parameters:**
  ## * `alpha` - Scale factor
  ## * `beta` - Shift amount
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newOnes(@[2, 3])
  ##   arr.scaleShift(2.0, 3.0)  # arr = 2*1 + 3 = 5
  discard c_scale_shift(arr.handle, alpha, beta)
  arr

proc mulScaled*(arr: var NDArray, other: NDArray, scalar: cdouble): var NDArray {.discardable.} =
  ## Element-wise multiply then scale: arr = arr * other * scalar.
  ##
  ## **Parameters:**
  ## * `other` - Array to multiply (must have same shape)
  ## * `scalar` - Additional scale factor
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var a = newFull(@[2, 3], 2.0)
  ##   let b = newFull(@[2, 3], 3.0)
  ##   a.mulScaled(b, 0.5)  # a = 2 * 3 * 0.5 = 3
  discard c_mul_scaled(arr.handle, other.handle, scalar)
  arr

proc mapFn*(arr: var NDArray, fn: proc(x: cdouble): cdouble {.cdecl.}):
    var NDArray {.discardable.} =
  ## Applies a function to each element (modifies arr in place).
  ##
  ## **Parameters:**
  ## * `fn` - C-compatible function to apply to each element
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   proc square(x: cdouble): cdouble {.cdecl.} = x * x
  ##   var arr = newArange(@[2, 3], 1.0, 7.0, 1.0)
  ##   arr.mapFn(square)  # Squares all elements
  discard c_mapfnc(arr.handle, fn)
  arr

proc mapMul*(arr: var NDArray, fn: proc(x: cdouble): cdouble {.cdecl.}, 
             other: NDArray, alpha: cdouble): var NDArray {.discardable.} =
  ## Map function then multiply: arr = func(arr) * other * alpha.
  ##
  ## Combines function mapping with element-wise multiplication and scaling.
  ##
  ## **Parameters:**
  ## * `fn` - C-compatible function to apply
  ## * `other` - Array to multiply with (must have same shape)
  ## * `alpha` - Additional scale factor
  ##
  ## **Returns:** Modified array (for method chaining)
  discard c_map_mul(arr.handle, fn, other.handle, alpha)
  arr

proc mulAdd*(arr: var NDArray, other: NDArray, dest: NDArray, alpha: cdouble, beta: cdouble): var NDArray {.discardable.} =
  ## Fused multiply-add: dest = alpha * (arr * other) + beta * dest.
  ##
  ## Efficient combined operation useful in neural networks and optimization.
  ##
  ## **Parameters:**
  ## * `other` - Array to multiply with (must have same shape as arr)
  ## * `dest` - Destination array (must have same shape)
  ## * `alpha` - Scale factor for product
  ## * `beta` - Scale factor for dest
  ##
  ## **Returns:** Modified arr (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var a = newFull(@[2, 2], 2.0)
  ##   let b = newFull(@[2, 2], 3.0)
  ##   var c = newOnes(@[2, 2])
  ##   a.mulAdd(b, c, 1.0, 2.0)  # c = 1*(2*3) + 2*1 = 8
  discard c_mul_add(arr.handle, other.handle, dest.handle, alpha, beta)
  arr

proc gemv*(arr: var NDArray, x: NDArray, alpha: cdouble, beta: cdouble, y: NDArray): var NDArray {.discardable.} =
  ## Matrix-vector multiply: y = alpha * arr * x + beta * y.
  ##
  ## BLAS-optimized general matrix-vector multiplication.
  ##
  ## **Parameters:**
  ## * `x` - Input vector
  ## * `alpha` - Scale factor for matrix-vector product
  ## * `beta` - Scale factor for y
  ## * `y` - Output vector (accumulator)
  ##
  ## **Returns:** Modified arr (for method chaining)
  discard c_gemv(arr.handle, x.handle, alpha, beta, y.handle)
  arr

proc clipMin*(arr: var NDArray, minVal: cdouble): var NDArray {.discardable.} =
  ## Clips values below minimum threshold (modifies arr in place).
  ##
  ## Sets any value less than minVal to minVal.
  ##
  ## **Parameters:**
  ## * `minVal` - Minimum allowed value
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newArange(@[2, 3], -2.0, 4.0, 1.0)
  ##   arr.clipMin(0.0)  # Negative values become 0
  discard c_clip_min(arr.handle, minVal)
  arr

proc clipMax*(arr: var NDArray, maxVal: cdouble): var NDArray {.discardable.} =
  ## Clips values above maximum threshold (modifies arr in place).
  ##
  ## Sets any value greater than maxVal to maxVal.
  ##
  ## **Parameters:**
  ## * `maxVal` - Maximum allowed value
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   arr.clipMax(3.0)  # Values > 3 become 3
  discard c_clip_max(arr.handle, maxVal)
  arr

proc clip*(arr: var NDArray, minVal: cdouble, maxVal: cdouble): var NDArray {.discardable.} =
  ## Clips values to range [minVal, maxVal] (modifies arr in place).
  ##
  ## Values below minVal become minVal, values above maxVal become maxVal.
  ##
  ## **Parameters:**
  ## * `minVal` - Minimum allowed value
  ## * `maxVal` - Maximum allowed value
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newArange(@[2, 3], -1.0, 5.0, 1.0)
  ##   arr.clip(0.0, 3.0)  # Values clamped to [0, 3]
  discard c_clip(arr.handle, minVal, maxVal)
  arr

proc abs*(arr: var NDArray): var NDArray {.discardable.} =
  ## Absolute value (modifies arr in place).
  ##
  ## Replaces each element with its absolute value.
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newArange(@[2, 3], -2.0, 4.0, 1.0)
  ##   arr.abs()  # All values now non-negative
  discard c_abs(arr.handle)
  arr

proc sign*(arr: var NDArray): var NDArray {.discardable.} =
  ## Sign function: -1, 0, or +1 (modifies arr in place).
  ##
  ## Returns -1 for negative values, 0 for zero, +1 for positive values.
  ##
  ## **Returns:** Modified array (for method chaining)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   var arr = newArange(@[2, 3], -2.0, 4.0, 1.0)
  ##   arr.sign()  # Values become -1, -1, 0, 1, 1, 1
  discard c_sign(arr.handle)
  arr

# Comparison operations (returns new array)
proc newEqual*(arr: NDArray, other: NDArray): NDArray =
  ## Element-wise equality comparison (returns new array).
  ##
  ## Returns 1.0 where arr == other, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `other` - Array to compare (must have same shape)
  ##
  ## **Returns:** New array with comparison results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newOnes(@[2, 3])
  ##   let b = newOnes(@[2, 3])
  ##   let result = a.newEqual(b)  # All 1.0
  let handle = c_new_equal(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newLess*(arr: NDArray, other: NDArray): NDArray =
  ## Element-wise less-than comparison (returns new array).
  ##
  ## Returns 1.0 where arr < other, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `other` - Array to compare (must have same shape)
  ##
  ## **Returns:** New array with comparison results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let b = newFull(@[2, 3], 3.0)
  ##   let result = a.newLess(b)  # [1, 1, 1, 0, 0, 0]
  let handle = c_new_less(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newGreater*(arr: NDArray, other: NDArray): NDArray =
  ## Element-wise greater-than comparison (returns new array).
  ##
  ## Returns 1.0 where arr > other, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `other` - Array to compare (must have same shape)
  ##
  ## **Returns:** New array with comparison results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let b = newFull(@[2, 3], 2.5)
  ##   let result = a.newGreater(b)  # [0, 0, 0, 1, 1, 1]
  let handle = c_new_greater(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newEqualScalar*(arr: NDArray, value: cdouble): NDArray =
  ## Scalar equality comparison (returns new array).
  ##
  ## Returns 1.0 where arr == value, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `value` - Scalar value to compare
  ##
  ## **Returns:** New array with comparison results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let result = arr.newEqualScalar(3.0)  # 1.0 only at position with value 3
  let handle = c_new_equal_scalar(arr.handle, value)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newLessScalar*(arr: NDArray, value: cdouble): NDArray =
  ## Scalar less-than comparison (returns new array).
  ##
  ## Returns 1.0 where arr < value, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `value` - Scalar value to compare
  ##
  ## **Returns:** New array with comparison results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let result = arr.newLessScalar(3.0)  # 1.0 where values < 3
  let handle = c_new_less_scalar(arr.handle, value)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newGreaterScalar*(arr: NDArray, value: cdouble): NDArray =
  ## Scalar greater-than comparison (returns new array).
  ##
  ## Returns 1.0 where arr > value, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `value` - Scalar value to compare
  ##
  ## **Returns:** New array with comparison results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let result = arr.newGreaterScalar(2.5)  # 1.0 where values > 2.5
  let handle = c_new_greater_scalar(arr.handle, value)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newLogicalAnd*(arr: NDArray, other: NDArray): NDArray =
  ## Logical AND operation (returns new array).
  ##
  ## Returns 1.0 where both arr and other are non-zero, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `other` - Array to AND with (must have same shape)
  ##
  ## **Returns:** New array with logical AND results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let b = newGreaterScalar(a, 2.5)
  ##   let c = newLessScalar(a, 4.5)
  ##   let result = b.newLogicalAnd(c)  # 1.0 where 2.5 < val < 4.5
  let handle = c_logical_and(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Logical operation failed")
  wrapHandle(handle)

proc newLogicalOr*(arr: NDArray, other: NDArray): NDArray =
  ## Logical OR operation (returns new array).
  ##
  ## Returns 1.0 where either arr or other is non-zero, 0.0 elsewhere.
  ##
  ## **Parameters:**
  ## * `other` - Array to OR with (must have same shape)
  ##
  ## **Returns:** New array with logical OR results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let b = newLessScalar(a, 2.0)
  ##   let c = newGreaterScalar(a, 4.0)
  ##   let result = b.newLogicalOr(c)  # 1.0 where val < 2 OR val > 4
  let handle = c_logical_or(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Logical operation failed")
  wrapHandle(handle)

proc newLogicalNot*(arr: NDArray): NDArray =
  ## Logical NOT operation (returns new array).
  ##
  ## Returns 1.0 where arr is zero, 0.0 where arr is non-zero.
  ##
  ## **Returns:** New array with logical NOT results
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let mask = newLessScalar(arr, 3.0)
  ##   let inverted = mask.newLogicalNot()  # Inverts the mask
  let handle = c_logical_not(arr.handle)
  if handle.isNil:
    raise newException(ValueError, "Logical operation failed")
  wrapHandle(handle)

proc newWhere*(condition: NDArray, x: NDArray, y: NDArray): NDArray =
  ## NumPy-style conditional selection (returns new array).
  ##
  ## Returns x where condition is non-zero, y where condition is zero.
  ##
  ## **Parameters:**
  ## * `condition` - Boolean array (non-zero = true)
  ## * `x` - Array to select from when condition is true
  ## * `y` - Array to select from when condition is false
  ##
  ## **Returns:** New array with selected values
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let data = newArange(@[2, 3], 0.0, 6.0, 1.0)
  ##   let mask = data.newGreaterScalar(2.5)
  ##   let zeros = newZeros(@[2, 3])
  ##   let filtered = newWhere(mask, data, zeros)  # Keep values > 2.5, rest = 0
  let handle = c_where(condition.handle, x.handle, y.handle)
  if handle.isNil:
    raise newException(ValueError, "Where operation failed")
  wrapHandle(handle)

# Linear algebra
proc newMatmul*(arr: NDArray, other: NDArray): NDArray =
  ## Matrix multiplication (returns new array).
  ##
  ## Performs matrix multiplication using BLAS-optimized routines.
  ##
  ## **Parameters:**
  ## * `other` - Matrix to multiply with (inner dimensions must match)
  ##
  ## **Returns:** New array with matrix product
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newOnes(@[2, 3])  # 2x3 matrix
  ##   let b = newOnes(@[3, 4])  # 3x4 matrix
  ##   let c = a.newMatmul(b)    # 2x4 result
  let handle = c_new_matmul(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Matrix multiplication failed")
  wrapHandle(handle)

proc newTensordot*(arr: NDArray, other: NDArray, axesA: openArray[cint], axesB: openArray[cint]): NDArray =
  ## Tensor contraction over specified axes (returns new array).
  ##
  ## Generalized tensor product contracting specified axes.
  ##
  ## **Parameters:**
  ## * `other` - Tensor to contract with
  ## * `axesA` - Axes of arr to contract
  ## * `axesB` - Axes of other to contract (must match length of axesA)
  ##
  ## **Returns:** New array with contracted tensor
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newOnes(@[2, 3, 4])
  ##   let b = newOnes(@[4, 5])
  ##   let c = a.newTensordot(b, @[2.cint], @[0.cint])  # Contract axis 2 of a with axis 0 of b
  var c_axes_a = toCAxes(axesA)
  var c_axes_b = toCAxes(axesB)
  let handle = c_new_tensordot(arr.handle, other.handle, addr c_axes_a[0], addr c_axes_b[0])
  if handle.isNil:
    raise newException(ValueError, "Tensor dot failed")
  wrapHandle(handle)

# Manipulation
proc newTranspose*(arr: NDArray): NDArray =
  ## Transposes the array (returns new array).
  ##
  ## Reverses the order of axes. For 2D arrays, swaps rows and columns.
  ##
  ## **Returns:** New array with transposed data
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 3], 0.0, 6.0, 1.0)  # 2x3 matrix
  ##   let transposed = arr.newTranspose()          # 3x2 matrix
  let handle = c_new_transpose(arr.handle)
  if handle.isNil:
    raise newException(ValueError, "Transpose failed")
  wrapHandle(handle)

proc reshape*(arr: NDArray, newDims: openArray[int]) =
  ## Reshapes the array in-place to new dimensions.
  ##
  ## Total number of elements must remain the same.
  ## Use -1 for one dimension to automatically infer its size.
  ##
  ## **Parameters:**
  ## * `newDims` - New shape (use -1 for auto-infer)
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[2, 6], 0.0, 12.0, 1.0)  # 2x6
  ##   arr.reshape(@[3, 4])                          # Now 3x4
  ##   arr.reshape(@[2, -1])                         # Now 2x6 (inferred)
  var c_dims: array[MAX_DIMS + 1, csize_t]
  if newDims.len > MAX_DIMS:
    raise newException(ValueError, "Too many dimensions")
  for i in 0..<newDims.len:
    if newDims[i] == -1:
      c_dims[i] = cast[csize_t](-1)
    else:
      c_dims[i] = csize_t(newDims[i])
  c_dims[newDims.len] = 0
  c_reshape(arr.handle, addr c_dims[0])

proc newTake*(arr: NDArray, axis: cint, start: csize_t, `end`: csize_t): NDArray =
  ## Extracts a slice along an axis (returns new array).
  ##
  ## **Parameters:**
  ## * `axis` - Axis along which to slice
  ## * `start` - Starting index (inclusive)
  ## * `end` - Ending index (exclusive)
  ##
  ## **Returns:** New array with extracted slice
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[4, 5], 0.0, 20.0, 1.0)
  ##   let slice = arr.newTake(0, 1, 3)  # Rows 1 and 2 (indices 1, 2)
  let handle = c_new_take(arr.handle, axis, start, `end`)
  if handle.isNil:
    raise newException(ValueError, "Take failed")
  wrapHandle(handle)

# Aggregation
proc newAggregate*(arr: NDArray, axis: cint, aggrType: AggrType): NDArray =
  ## Aggregates along an axis (returns new array).
  ##
  ## Reduces the array along the specified axis using the given aggregation type.
  ##
  ## **Parameters:**
  ## * `axis` - Axis to aggregate along (use ALL_AXES for all)
  ## * `aggrType` - Type of aggregation (sum, mean, max, min, std)
  ##
  ## **Returns:** New array with aggregated values
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[3, 4], 0.0, 12.0, 1.0)
  ##   let rowSums = arr.newAggregate(0, aggrSum)     # Sum along axis 0
  ##   let colMeans = arr.newAggregate(1, aggrMean)   # Mean along axis 1
  let handle = c_new_aggr(arr.handle, axis, cint(aggrType))
  if handle.isNil:
    raise newException(ValueError, "Aggregation failed")
  wrapHandle(handle)

proc scalarAggregate*(arr: NDArray, aggrType: AggrType): cdouble =
  ## Aggregates all elements to a scalar value.
  ##
  ## **Parameters:**
  ## * `aggrType` - Type of aggregation (sum, mean, max, min, std)
  ##
  ## **Returns:** Scalar result of aggregation
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newArange(@[3, 4], 0.0, 12.0, 1.0)
  ##   let total = arr.scalarAggregate(aggrSum)   # Sum of all elements = 66
  ##   let average = arr.scalarAggregate(aggrMean) # Mean = 5.5
  c_scalar_aggr(arr.handle, cint(aggrType))

# Array combining
proc newStack*(axis: cint, arrays: openArray[NDArray]): NDArray =
  ## Stacks arrays along a new axis (returns new array).
  ##
  ## Creates a new dimension and stacks arrays along it.
  ##
  ## **Parameters:**
  ## * `axis` - Position of new axis in result
  ## * `arrays` - Arrays to stack (must have same shape)
  ##
  ## **Returns:** New array with stacked data
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newOnes(@[2, 3])
  ##   let b = newZeros(@[2, 3])
  ##   let stacked = newStack(0, @[a, b])  # Shape [2, 2, 3]
  var c_array_list = toCArrayList(arrays)
  let handle = c_new_stack(axis, addr c_array_list[0])
  if handle.isNil:
    raise newException(ValueError, "Stack failed")
  wrapHandle(handle)

proc newConcat*(axis: cint, arrays: openArray[NDArray]): NDArray =
  ## Concatenates arrays along an existing axis (returns new array).
  ##
  ## Joins arrays along the specified axis.
  ##
  ## **Parameters:**
  ## * `axis` - Axis along which to concatenate
  ## * `arrays` - Arrays to concatenate (shapes must match except on concat axis)
  ##
  ## **Returns:** New array with concatenated data
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let a = newOnes(@[2, 3])
  ##   let b = newZeros(@[2, 3])
  ##   let concatenated = newConcat(0, @[a, b])  # Shape [4, 3]
  var c_array_list = toCArrayList(arrays)
  let handle = c_new_concat(axis, addr c_array_list[0])
  if handle.isNil:
    raise newException(ValueError, "Concatenation failed")
  wrapHandle(handle)

# I/O
proc save*(arr: NDArray, filename: string): bool =
  ## Saves array to binary file.
  ##
  ## **Parameters:**
  ## * `filename` - Path to output file
  ##
  ## **Returns:** true on success, false on failure
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[3, 4])
  ##   if arr.save("myarray.nda"):
  ##     echo "Saved successfully"
  c_save(arr.handle, filename.cstring) == 0

proc newLoad*(filename: string): NDArray =
  ## Loads array from binary file.
  ##
  ## **Parameters:**
  ## * `filename` - Path to input file
  ##
  ## **Returns:** New NDArray with loaded data
  ##
  ## **Raises:** IOError if file cannot be read
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newLoad("myarray.nda")
  ##   arr.print("Loaded array", 2)
  let handle = c_load(filename.cstring)
  if handle.isNil:
    raise newException(IOError, "Failed to load ndarray from file")
  wrapHandle(handle)

# Utility properties
proc ndim*(arr: NDArray): csize_t =
  ## Gets the number of dimensions.
  ##
  ## **Returns:** Number of array dimensions
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[2, 3, 4])
  ##   echo arr.ndim  # 3
  arr.handle.ndim

proc shape*(arr: NDArray): seq[csize_t] =
  ## Gets the dimension sizes of the array.
  ##
  ## **Returns:** Sequence of dimension sizes
  ##
  ## Example:
  ## 
  ## .. code-block:: nim
  ##   let arr = newOnes(@[2, 3, 4])
  ##   let dims = arr.shape()  # @[2, 3, 4]
  ##   echo "Shape: ", dims
  result = newSeq[csize_t](arr.handle.ndim)
  let dimsPtr = cast[ptr UncheckedArray[csize_t]](arr.handle.dims)
  for i in 0..<arr.handle.ndim:
    result[i] = dimsPtr[i]
