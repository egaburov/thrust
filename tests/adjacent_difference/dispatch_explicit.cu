#include <unittest/unittest.h>
#include <thrust/adjacent_difference.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/retag.h>


template<typename InputIterator, typename OutputIterator>
OutputIterator adjacent_difference(my_system &system, InputIterator, InputIterator, OutputIterator result)
{
    system.validate_dispatch();
    return result;
}

void TestAdjacentDifferenceDispatchExplicit()
{
    thrust::device_vector<int> d_input(1);

    my_system sys(0);
    thrust::adjacent_difference(sys,
                                d_input.begin(),
                                d_input.end(),
                                d_input.begin());

    ASSERT_EQUAL(true, sys.is_valid());
}
DECLARE_UNITTEST(TestAdjacentDifferenceDispatchExplicit);
