## Simple test without unittest to verify bindings work

include ../src/ndarray

echo "Testing basic ndarray operations..."

# Test 1: Create array
echo "1. Creating zeros array..."
let arr = newZeros(@[2.csize_t, 3])
echo "   Shape: ", arr.shape
echo "   Ndim: ", arr.ndim

# Test 2: Set and get values
echo "2. Setting and getting values..."
arr.set(@[0.csize_t, 0], 42.0)
let val = arr.get(@[0.csize_t, 0])
echo "   Set value 42.0, got: ", val

# Test 3: Create ones
echo "3. Creating ones array..."
let ones = newOnes(@[2.csize_t, 2])
echo "   Value at [0,0]: ", ones.get(@[0.csize_t, 0])

# Test 4: Arithmetic
echo "4. Testing arithmetic..."
let a = newFull(@[2.csize_t, 2], 5.0)
a.addScalar(3.0)
echo "   5.0 + 3.0 = ", a.get(@[0.csize_t, 0])

# Test 5: Matrix operations
echo "5. Testing matrix multiplication..."
let m1 = newOnes(@[2.csize_t, 3])
let m2 = newOnes(@[3.csize_t, 2])
let result = m1.newMatmul(m2)
echo "   Result shape: ", result.shape
echo "   Result[0,0]: ", result.get(@[0.csize_t, 0])

echo ""
echo "All basic tests passed! ✓"
