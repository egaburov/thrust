#include <unittest/unittest.h>
#include <thrust/device_malloc_allocator.h>
#include <thrust/system/cpp/vector.h>
#include <memory>



struct my_minimal_allocator
{
  typedef int         value_type;

  // XXX ideally, we shouldn't require
  //     these two typedefs
  typedef int &       reference;
  typedef const int & const_reference;

  __host__
  my_minimal_allocator(){}

  __host__
  my_minimal_allocator(const my_minimal_allocator &other)
    : use_me_to_alloc(other.use_me_to_alloc)
  {}

  __host__
  ~my_minimal_allocator(){}

  value_type *allocate(std::ptrdiff_t n)
  {
    return use_me_to_alloc.allocate(n);
  }

  void deallocate(value_type *ptr, std::ptrdiff_t n)
  {
    use_me_to_alloc.deallocate(ptr,n);
  }

  std::allocator<int> use_me_to_alloc;
};

void TestAllocatorMinimal()
{
  thrust::cpp::vector<int, my_minimal_allocator> vec(10, 13);

  // XXX copy to h_vec because ASSERT_EQUAL doesn't know about cpp::vector
  thrust::host_vector<int> h_vec(vec.begin(), vec.end());
  thrust::host_vector<int> ref(10, 13);

  ASSERT_EQUAL(ref, h_vec);
}
DECLARE_UNITTEST(TestAllocatorMinimal);
