## Tests for I/O operations and array combining

include ../src/ndarray
import std/[unittest, os]

const testFile = "test_ndarray_io.bin"

suite "I/O Operations":
  setup:
    # Clean up any existing test file
    if fileExists(testFile):
      removeFile(testFile)

  teardown:
    # Clean up test file after tests
    if fileExists(testFile):
      removeFile(testFile)

  test "Save and load array":
    let original = newArange(@[3.csize_t, 4], 0.0, 12.0, 1.0)
    
    check original.save(testFile)
    check fileExists(testFile)
    
    let loaded = newLoad(testFile)
    check loaded.ndim == original.ndim
    check loaded.shape == original.shape
    check loaded.get(@[0.csize_t, 0]) == 0.0
    check loaded.get(@[2.csize_t, 3]) == 11.0

  test "Save and load with specific values":
    let data = @[1.5, 2.5, 3.5, 4.5]
    let original = newFromData(@[2.csize_t, 2], data)
    
    check original.save(testFile)
    
    let loaded = newLoad(testFile)
    check loaded.get(@[0.csize_t, 0]) == 1.5
    check loaded.get(@[1.csize_t, 1]) == 4.5

suite "Array Combining":
  test "Stack arrays along new axis":
    let a = newOnes(@[2.csize_t, 3])
    let b = newFull(@[2.csize_t, 3], 2.0)
    let c = newFull(@[2.csize_t, 3], 3.0)
    
    let stacked = newStack(0, @[a, b, c])
    
    check stacked.ndim == 3
    check stacked.shape == @[3.csize_t, 2, 3]
    check stacked.get(@[0.csize_t, 0, 0]) == 1.0
    check stacked.get(@[1.csize_t, 0, 0]) == 2.0
    check stacked.get(@[2.csize_t, 0, 0]) == 3.0

  test "Concatenate arrays along existing axis":
    let a = newOnes(@[2.csize_t, 2])
    let b = newFull(@[2.csize_t, 2], 2.0)
    
    let concat = newConcat(0, @[a, b])
    
    check concat.ndim == 2
    check concat.shape == @[4.csize_t, 2]
    check concat.get(@[0.csize_t, 0]) == 1.0
    check concat.get(@[2.csize_t, 0]) == 2.0

  test "Concatenate along axis 1":
    let a = newOnes(@[2.csize_t, 2])
    let b = newFull(@[2.csize_t, 3], 2.0)
    
    let concat = newConcat(1, @[a, b])
    
    check concat.ndim == 2
    check concat.shape == @[2.csize_t, 5]
    check concat.get(@[0.csize_t, 0]) == 1.0
    check concat.get(@[0.csize_t, 2]) == 2.0

suite "Logical Operations":
  test "Logical AND":
    let a = newOnes(@[2.csize_t, 2])
    let b = newZeros(@[2.csize_t, 2])
    b.set(@[0.csize_t, 0], 1.0)
    
    let result = a.newLogicalAnd(b)
    
    check result.get(@[0.csize_t, 0]) == 1.0  # 1 AND 1 = 1
    check result.get(@[0.csize_t, 1]) == 0.0  # 1 AND 0 = 0

  test "Logical OR":
    let a = newZeros(@[2.csize_t, 2])
    let b = newZeros(@[2.csize_t, 2])
    a.set(@[0.csize_t, 0], 1.0)
    
    let result = a.newLogicalOr(b)
    
    check result.get(@[0.csize_t, 0]) == 1.0  # 1 OR 0 = 1
    check result.get(@[0.csize_t, 1]) == 0.0  # 0 OR 0 = 0

  test "Logical NOT":
    let arr = newZeros(@[2.csize_t, 2])
    arr.set(@[0.csize_t, 0], 1.0)
    
    let result = arr.newLogicalNot()
    
    check result.get(@[0.csize_t, 0]) == 0.0  # NOT 1 = 0
    check result.get(@[0.csize_t, 1]) == 1.0  # NOT 0 = 1

suite "Complex Operations":
  test "Chained operations":
    let arr = newOnes(@[2.csize_t, 3])
    arr.addScalar(1.0)  # Now 2.0
    arr.mulScalar(3.0)  # Now 6.0
    
    check arr.get(@[0.csize_t, 0]) == 6.0

  test "Multiple arrays interaction":
    let a = newFull(@[2.csize_t, 2], 2.0)
    let b = newFull(@[2.csize_t, 2], 3.0)
    let c = newFull(@[2.csize_t, 2], 4.0)
    
    a.add(b)  # a = 5.0
    a.mul(c)  # a = 20.0
    
    check a.get(@[0.csize_t, 0]) == 20.0
    check b.get(@[0.csize_t, 0]) == 3.0  # b unchanged
    check c.get(@[0.csize_t, 0]) == 4.0  # c unchanged

suite "Edge Cases":
  test "Minimum dimension constraint (2D)":
    # All arrays must have ndim >= 2
    let arr = newOnes(@[1.csize_t, 5])
    check arr.ndim == 2
    check arr.shape == @[1.csize_t, 5]

  test "Large array operations":
    let arr = newZeros(@[100.csize_t, 100])
    arr.set(@[50.csize_t, 50], 42.0)
    
    check arr.get(@[50.csize_t, 50]) == 42.0
    check arr.get(@[0.csize_t, 0]) == 0.0

  test "3D array operations":
    let arr = newOnes(@[2.csize_t, 3, 4])
    check arr.ndim == 3
    check arr.shape == @[2.csize_t, 3, 4]
    check arr.get(@[1.csize_t, 2, 3]) == 1.0
