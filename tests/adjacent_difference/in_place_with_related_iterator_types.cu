#include <unittest/unittest.h>
#include <thrust/adjacent_difference.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/retag.h>


template<typename T>
void TestAdjacentDifferenceInPlaceWithRelatedIteratorTypes(const size_t n)
{
    thrust::host_vector<T>   h_input = unittest::random_samples<T>(n);
    thrust::device_vector<T> d_input = h_input;

    thrust::host_vector<T>   h_output(n);
    thrust::device_vector<T> d_output(n);

    typename thrust::host_vector<T>::iterator   h_result;
    typename thrust::device_vector<T>::iterator d_result;

    h_result = thrust::adjacent_difference(h_input.begin(), h_input.end(), h_output.begin(), thrust::plus<T>());
    d_result = thrust::adjacent_difference(d_input.begin(), d_input.end(), d_output.begin(), thrust::plus<T>());
    
    // in-place operation with different iterator types
    h_result = thrust::adjacent_difference(h_input.cbegin(), h_input.cend(), h_input.begin(), thrust::plus<T>());
    d_result = thrust::adjacent_difference(d_input.cbegin(), d_input.cend(), d_input.begin(), thrust::plus<T>());

    ASSERT_EQUAL(h_result - h_input.begin(), n);
    ASSERT_EQUAL(d_result - d_input.begin(), n);
    ASSERT_EQUAL(h_output, h_input); // reference computed previously
    ASSERT_EQUAL(d_output, d_input); // reference computed previously
}
DECLARE_VARIABLE_UNITTEST(TestAdjacentDifferenceInPlaceWithRelatedIteratorTypes);
