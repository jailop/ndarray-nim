## Basic tests for ndarray creation and memory management

include ../src/ndarray
import std/[unittest, math]

suite "Array Creation":
  test "Create zeros array":
    let arr = newZeros(@[2.csize_t, 3])
    check arr.ndim == 2
    check arr.shape == @[2.csize_t, 3]
    check arr.get(@[0.csize_t, 0]) == 0.0
    check arr.get(@[1.csize_t, 2]) == 0.0

  test "Create ones array":
    let arr = newOnes(@[3.csize_t, 2])
    check arr.ndim == 2
    check arr.shape == @[3.csize_t, 2]
    check arr.get(@[0.csize_t, 0]) == 1.0
    check arr.get(@[2.csize_t, 1]) == 1.0

  test "Create full array":
    let arr = newFull(@[2.csize_t, 2], 5.5)
    check arr.get(@[0.csize_t, 0]) == 5.5
    check arr.get(@[1.csize_t, 1]) == 5.5

  test "Create from data":
    let data = @[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    let arr = newFromData(@[2.csize_t, 3], data)
    check arr.get(@[0.csize_t, 0]) == 1.0
    check arr.get(@[0.csize_t, 1]) == 2.0
    check arr.get(@[0.csize_t, 2]) == 3.0
    check arr.get(@[1.csize_t, 0]) == 4.0
    check arr.get(@[1.csize_t, 1]) == 5.0
    check arr.get(@[1.csize_t, 2]) == 6.0

  test "Create arange array":
    let arr = newArange(@[2.csize_t, 3], 0.0, 6.0, 1.0)
    check arr.get(@[0.csize_t, 0]) == 0.0
    check arr.get(@[1.csize_t, 2]) == 5.0

  test "Create linspace array":
    let arr = newLinspace(@[1.csize_t, 5], 0.0, 1.0, 5)
    check arr.get(@[0.csize_t, 0]) == 0.0
    check abs(arr.get(@[0.csize_t, 4]) - 1.0) < 1e-10

suite "Element Access":
  test "Get and set values":
    let arr = newZeros(@[3.csize_t, 3])
    arr.set(@[0.csize_t, 0], 10.0)
    arr.set(@[1.csize_t, 1], 20.0)
    arr.set(@[2.csize_t, 2], 30.0)
    
    check arr.get(@[0.csize_t, 0]) == 10.0
    check arr.get(@[1.csize_t, 1]) == 20.0
    check arr.get(@[2.csize_t, 2]) == 30.0
    check arr.get(@[0.csize_t, 1]) == 0.0

  test "Set and fill slices":
    let arr = newZeros(@[3.csize_t, 3])
    arr.fillSlice(0, 1, 5.0)  # Fill row 1 with 5.0
    
    check arr.get(@[1.csize_t, 0]) == 5.0
    check arr.get(@[1.csize_t, 1]) == 5.0
    check arr.get(@[1.csize_t, 2]) == 5.0
    check arr.get(@[0.csize_t, 0]) == 0.0  # Other rows unchanged

suite "Memory Management":
  test "Copy creates independent array":
    let original = newOnes(@[2.csize_t, 2])
    original.set(@[0.csize_t, 0], 42.0)
    
    let copied = original.copy()
    copied.set(@[0.csize_t, 0], 99.0)
    
    check original.get(@[0.csize_t, 0]) == 42.0
    check copied.get(@[0.csize_t, 0]) == 99.0

  test "Assignment creates deep copy":
    let a = newOnes(@[2.csize_t, 2])
    a.set(@[0.csize_t, 0], 10.0)
    
    let b = a  # Should trigger =copy
    b.set(@[0.csize_t, 0], 20.0)
    
    check a.get(@[0.csize_t, 0]) == 10.0
    check b.get(@[0.csize_t, 0]) == 20.0

  test "Arrays freed automatically":
    # This test passes if it doesn't leak memory
    for i in 0..100:
      let arr = newOnes(@[10.csize_t, 10])
      discard arr.get(@[5.csize_t, 5])
    # All arrays should be freed automatically

suite "Shape and Properties":
  test "ndim property":
    let arr2d = newOnes(@[3.csize_t, 4])
    check arr2d.ndim == 2

  test "shape property":
    let arr = newOnes(@[3.csize_t, 4, 5])
    let s = arr.shape
    check s.len == 3
    check s[0] == 3
    check s[1] == 4
    check s[2] == 5
