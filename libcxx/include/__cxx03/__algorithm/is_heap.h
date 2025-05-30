//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef _LIBCPP___CXX03___ALGORITHM_IS_HEAP_H
#define _LIBCPP___CXX03___ALGORITHM_IS_HEAP_H

#include <__cxx03/__algorithm/comp.h>
#include <__cxx03/__algorithm/comp_ref_type.h>
#include <__cxx03/__algorithm/is_heap_until.h>
#include <__cxx03/__config>
#include <__cxx03/__iterator/iterator_traits.h>

#if !defined(_LIBCPP_HAS_NO_PRAGMA_SYSTEM_HEADER)
#  pragma GCC system_header
#endif

_LIBCPP_BEGIN_NAMESPACE_STD

template <class _RandomAccessIterator, class _Compare>
_LIBCPP_NODISCARD inline _LIBCPP_HIDE_FROM_ABI bool
is_heap(_RandomAccessIterator __first, _RandomAccessIterator __last, _Compare __comp) {
  return std::__is_heap_until(__first, __last, static_cast<__comp_ref_type<_Compare> >(__comp)) == __last;
}

template <class _RandomAccessIterator>
_LIBCPP_NODISCARD inline _LIBCPP_HIDE_FROM_ABI bool
is_heap(_RandomAccessIterator __first, _RandomAccessIterator __last) {
  return std::is_heap(__first, __last, __less<>());
}

_LIBCPP_END_NAMESPACE_STD

#endif // _LIBCPP___CXX03___ALGORITHM_IS_HEAP_H
