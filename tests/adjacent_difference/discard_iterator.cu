#include <unittest/unittest.h>
#include <thrust/adjacent_difference.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/retag.h>



template <typename T>
void TestAdjacentDifferenceDiscardIterator(const size_t n)
{
    thrust::host_vector<T>   h_input = unittest::random_samples<T>(n);
    thrust::device_vector<T> d_input = h_input;

    thrust::discard_iterator<> h_result =
      thrust::adjacent_difference(h_input.begin(), h_input.end(), thrust::make_discard_iterator());
    thrust::discard_iterator<> d_result =
      thrust::adjacent_difference(d_input.begin(), d_input.end(), thrust::make_discard_iterator());

    thrust::discard_iterator<> reference(n);

    ASSERT_EQUAL_QUIET(reference, h_result);
    ASSERT_EQUAL_QUIET(reference, d_result);
}
DECLARE_VARIABLE_UNITTEST(TestAdjacentDifferenceDiscardIterator);
