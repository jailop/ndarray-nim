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
  NdarrayInternal {.importc: "_NDArray", header: "ndarray.h".} = object
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
  importc: "ndarray_logical_and", header: "ndarray.h".}

proc c_logical_or(A: NdarrayPtr, B: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_logical_or", header: "ndarray.h".}

proc c_logical_not(A: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_logical_not", header: "ndarray.h".}

proc c_where(condition: NdarrayPtr, x: NdarrayPtr, y: NdarrayPtr): NdarrayPtr {.
  importc: "ndarray_where", header: "ndarray.h".}

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
  importc: "ndarray_load", header: "ndarray.h".}

{.pop.}

# Destructor for automatic memory management
proc `=destroy`(arr: var NDArray) =
  ## Automatic destructor called by Nim's memory management
  if arr.handle != nil:
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
  ## Create a new ndarray with specified dimensions
  var c_dims = toCDims(dims)
  let handle = c_new(addr c_dims[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newZeros*(dims: openArray[csize_t]): NDArray =
  ## Array filled with zeros
  var c_dims = toCDims(dims)
  let handle = c_new_zeros(addr c_dims[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newOnes*(dims: openArray[csize_t]): NDArray =
  ## Array filled with ones
  var c_dims = toCDims(dims)
  let handle = c_new_ones(addr c_dims[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newFull*(dims: openArray[csize_t], value: cdouble): NDArray =
  ## Array filled with a specific value
  var c_dims = toCDims(dims)
  let handle = c_new_full(addr c_dims[0], value)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newFromData*(dims: openArray[csize_t], data: openArray[cdouble]): NDArray =
  ## Array from existing data
  var c_dims = toCDims(dims)
  let handle = c_new_from_data(addr c_dims[0], unsafeAddr data[0])
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newRandomUniform*(dims: openArray[csize_t], low: cdouble, high: cdouble): NDArray =
  ## Array with random uniform values
  var c_dims = toCDims(dims)
  let handle = c_new_randunif(addr c_dims[0], low, high)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newRandomNormal*(dims: openArray[csize_t], mean: cdouble, stddev: cdouble): NDArray =
  ## Array with random normal values
  var c_dims = toCDims(dims)
  let handle = c_new_randnorm(addr c_dims[0], mean, stddev)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newArange*(dims: openArray[csize_t], start: cdouble, stop: cdouble, step: cdouble): NDArray =
  ## Array with evenly spaced values
  var c_dims = toCDims(dims)
  let handle = c_new_arange(addr c_dims[0], start, stop, step)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

proc newLinspace*(dims: openArray[csize_t], start: cdouble, stop: cdouble, num: csize_t): NDArray =
  ## Array with linearly spaced values
  var c_dims = toCDims(dims)
  let handle = c_new_linspace(addr c_dims[0], start, stop, num)
  if handle.isNil:
    raise newException(ValueError, "Failed to create ndarray")
  wrapHandle(handle)

# Convenience overloads that accept int instead of csize_t
proc newNDArray*(dims: openArray[int]): NDArray =
  ## Create a new ndarray with specified dimensions (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newNDArray(c_dims)

proc newZeros*(dims: openArray[int]): NDArray =
  ## Array filled with zeros (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newZeros(c_dims)

proc newOnes*(dims: openArray[int]): NDArray =
  ## Array filled with ones (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newOnes(c_dims)

proc newFull*(dims: openArray[int], value: cdouble): NDArray =
  ## Array filled with a specific value (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newFull(c_dims, value)

proc newFromData*(dims: openArray[int], data: openArray[cdouble]): NDArray =
  ## Array from existing data (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newFromData(c_dims, data)

proc newRandomUniform*(dims: openArray[int], low: cdouble, high: cdouble): NDArray =
  ## Array with random uniform values (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newRandomUniform(c_dims, low, high)

proc newRandomNormal*(dims: openArray[int], mean: cdouble, stddev: cdouble): NDArray =
  ## Array with random normal values (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newRandomNormal(c_dims, mean, stddev)

proc newArange*(dims: openArray[int], start: cdouble, stop: cdouble, step: cdouble): NDArray =
  ## Array with evenly spaced values (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newArange(c_dims, start, stop, step)

proc newLinspace*(dims: openArray[int], start: cdouble, stop: cdouble, num: csize_t): NDArray =
  ## Array with linearly spaced values (int version)
  var c_dims: seq[csize_t]
  for d in dims: c_dims.add(csize_t(d))
  newLinspace(c_dims, start, stop, num)

# Core methods
proc free*(arr: NDArray) =
  ## Manually free the ndarray (for manual memory management)
  ## Note: With automatic memory management, this is not needed as arrays
  ## are freed automatically when they go out of scope via the =destroy hook
  if arr.handle != nil:
    c_free(arr.handle)

proc copy*(arr: NDArray): NDArray =
  ## Create a copy of the array
  let handle = c_new_copy(arr.handle)
  if handle.isNil:
    raise newException(ValueError, "Failed to copy ndarray")
  wrapHandle(handle)

proc get*(arr: NDArray, pos: openArray[csize_t]): cdouble =
  ## Get value at position
  var c_pos = toCPos(pos)
  c_get(arr.handle, addr c_pos[0])

proc set*(arr: NDArray, pos: openArray[csize_t], value: cdouble) =
  ## Set value at position
  var c_pos = toCPos(pos)
  c_set(arr.handle, addr c_pos[0], value)

proc get*(arr: NDArray, pos: openArray[int]): cdouble =
  ## Get value at position (int version)
  var c_pos: seq[csize_t]
  for p in pos: c_pos.add(csize_t(p))
  arr.get(c_pos)

proc set*(arr: NDArray, pos: openArray[int], value: cdouble) =
  ## Set value at position (int version)
  var c_pos: seq[csize_t]
  for p in pos: c_pos.add(csize_t(p))
  arr.set(c_pos, value)

proc setSlice*(arr: NDArray, axis: cint, index: csize_t, values: openArray[cdouble]) =
  ## Set values along a slice
  c_set_slice(arr.handle, axis, index, unsafeAddr values[0])

proc fillSlice*(arr: NDArray, axis: cint, index: csize_t, value: cdouble) =
  ## Fill a slice with a scalar value
  c_fill_slice(arr.handle, axis, index, value)

proc getSlicePtr*(arr: NDArray, axis: cint, index: csize_t): ptr cdouble =
  ## Get pointer to a slice along an axis
  c_get_slice_ptr(arr.handle, axis, index)

proc copySlice*(src: NDArray, srcAxis: cint, srcIdx: csize_t,
                dst: NDArray, dstAxis: cint, dstIdx: csize_t) =
  ## Copy a slice from one array to another
  c_copy_slice(src.handle, srcAxis, srcIdx, dst.handle, dstAxis, dstIdx)

proc getSliceSize*(arr: NDArray, axis: cint): csize_t =
  ## Get the size of a slice along an axis
  c_get_slice_size(arr.handle, axis)

proc print*(arr: NDArray, name: cstring = nil, precision: cint = 2) =
  ## Print the array
  c_print(arr.handle, name, precision)

# Arithmetic operations (modifies self in place)
proc add*(arr: NDArray, other: NDArray): NDArray {.discardable.} =
  ## Element-wise addition (modifies arr in place)
  discard c_add(arr.handle, other.handle)
  arr

proc mul*(arr: NDArray, other: NDArray): NDArray {.discardable.} =
  ## Element-wise multiplication (modifies arr in place)
  discard c_mul(arr.handle, other.handle)
  arr

proc addScalar*(arr: NDArray, scalar: cdouble): NDArray {.discardable.} =
  ## Add scalar (modifies arr in place)
  discard c_add_scalar(arr.handle, scalar)
  arr

proc mulScalar*(arr: NDArray, scalar: cdouble): NDArray {.discardable.} =
  ## Multiply by scalar (modifies arr in place)
  discard c_mul_scalar(arr.handle, scalar)
  arr

proc axpby*(arr: NDArray, alpha: cdouble, other: NDArray, beta: cdouble): NDArray {.discardable.} =
  ## Linear combination: arr = alpha*arr + beta*other
  discard c_axpby(arr.handle, alpha, other.handle, beta)
  arr

proc scaleShift*(arr: NDArray, alpha: cdouble, beta: cdouble): NDArray {.discardable.} =
  ## Scale and shift: `arr = alpha*arr + beta`
  discard c_scale_shift(arr.handle, alpha, beta)
  arr

proc mulScaled*(arr: NDArray, other: NDArray, scalar: cdouble): NDArray {.discardable.} =
  ## Element-wise multiply then scale: `arr = arr * other * scalar`
  discard c_mul_scaled(arr.handle, other.handle, scalar)
  arr

proc mapFn*(arr: NDArray, fn: proc(x: cdouble): cdouble {.cdecl.}): NDArray {.discardable.} =
  ## Apply function to each element in place
  discard c_mapfnc(arr.handle, fn)
  arr

proc mapMul*(arr: NDArray, fn: proc(x: cdouble): cdouble {.cdecl.}, 
             other: NDArray, alpha: cdouble) =
  ## Map function then multiply: arr = func(arr) * other * alpha
  discard c_map_mul(arr.handle, fn, other.handle, alpha)

proc mulAdd*(arr: NDArray, other: NDArray, dest: NDArray, alpha: cdouble, beta: cdouble) =
  ## Fused multiply-add: `dest = alpha * (arr * other) + beta * dest`
  discard c_mul_add(arr.handle, other.handle, dest.handle, alpha, beta)

proc gemv*(arr: NDArray, x: NDArray, alpha: cdouble, beta: cdouble, y: NDArray) =
  ## Matrix-vector multiply: `y = alpha * arr * x + beta * y`
  discard c_gemv(arr.handle, x.handle, alpha, beta, y.handle)

proc clipMin*(arr: NDArray, minVal: cdouble): NDArray {.discardable.} =
  ## Clip values below minimum threshold
  discard c_clip_min(arr.handle, minVal)
  arr

proc clipMax*(arr: NDArray, maxVal: cdouble): NDArray {.discardable.} =
  ## Clip values above maximum threshold
  discard c_clip_max(arr.handle, maxVal)
  arr

proc clip*(arr: NDArray, minVal: cdouble, maxVal: cdouble) =
  ## Clip values to range `[minVal, maxVal]`
  discard c_clip(arr.handle, minVal, maxVal)

proc abs*(arr: NDArray) =
  ## Absolute value (modifies arr in place)
  discard c_abs(arr.handle)

proc sign*(arr: NDArray) =
  ## Sign function: -1, 0, or +1 (modifies arr in place)
  discard c_sign(arr.handle)

# Comparison operations (returns new array)
proc newEqual*(arr: NDArray, other: NDArray): NDArray =
  ## Element-wise equality comparison
  let handle = c_new_equal(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newLess*(arr: NDArray, other: NDArray): NDArray =
  ## Element-wise less-than comparison
  let handle = c_new_less(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newGreater*(arr: NDArray, other: NDArray): NDArray =
  ## Element-wise greater-than comparison
  let handle = c_new_greater(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newEqualScalar*(arr: NDArray, value: cdouble): NDArray =
  ## Scalar equality comparison
  let handle = c_new_equal_scalar(arr.handle, value)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newLessScalar*(arr: NDArray, value: cdouble): NDArray =
  ## Scalar less-than comparison
  let handle = c_new_less_scalar(arr.handle, value)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newGreaterScalar*(arr: NDArray, value: cdouble): NDArray =
  ## Scalar greater-than comparison
  let handle = c_new_greater_scalar(arr.handle, value)
  if handle.isNil:
    raise newException(ValueError, "Comparison failed")
  wrapHandle(handle)

proc newLogicalAnd*(arr: NDArray, other: NDArray): NDArray =
  ## Logical AND
  let handle = c_logical_and(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Logical operation failed")
  wrapHandle(handle)

proc newLogicalOr*(arr: NDArray, other: NDArray): NDArray =
  ## Logical OR
  let handle = c_logical_or(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Logical operation failed")
  wrapHandle(handle)

proc newLogicalNot*(arr: NDArray): NDArray =
  ## Logical NOT
  let handle = c_logical_not(arr.handle)
  if handle.isNil:
    raise newException(ValueError, "Logical operation failed")
  wrapHandle(handle)

proc newWhere*(condition: NDArray, x: NDArray, y: NDArray): NDArray =
  ## NumPy-style where: `result = condition ? x : y`
  let handle = c_where(condition.handle, x.handle, y.handle)
  if handle.isNil:
    raise newException(ValueError, "Where operation failed")
  wrapHandle(handle)

# Linear algebra
proc newMatmul*(arr: NDArray, other: NDArray): NDArray =
  ## Matrix multiplication
  let handle = c_new_matmul(arr.handle, other.handle)
  if handle.isNil:
    raise newException(ValueError, "Matrix multiplication failed")
  wrapHandle(handle)

proc newTensordot*(arr: NDArray, other: NDArray, axesA: openArray[cint], axesB: openArray[cint]): NDArray =
  ## Tensor contraction over specified axes
  var c_axes_a = toCAxes(axesA)
  var c_axes_b = toCAxes(axesB)
  let handle = c_new_tensordot(arr.handle, other.handle, addr c_axes_a[0], addr c_axes_b[0])
  if handle.isNil:
    raise newException(ValueError, "Tensor dot failed")
  wrapHandle(handle)

# Manipulation
proc newTranspose*(arr: NDArray): NDArray =
  ## Transpose
  let handle = c_new_transpose(arr.handle)
  if handle.isNil:
    raise newException(ValueError, "Transpose failed")
  wrapHandle(handle)

proc reshape*(arr: NDArray, newDims: openArray[int]) =
  ## Reshape the ndarray in-place to new dimensions
  ## Use -1 for one dimension to automatically infer its size
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
  ## Take a slice along an axis
  let handle = c_new_take(arr.handle, axis, start, `end`)
  if handle.isNil:
    raise newException(ValueError, "Take failed")
  wrapHandle(handle)

# Aggregation
proc newAggregate*(arr: NDArray, axis: cint, aggrType: AggrType): NDArray =
  ## Aggregate over axis
  let handle = c_new_aggr(arr.handle, axis, cint(aggrType))
  if handle.isNil:
    raise newException(ValueError, "Aggregation failed")
  wrapHandle(handle)

proc scalarAggregate*(arr: NDArray, aggrType: AggrType): cdouble =
  ## Aggregate all elements to a scalar value
  c_scalar_aggr(arr.handle, cint(aggrType))

# Array combining
proc newStack*(axis: cint, arrays: openArray[NDArray]): NDArray =
  ## Stack arrays along a new axis
  var c_array_list = toCArrayList(arrays)
  let handle = c_new_stack(axis, addr c_array_list[0])
  if handle.isNil:
    raise newException(ValueError, "Stack failed")
  wrapHandle(handle)

proc newConcat*(axis: cint, arrays: openArray[NDArray]): NDArray =
  ## Concatenate arrays along an existing axis
  var c_array_list = toCArrayList(arrays)
  let handle = c_new_concat(axis, addr c_array_list[0])
  if handle.isNil:
    raise newException(ValueError, "Concatenation failed")
  wrapHandle(handle)

# I/O
proc save*(arr: NDArray, filename: string): bool =
  ## Save to binary file
  c_save(arr.handle, filename.cstring) == 0

proc newLoad*(filename: string): NDArray =
  ## Load from binary file
  let handle = c_load(filename.cstring)
  if handle.isNil:
    raise newException(IOError, "Failed to load ndarray from file")
  wrapHandle(handle)

# Utility properties
proc ndim*(arr: NDArray): csize_t =
  ## Get number of dimensions
  arr.handle.ndim

proc shape*(arr: NDArray): seq[csize_t] =
  ## Get dimension sizes
  result = newSeq[csize_t](arr.handle.ndim)
  let dimsPtr = cast[ptr UncheckedArray[csize_t]](arr.handle.dims)
  for i in 0..<arr.handle.ndim:
    result[i] = dimsPtr[i]
