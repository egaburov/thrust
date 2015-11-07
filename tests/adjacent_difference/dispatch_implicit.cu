#include <unittest/unittest.h>
#include <thrust/adjacent_difference.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/retag.h>


template<typename InputIterator, typename OutputIterator>
OutputIterator adjacent_difference(my_tag, InputIterator, InputIterator, OutputIterator result)
{
    *result = 13;
    return result;
}

void TestAdjacentDifferenceDispatchImplicit()
{
    thrust::device_vector<int> d_input(1);

    thrust::adjacent_difference(thrust::retag<my_tag>(d_input.begin()),
                                thrust::retag<my_tag>(d_input.end()),
                                thrust::retag<my_tag>(d_input.begin()));

    ASSERT_EQUAL(13, d_input.front());
}
DECLARE_UNITTEST(TestAdjacentDifferenceDispatchImplicit);
