#include <unittest/unittest.h>
#include <thrust/device_malloc_allocator.h>
#include <thrust/system/cpp/vector.h>
#include <memory>

struct my_allocator_with_custom_construct2
  : thrust::device_malloc_allocator<int>
{
  __host__ __device__
  my_allocator_with_custom_construct2()
  {}

  template<typename T, typename Arg>
  __host__ __device__
  void construct(T *p, const Arg &)
  {
    *p = 13;
  }
};

void TestAllocatorCustomCopyConstruct()
{
  thrust::device_vector<int> ref(10,13);
  thrust::device_vector<int> copy_from(10,7);
  thrust::device_vector<int, my_allocator_with_custom_construct2> vec(copy_from.begin(), copy_from.end());

  ASSERT_EQUAL_QUIET(ref, vec);
}
DECLARE_UNITTEST(TestAllocatorCustomCopyConstruct);
