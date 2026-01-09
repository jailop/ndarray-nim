## Tests for arithmetic and mathematical operations

include ../src/ndarray
import std/[unittest, math]

suite "Arithmetic Operations - In Place":
  test "Element-wise addition":
    var a = newFull(@[2.csize_t, 2], 1.0)
    let b = newFull(@[2.csize_t, 2], 2.0)
    a.add(b)
    
    check a.get(@[0.csize_t, 0]) == 3.0
    check a.get(@[1.csize_t, 1]) == 3.0

  test "Element-wise multiplication":
    var a = newFull(@[2.csize_t, 2], 3.0)
    let b = newFull(@[2.csize_t, 2], 4.0)
    a.mul(b)
    
    check a.get(@[0.csize_t, 0]) == 12.0

  test "Add scalar":
    var arr = newOnes(@[2.csize_t, 2])
    arr.addScalar(5.0)
    
    check arr.get(@[0.csize_t, 0]) == 6.0
    check arr.get(@[1.csize_t, 1]) == 6.0

  test "Multiply by scalar":
    var arr = newFull(@[2.csize_t, 2], 3.0)
    arr.mulScalar(2.0)
    
    check arr.get(@[0.csize_t, 0]) == 6.0

  test "Linear combination (axpby)":
    var a = newFull(@[2.csize_t, 2], 2.0)
    let b = newFull(@[2.csize_t, 2], 3.0)
    a.axpby(2.0, b, 3.0)  # a = 2*a + 3*b = 4 + 9 = 13
    
    check a.get(@[0.csize_t, 0]) == 13.0

  test "Scale and shift":
    var arr = newFull(@[2.csize_t, 2], 5.0)
    arr.scaleShift(2.0, 3.0)  # arr = 2*arr + 3 = 10 + 3 = 13
    
    check arr.get(@[0.csize_t, 0]) == 13.0

  test "Clipping operations":
    var arr = newArange(@[1.csize_t, 5], 0.0, 5.0, 1.0)
    arr.clipMin(2.0)
    
    check arr.get(@[0.csize_t, 0]) == 2.0  # Was 0, clipped to 2
    check arr.get(@[0.csize_t, 4]) == 4.0  # Was 4, unchanged

  test "Absolute value":
    let data = @[-1.0, 2.0, -3.0, 4.0]
    var arr = newFromData(@[2.csize_t, 2], data)
    arr.abs()
    
    check arr.get(@[0.csize_t, 0]) == 1.0
    check arr.get(@[1.csize_t, 0]) == 3.0

suite "Comparison Operations":
  test "Element-wise equality":
    let a = newFull(@[2.csize_t, 2], 5.0)
    let b = newFull(@[2.csize_t, 2], 5.0)
    let result = a.newEqual(b)
    
    check result.get(@[0.csize_t, 0]) == 1.0  # True represented as 1.0

  test "Element-wise less than":
    let a = newFull(@[2.csize_t, 2], 3.0)
    let b = newFull(@[2.csize_t, 2], 5.0)
    let result = a.newLess(b)
    
    check result.get(@[0.csize_t, 0]) == 1.0  # 3 < 5 is true

  test "Scalar comparison - greater":
    let arr = newArange(@[1.csize_t, 5], 0.0, 5.0, 1.0)
    let mask = arr.newGreaterScalar(2.0)
    
    check mask.get(@[0.csize_t, 0]) == 0.0  # 0 > 2 is false
    check mask.get(@[0.csize_t, 3]) == 1.0  # 3 > 2 is true

  test "Where operation":
    let condition = newOnes(@[2.csize_t, 2])
    let x = newFull(@[2.csize_t, 2], 10.0)
    let y = newFull(@[2.csize_t, 2], 20.0)
    
    let result = newWhere(condition, x, y)
    check result.get(@[0.csize_t, 0]) == 10.0  # condition is true (1.0)

suite "Aggregation Operations":
  test "Scalar sum":
    let data = @[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    let arr = newFromData(@[2.csize_t, 3], data)
    let sum = arr.scalarAggregate(aggrSum)
    
    check sum == 21.0

  test "Scalar mean":
    let data = @[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    let arr = newFromData(@[2.csize_t, 3], data)
    let mean = arr.scalarAggregate(aggrMean)
    
    check mean == 3.5

  test "Scalar max":
    let data = @[1.0, 5.0, 3.0, 2.0]
    var arr = newFromData(@[2.csize_t, 2], data)
    let maxVal = arr.scalarAggregate(aggrMax)
    
    check maxVal == 5.0

  test "Scalar min":
    let data = @[5.0, 2.0, 8.0, 1.0]
    let arr = newFromData(@[2.csize_t, 2], data)
    let minVal = arr.scalarAggregate(aggrMin)
    
    check minVal == 1.0

  test "Aggregate along axis":
    let data = @[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    let arr = newFromData(@[2.csize_t, 3], data)
    let sumAxis0 = arr.newAggregate(0, aggrSum)
    
    check sumAxis0.ndim == 2
    check sumAxis0.get(@[0.csize_t, 0]) == 5.0  # 1 + 4
    check sumAxis0.get(@[0.csize_t, 1]) == 7.0  # 2 + 5
    check sumAxis0.get(@[0.csize_t, 2]) == 9.0  # 3 + 6

suite "Matrix Operations":
  test "Matrix multiplication":
    let a = newOnes(@[2.csize_t, 3])
    let b = newOnes(@[3.csize_t, 2])
    let c = a.newMatmul(b)
    
    check c.ndim == 2
    check c.shape == @[2.csize_t, 2]
    check c.get(@[0.csize_t, 0]) == 3.0  # Sum of 3 ones

  test "Transpose":
    let data = @[1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
    let arr = newFromData(@[2.csize_t, 3], data)
    let t = arr.newTranspose()
    
    check t.shape == @[3.csize_t, 2]
    check t.get(@[0.csize_t, 0]) == 1.0
    check t.get(@[0.csize_t, 1]) == 4.0
    check t.get(@[1.csize_t, 0]) == 2.0

suite "Manipulation Operations":
  test "Reshape":
    let arr = newArange(@[2.csize_t, 6], 0.0, 12.0, 1.0)
    arr.reshape(@[3, 4])
    
    check arr.shape == @[3.csize_t, 4]
    check arr.get(@[0.csize_t, 0]) == 0.0
    check arr.get(@[2.csize_t, 3]) == 11.0

  test "Take slice":
    let arr = newArange(@[1.csize_t, 10], 0.0, 10.0, 1.0)
    let slice = arr.newTake(1, 2, 5)  # Take elements 2,3,4 along axis 1
    
    check slice.shape[1] == 3
    check slice.get(@[0.csize_t, 0]) == 2.0
    check slice.get(@[0.csize_t, 2]) == 4.0

suite "Random Arrays":
  test "Random uniform values in range":
    let arr = newRandomUniform(@[5.csize_t, 5], 0.0, 1.0)
    
    # Check all values are in range [0, 1]
    var allInRange = true
    for i in 0..<5:
      for j in 0..<5:
        let val = arr.get(@[csize_t(i), csize_t(j)])
        if val < 0.0 or val > 1.0:
          allInRange = false
    
    check allInRange

  test "Random normal distribution exists":
    # Just check it creates an array without errors
    let arr = newRandomNormal(@[3.csize_t, 3], 0.0, 1.0)
    check arr.ndim == 2
    check arr.shape == @[3.csize_t, 3]
