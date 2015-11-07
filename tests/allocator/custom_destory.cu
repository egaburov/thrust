#include <unittest/unittest.h>
#include <thrust/device_malloc_allocator.h>
#include <thrust/system/cpp/vector.h>
#include <memory>


static int g_state;

struct my_allocator_with_custom_destroy
{
  typedef int         value_type;
  typedef int &       reference;
  typedef const int & const_reference;

  __host__
  my_allocator_with_custom_destroy(){}

  __host__
  my_allocator_with_custom_destroy(const my_allocator_with_custom_destroy &other)
    : use_me_to_alloc(other.use_me_to_alloc)
  {}

  __host__
  ~my_allocator_with_custom_destroy(){}

  template<typename T>
  __host__ __device__
  void destroy(T *p)
  {
#if !__CUDA_ARCH__
    g_state = 13;
#endif
  }

  value_type *allocate(std::ptrdiff_t n)
  {
    return use_me_to_alloc.allocate(n);
  }

  void deallocate(value_type *ptr, std::ptrdiff_t n)
  {
    use_me_to_alloc.deallocate(ptr,n);
  }
  
  // use composition rather than inheritance
  // to avoid inheriting std::allocator's member
  // function construct
  std::allocator<int> use_me_to_alloc;
};

void TestAllocatorCustomDestroy()
{
  thrust::cpp::vector<int, my_allocator_with_custom_destroy> vec(10);

  // destroy everything
  vec.shrink_to_fit();

  ASSERT_EQUAL(13, g_state);
}
DECLARE_UNITTEST(TestAllocatorCustomDestroy);
