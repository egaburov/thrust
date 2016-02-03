#include <thrust/iterator/iterator_traits.h>
#include <thrust/iterator/iterator_facade.h>
#include <thrust/iterator/iterator_adaptor.h>

#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>
#include <thrust/set_operations.h>
#include <thrust/copy.h>
#include <thrust/device_vector.h>  
#include <iostream>
#include <cstdint>

#define PRINTER(name) print(#name, (name))
template <template <typename...> class V, typename T, typename ...Args>
void print(const char* name, const V<T,Args...> & v)
{
    std::cout << name << ":\t";
    thrust::copy(v.begin(), v.end(), std::ostream_iterator<T>(std::cout, "\t"));
    std::cout << std::endl;
}


template <typename OutputIterator, typename UnaryFunction>
class Proxy
{
    UnaryFunction& fun;
    OutputIterator& out;

public:
    __host__ __device__
    Proxy(UnaryFunction& fun, OutputIterator& out) : fun(fun), out(out) {}

    template <typename T>
    __host__ __device__
    Proxy operator=(const T& x) const
    {
        *out = fun(x);
        return *this;
    }
};


// This iterator is a wrapper around another OutputIterator which
// applies a UnaryFunction before writing to the OutputIterator.
template <typename OutputIterator, typename UnaryFunction>
class transform_output_iterator : public thrust::iterator_adaptor<
                                    transform_output_iterator<OutputIterator, UnaryFunction>
                                                                      , OutputIterator
                                      , thrust::use_default
                                      , thrust::use_default
                                      , thrust::use_default
                                                                      , Proxy<const OutputIterator, const UnaryFunction> >
{
    UnaryFunction fun;

public:

    friend class thrust::iterator_core_access;

    // shorthand for the name of the iterator_adaptor we're deriving from
    typedef thrust::iterator_adaptor<
      transform_output_iterator<OutputIterator, UnaryFunction>,
      OutputIterator, thrust::use_default, thrust::use_default, thrust::use_default, Proxy<const OutputIterator, const UnaryFunction>
    > super_t;

    __host__ __device__
    transform_output_iterator(OutputIterator out, UnaryFunction fun) : super_t(out), fun(fun)
    {
    }


private:
    __host__ __device__
    typename super_t::reference dereference() const
    {
        return Proxy<const OutputIterator, const UnaryFunction>(fun, this->base_reference());
    }
};


struct Multiplier
{
    template<typename Tuple>
    __host__ __device__
    auto operator()(Tuple t) const -> decltype(thrust::get<0>(t) * thrust::get<1>(t))
    {
        return thrust::get<0>(t) * thrust::get<1>(t);
    }
};


template <typename OutputIterator, typename UnaryFunction>
transform_output_iterator<OutputIterator, UnaryFunction>
__host__ __device__
make_transform_output_iterator(OutputIterator out, UnaryFunction fun)
{
    return transform_output_iterator<OutputIterator, UnaryFunction>(out, fun);
}

int main()
{
  int Lkeys[] =   { 1, 2, 4, 5, 6 };
  int Lvals[] =   { 3, 4, 1, 2, 1 };
  int Rkeys[] =   { 1, 3, 4, 5, 6, 7 };
  int Rvals[] =   { 2, 1, 1, 4, 1, 2 };

  size_t Lsize = sizeof(Lkeys)/sizeof(int);
  size_t Rsize = sizeof(Rkeys)/sizeof(int);

  thrust::device_vector<int> Lkeysv(Lkeys, Lkeys+Lsize);
  thrust::device_vector<int> Lvalsv(Lvals, Lvals+Lsize);
  thrust::device_vector<int> Rkeysv(Rkeys, Rkeys+Rsize);
  thrust::device_vector<int> Rvalsv(Rvals, Rvals+Rsize);

  std::size_t min_size = std::min(Lsize, Rsize);

  thrust::device_vector<int> result_keys(min_size);
  thrust::device_vector<int> result_values(min_size);

  auto zipped_values = thrust::make_zip_iterator(thrust::make_tuple(Lvalsv.begin(), Rvalsv.begin()));

  auto output_it = make_transform_output_iterator(result_values.begin(), Multiplier());

  auto result_pair = thrust::set_intersection_by_key(Lkeysv.begin(), Lkeysv.end(), Rkeysv.begin(), Rkeysv.end(), zipped_values, result_keys.begin(), output_it);

  std::size_t new_size = result_pair.first - result_keys.begin();

  result_keys.resize(new_size);
  result_values.resize(new_size);
  PRINTER(result_keys);
  PRINTER(result_values);
}
