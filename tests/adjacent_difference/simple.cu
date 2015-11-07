#include <unittest/unittest.h>
#include <thrust/adjacent_difference.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/retag.h>

template <class Vector>
void TestAdjacentDifferenceSimple(void)
{
    typedef typename Vector::value_type T;

    Vector input(3);
    Vector output(3);
    input[0] = 1; input[1] = 4; input[2] = 6;

    typename Vector::iterator result;
    
    result = thrust::adjacent_difference(input.begin(), input.end(), output.begin());

    ASSERT_EQUAL(result - output.begin(), 3);
    ASSERT_EQUAL(output[0], T(1));
    ASSERT_EQUAL(output[1], T(3));
    ASSERT_EQUAL(output[2], T(2));
    
    result = thrust::adjacent_difference(input.begin(), input.end(), output.begin(), thrust::plus<T>());
    
    ASSERT_EQUAL(result - output.begin(), 3);
    ASSERT_EQUAL(output[0], T( 1));
    ASSERT_EQUAL(output[1], T( 5));
    ASSERT_EQUAL(output[2], T(10));
    
    // test in-place operation, result and first are permitted to be the same
    result = thrust::adjacent_difference(input.begin(), input.end(), input.begin());

    ASSERT_EQUAL(result - input.begin(), 3);
    ASSERT_EQUAL(input[0], T(1));
    ASSERT_EQUAL(input[1], T(3));
    ASSERT_EQUAL(input[2], T(2));
}
DECLARE_VECTOR_UNITTEST(TestAdjacentDifferenceSimple);
