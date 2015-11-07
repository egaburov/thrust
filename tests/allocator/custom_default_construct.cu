#include <unittest/unittest.h>
#include <thrust/device_malloc_allocator.h>
#include <thrust/system/cpp/vector.h>
#include <memory>

struct my_allocator_with_custom_construct1
  : thrust::device_malloc_allocator<int>
{
  __host__ __device__
  my_allocator_with_custom_construct1()
  {}

  template<typename T>
  __host__ __device__
  void construct(T *p)
  {
    *p = 13;
  }
};

void TestAllocatorCustomDefaultConstruct()
{
  thrust::device_vector<int> ref(10,13);
  thrust::device_vector<int, my_allocator_with_custom_construct1> vec(10);

  ASSERT_EQUAL_QUIET(ref, vec);
}
DECLARE_UNITTEST(TestAllocatorCustomDefaultConstruct);
