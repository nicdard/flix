/*
 * Copyright 2019 Magnus Madsen, Esben Bjerre
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

///
/// Represents a mutable list.
///
/// Invariant
///   - The length is always higher than the total capacity of the array.
///   - The capacity of the array is always 8 or more.
///
pub enum MutList[a] {
    case MutList(Ref[Array[a]], Ref[Int32])
}

instance Iterable[MutList] {
    pub def iterator(t: MutList[a]): Iterator[a] & Impure =
        let MutList(a, l) = t;
        let i = ref 0;
        let done = () -> deref i == deref l;
        let next = () -> {
                if (deref i != deref l) {
                    let elem = Array.get(deref i, deref a);
                    i := deref i + 1;
                    elem
                }
                else {
                    bug!("Empty Iterator!")
                }
            };
        Iterator(done, next)
}

namespace MutList {

    ///
    /// Constant which stores the minimum capacity of a MutList.
    ///
    @Internal
    pub def minCapacity(): Int32 = 8

    ///
    /// Returns a new empty mutable list with a default capacity.
    ///
    pub def new(): MutList[a] & Impure = MutList(ref [$DEFAULT$; minCapacity()], ref 0)

    ///
    /// Returns a mutable list of all integers between `b` (inclusive) and `e` (exclusive).
    ///
    /// Returns an empty mutable list if `b >= e`.
    ///
    pub def range(b: Int32, e: Int32): MutList[Int32] & Impure =
        let minCap = minCapacity();
        if (e - b < minCap)
            let f = i -> if (b + i < e) b + i else $DEFAULT$;
            MutList(ref Array.init(f, minCap), ref (e - b))
        else
            MutList(ref Array.range(b, e), ref (e - b))

    ///
    /// Returns the element at position `i` in the mutable list `v`.
    ///
    pub def get(i: Int32, v: MutList[a]): a & Impure =
        let MutList(a, l) = v;
        if (i >= deref l)
            bug!("Invalid argument ${i}")
        else
            (deref a)[i]

    ///
    /// Returns the number of elements in the given mutable list `v`.
    ///
    pub def length(v: MutList[a]): Int32 & Impure =
        let MutList(_, l) = v;
        deref l

    ///
    /// Returns `true` if the given mutable list `v` is empty.
    ///
    pub def isEmpty(v: MutList[a]): Bool & Impure = length(v) == 0

    ///
    /// Returns `true` if the given element `x` is a member of the given mutable list `v`.
    ///
    pub def memberOf(x: a, v: MutList[a]): Bool & Impure with Eq[a] = exists(y -> y == x, v)

    ///
    /// Optionally finds the smallest element of `v` according to the `Order` on `a`.
    ///
    /// Returns `None` if `v` is empty.
    ///
    pub def minimum(v: MutList[a]): Option[a] & Impure with Order[a] =
        reduceLeft(Order.min, v)

    ///
    /// Optionally finds the smallest element of `v` according to the given comparator `cmp`.
    ///
    /// Returns `None` if `v` is empty.
    ///
    pub def minimumBy(cmp: (a, a) -> Comparison, v: MutList[a]): Option[a] & Impure =
        reduceLeft(Order.minBy(cmp), v)

    ///
    /// Optionally finds the largest element of `v` according to the `Order` on `a`.
    ///
    /// Returns `None` if `v` is empty.
    ///
    pub def maximum(v: MutList[a]): Option[a] & Impure with Order[a] =
        reduceLeft(Order.max, v)

    ///
    /// Optionally finds the largest element of `v` according to the given comparator `cmp`.
    ///
    /// Returns `None` if `v` is empty.
    ///
    pub def maximumBy(cmp: (a, a) -> Comparison, v: MutList[a]): Option[a] & Impure =
        reduceLeft(Order.maxBy(cmp), v)

    ///
    /// Returns the number of elements in the given mutable list `v` that satisfies the given predicate `f`.
    ///
    /// Returns `0` if the given mutable list `v` is empty.
    ///
    pub def count(f: a -> Bool, v: MutList[a]): Int32 & Impure =
        foldLeft((acc, x) -> if (f(x)) acc + 1 else acc, 0, v)

    ///
    /// Returns the sum of all elements in the MutList `v`.
    ///
    pub def sum(v: MutList[Int32]): Int32 & Impure =
        foldLeft((acc, x) -> acc + x, 0, v)

    ///
    /// Returns the sum of all elements in the MutList `v` according to the function `f`.
    ///
    pub def sumWith(f: a -> Int32 & ef, v: MutList[a]): Int32 & Impure =
        foldLeft((acc, x) -> acc + f(x), 0, v)

    ///
    /// Returns the product of all elements in the mutable list `v`.
    ///
    pub def product(v: MutList[Int32]): Int32 & Impure =
        if (isEmpty(v))
            0
        else
            foldLeft((acc, x) -> acc * x, 1, v)

    ///
    /// Returns the product of all elements in the mutable list `v` according to the function `f`.
    ///
    pub def productWith(f: a -> Int32 & ef, v: MutList[a]): Int32 & Impure =
        if (isEmpty(v))
            0
        else
            foldLeft((acc, x) -> acc * f(x), 1, v)

    ///
    /// Returns `true` if the given predicate `f` holds for at least one element of the given mutable list `v`.
    ///
    /// Returns `false` if the given mutable list `v` is empty.
    ///
    pub def exists(f: a -> Bool, v: MutList[a]): Bool & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                false
            else
                if (f(a[i])) true else loop(i + 1)
        };
        loop(0)

    ///
    /// Returns `true` if the given predicate `f` holds for all elements of the given mutable list `v`.
    ///
    /// Returns `true` if the given mutable list `v` is empty.
    ///
    pub def forall(f: a -> Bool, v: MutList[a]): Bool & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                true
            else
                if (f(a[i])) loop(i + 1) else false
        };
        loop(0)

    ///
    /// Optionally returns the first element of the given mutable list `v`.
    ///
    /// Returns `None` if the given mutable list `v` is empty.
    ///
    pub def head(v: MutList[a]): Option[a] & Impure =
        let MutList(a, _) = v;
        if (isEmpty(v))
            None
        else
            Array.head(deref a)

    ///
    /// Optionally returns the last element of the given mutable list `v`.
    ///
    /// Returns `None` if the given mutable list `v` is empty.
    ///
    pub def last(v: MutList[a]): Option[a] & Impure =
        let MutList(a, l) = v;
        let len = deref l;
        if (len > 0) Some((deref a)[len - 1]) else None

    ///
    /// Alias for `IndexOfLeft`
    ///
    pub def indexOf(x: a, v: MutList[a]): Option[Int32] & Impure with Eq[a] = indexOfLeft(x, v)

    ///
    /// Optionally returns the position of the first occurrence of `x` in `v`
    /// searching from left to right.
    ///
    pub def indexOfLeft(x: a, v: MutList[a]): Option[Int32] & Impure with Eq[a] =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                None
            else
                if (x == a[i]) Some(i) else loop(i + 1)
        };
        loop(0)

    ///
    /// Optionally returns the position of the first occurrence of `x` in `v`
    /// searching from right to left.
    ///
    pub def indexOfRight(x: a, v: MutList[a]): Option[Int32] & Impure with Eq[a] =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i < 0)
                None
            else
                if (x == a[i]) Some(i) else loop(i - 1)
        };
        loop(l - 1)

    ///
    /// Alias for `findLeft`.
    ///
    pub def find(f: a -> Bool, v: MutList[a]): Option[a] & Impure = findLeft(f, v)

    ///
    /// Optionally returns the left-most element in the given mutable list `v` that satisfies the given predicate `f`.
    ///
    /// Returns `None` if no element satisfies the given predicate `f`.
    /// Returns `None` if the given mutable list `v` is empty.
    ///
    pub def findLeft(f: a -> Bool, v: MutList[a]): Option[a] & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                None
            else
                if (f(a[i])) Some(a[i]) else loop(i + 1)

        };
        loop(0)

    ///
    /// Optionally returns the right-most element in the given mutable list `v` that satisfies the given predicate `f`.
    ///
    /// Returns `None` if no element satisfies the given predicate `f`.
    /// Returns `None` if the given mutable list `v` is empty.
    ///
    pub def findRight(f: a -> Bool, v: MutList[a]): Option[a] & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i < 0)
                None
            else
                if (f(a[i])) Some(a[i]) else loop(i - 1)
        };
        loop(l - 1)

    ///
    /// Alias for `scanLeft`.
    ///
    pub def scan(f: (b, a) ->b & ef, s: b, v: MutList[a]): MutList[b] & Impure = scanLeft(f, s, v)

    ///
    /// Accumulates the result of applying `f` to `v` going left to right.
    ///
    pub def scanLeft(f: (b, a) -> b & ef, s: b, v: MutList[a]): MutList[b] & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        let n = l + 1;
        let b = [s; n];
        def loop(i, acc) = {
            if (i >= n)
                ()
            else {
                let s1 = f(acc, a[i - 1]);
                b[i] = s1;
                loop(i + 1, s1)
            }
        };
        loop(1, s);
        MutList(ref b, ref n)

    ///
    /// Accumulates the result of applying `f` to `v` going right to left.
    ///
    pub def scanRight(f: (a, b) -> b & ef, s: b, v: MutList[a]): MutList[b] & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        let n = l + 1;
        let b = [s; n];
        def loop(i, acc) = {
            if (i < 0)
                ()
            else {
                let s1 = f(a[i], acc);
                b[i] = s1;
                loop(i - 1, s1)
            }
        };
        loop(l - 1, s);
        MutList(ref b, ref n)

    ///
    /// Apply `f` to every element in `v`.
    ///
    /// The result is a new mutable list.
    ///
    pub def map(f: a -> b & ef, v: MutList[a]): MutList[b] & Impure =
        if (isEmpty(v))
            new()
        else {
            let MutList(ra, rl) = v;
            let a = deref ra;
            let l = deref rl;
            let x = f(a[0]);
            let b = [x; Array.length(a)];
            def loop(i) = {
                if (i >= l)
                    ()
                else {
                    b[i] = f(a[i]);
                    loop(i + 1)
                }
            };
            loop(1);
            MutList(ref b, ref l)
        }

    ///
    /// Apply `f` to every element in `v`.
    ///
    pub def transform!(f: a -> a, v: MutList[a]): Unit & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                ()
            else {
                a[i] = f(a[i]);
                loop(i + 1)
            }
        };
        loop(0)

    ///
    /// Returns the result of applying `f` to every element in `v` along with that element's index.
    ///
    pub def mapWithIndex(f: (a, Int32) -> b & ef, v: MutList[a]): MutList[b] & Impure =
        if (isEmpty(v))
            new()
        else {
            let MutList(ra, rl) = v;
            let a = deref ra;
            let l = deref rl;
            let x = f(a[0], 0);
            let b = [x; Array.length(a)];
            def loop(i) = {
                if (i >= l)
                    ()
                else {
                    b[i] = f(a[i], i);
                    loop(i + 1)
                }
            };
            loop(1);
            MutList(ref b, ref l)
        }

    ///
    /// Apply `f` to every element in `v` along with that element's index.
    ///
    pub def transformWithIndex!(f: (a, Int32) -> a, v: MutList[a]): Unit & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                ()
            else {
                a[i] = f(a[i], i);
                loop(i + 1)
            }
        };
        loop(0)

    ///
    /// Applies `f` to a start value `s` and all elements in `a` going from left to right.
    ///
    /// That is, the result is of the form: `f(...f(f(s, a[0]), a[1])..., xn)`.
    ///
    pub def foldLeft(f: (b, a) -> b & ef, s: b, v: MutList[a]): b & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i, acc) = {
            if (i >= l)
                acc
            else {
                let s1 = f(acc, a[i]);
                loop(i + 1, s1)
            }
        };
        loop(0, s)

    ///
    /// Applies `f` to a start value `s` and all elements in `a` going from left to right.
    ///
    /// That is, the result is of the form: `f(...f(f(s, a[0]), a[1])..., xn)`.
    ///
    /// The implementation is tail recursive.
    ///
    pub def foldRight(f: (a, b) -> b & ef, s: b, v: MutList[a]): b & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i, acc) = {
            if (i < 0)
                acc
            else {
                let s1 = f(a[i], acc);
                loop(i - 1, s1)
            }
        };
        loop(l - 1, s)

    ///
    /// Applies `f` to a start value `s` and all elements in `v` going from left to right.
    ///
    /// That is, the result is of the form: `f(x1, ...lazy f(xn-1, lazy f(xn, s))...)`.
    /// The foldRightLazy function exists to allow early termination of a fold.
    ///
    pub def foldRightLazy(f: (a, Lazy[b]) -> b & ef, s: b, v: MutList[a]): b & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i, acc) = {
            if (i < 0)
                acc
            else {
                let s1 = f(a[i], lazy acc);
                loop(i - 1, s1)
            }
        };
        loop(l - 1, s)

    ///
    /// Applies `f` to all elements in `v` going from left to right until a single value `v` is obtained. Returns `Some(v)`.
    ///
    /// Returns `None` if `v` is empty.
    ///
    pub def reduceLeft(f: (a, a) -> a & ef, v: MutList[a]): Option[a] & Impure = foldLeft((acc, x) -> match acc {
        case Some(y) => Some(f(y, x))
        case None => Some(x)
    }, None, v)

    ///
    /// Applies `f` to all elements in `v` going from right to left until a single value `v` is obtained. Returns `Some(v)`.
    ///
    /// Returns `None` if `v` is empty.
    ///
    pub def reduceRight(f: (a, a) -> a & ef, v: MutList[a]): Option[a] & Impure = foldRight((x, acc) -> match acc {
        case Some(y) => Some(f(x, y))
        case None => Some(x)
    }, None, v)

    ///
    /// Removes all elements from the given mutable list `v`.
    ///
    pub def clear!(v: MutList[a]): Unit & Impure =
        let MutList(a, l) = v;
        a := Array.new($DEFAULT$, Array.length(deref a));
        l := 0

    ///
    /// Returns a shallow copy of the given mutable list `v`.
    /// The capacity of the copy is equal to the length of the list.
    ///
    pub def copy(v: MutList[a]): MutList[a] & Impure =
        let MutList(a, l) = v;
        let len = deref l;
        if (len > minCapacity())
            MutList(ref Array.copyOfRange(0, len, deref a), ref len)
        else
            MutList(ref Array.copyOfRange(0, capacity(v), deref a), ref len)

    ///
    /// Optionally removes and returns the last element in the given mutable list `v`.
    ///
    pub def pop!(v: MutList[a]): Option[a] & Impure =
        let MutList(a, l) = v;
        let len = deref l;
        if (len > 0)
            let last = (deref a)[len - 1];
            l := len - 1;
            Array.put($DEFAULT$, len - 1, deref a);
            compress!(v);
            Some(last)
        else
            None

    ///
    /// Inserts the given element `x` at the end of the given mutable list `v`.
    ///
    pub def push!(x: a, v: MutList[a]): Unit & Impure =
        let MutList(a, l) = v;
        let len = deref l;
        if (capacity(v) - len == 0)
            reserve!(len, v)
        else ();
        (deref a)[len] = x;
        l := len + 1

    ///
    /// Inserts the given element `x` at the given position `i` in the given mutable list `v`.
    ///
    /// Shifts elements as necessary. Possibly expensive operation.
    ///
    /// If the given index `i` exceeds the length of the mutable list, the element is inserted at the last position.
    ///
    pub def insert!(x: a, i: Int32, v: MutList[a]): Unit & Impure =
        let MutList(a, l) = v;
        let len = deref l;
        if (capacity(v) - len == 0)
            reserve!(len, v)
        else ();
        let sub = Array.copyOfRange(i, len, deref a);
        Array.updateSequence!(i + 1, sub, deref a);
        (deref a)[i] = x;
        l := len + 1

    ///
    /// Removes the element at the given position `i` in the given mutable list `v`.
    ///
    /// Shifts elements as necessary. Possibly expensive operation.
    ///
    /// If the given index `i` exceeds the length of the mutable list, no element is removed.
    ///
    pub def remove!(i: Int32, v: MutList[a]): Unit & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        let n = l - 1;
        def loop(i) = {
            if (i < n) {
                a[i] = a[i + 1];
                loop(i + 1)
            }
            else if (i == n) {
                a[i] = $DEFAULT$
            }
            else
                ()
        };
        if (i < l) {
            loop(i);
            rl := n;
            compress!(v)
        }
        else
            ()

    ///
    /// Inserts all the elements in the collection `t` into the mutable list `v`.
    ///
    pub def append!(t: t[a], v: MutList[a]): Unit & Impure with Iterable[t] =
        let iter = Iterable.iterator(t);
        Iterator.foreach(x -> MutList.push!(x, v), iter)

    ///
    /// Removes all elements from the given mutable list `v` that do not satisfy the given predicate `f`.
    ///
    pub def retain!(f: a -> Bool, v: MutList[a]): Unit & Impure =
        let MutList(a1, l1) = v;
        let l = new();
        foreach(e -> if (f(e)) push!(e, l) else (), v);
        let MutList(a2, l2) = l;
        a1 := deref a2;
        l1 := deref l2

    ///
    /// Replaces all occurrences of the `from` with `to` in the given mutable list `v`.
    ///
    pub def replace!(from: {from :: a}, to: {to :: a}, v: MutList[a]): Unit & Impure with Eq[a] =
        transform!(e -> if (e == from.from) to.to else e, v)

    ///
    /// Reverses the order of the elements in the given mutable list `v`.
    ///
    pub def reverse!(v: MutList[a]): Unit & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        let halflen = l / 2;
        def loop(i, j) = {
            if (i >= halflen)
                ()
            else {
                let x = a[i];
                let y = a[j];
                Array.put(y, i, a);
                Array.put(x, j, a);
                loop(i + 1, j - 1)
            }
        };
        loop(0, l - 1)

    ///
    /// Shrinks the given mutable list `v` down to a capacity of `n` elements but no less than 8.
    ///
    /// Truncates the mutable list as needed.
    ///
    def shrinkTo!(n: Int32, v: MutList[a]): Unit & Impure =
        let minCap = minCapacity();
        let capv = capacity(v);
        let MutList(a, l) = v;
        if (n < capv and capv != minCap) {
            let len = deref l;
            let newCap = Order.max(n, minCap);
            a := Array.copyOfRange(0, newCap, deref a);
            l := Order.min(len, newCap)
        }
        else ()

    ///
    /// Shrinks the given mutable list `v` to its actual size.
    ///
    pub def shrink!(v: MutList[a]): Unit & Impure = shrinkTo!(length(v), v)

    ///
    /// Truncates the given mutable list `v` to the given length `l`.
    ///
    /// That is, after the operation, the mutable list has length at most `l`.
    ///
    /// If the given length `l` is negative, all elements are removed.
    ///
    pub def truncate!(l: Int32, v: MutList[a]): Unit & Impure =
        if (l < 0)
            clear!(v)
        else if (l < length(v)) {
            let MutList(a, l0) = v;
            let minCap = minCapacity();
            let c = Order.max(l, minCap);
            l0 := l;
            Array.updateSequence!(0, deref a, Array.new($DEFAULT$, c))
        }
        else
            ()

    ///
    /// Increases the capacity of the given mutable list `v` by at least `n`.
    ///
    /// That is, after the call, the mutable list is guaranteed to have space for at least `n` additional elements.
    ///
    /// The content of the mutable list is unchanged.
    ///
    pub def reserve!(n: Int32, v: MutList[a]): Unit & Impure =
        let MutList(a, l) = v;
        a := Array.copyOfRange(0, (deref l) + n, deref a)

    ///
    /// Returns `v` as an immutable list.
    ///
    pub def toList(v: MutList[a]): List[a] & Impure =
        foldRight((x, acc) -> x :: acc, Nil, v)

    ///
    /// Returns `v` as an array.
    ///
    pub def toArray(v: MutList[a]): Array[a] & Impure =
        let MutList(a, l) = v;
        Array.copyOfRange(0, deref l, deref a)

    ///
    /// Returns the mutable list `xs` as a chain.
    ///
    pub def toChain(xs: MutList[a]): Chain[a] & Impure =
        foldLeft((ac, x) -> Chain.snoc(ac, x), Chain.empty(), xs)

    ///
    /// Returns `true` if the mutable lists `v1` and `v2` have the same elements, i.e. are structurally equal.
    ///
    pub def sameElements(v1: MutList[a], v2: MutList[a]): Bool & Impure with Eq[a] =
        let MutList(ra1, rl1) = v1;
        let MutList(ra2, rl2) = v2;
        let a1 = deref ra1;
        let a2 = deref ra2;
        let l1 = deref rl1;
        let l2 = deref rl2;
        def loop(i) = {
            if (i >= l1)
                true
            else if (a1[i] == a2[i])
                loop(i + 1)
            else
                false
        };
        if (l1 == l2) loop(0) else false

    ///
    /// Render `v` as a String. Elements are rendered with the
    /// function `f` and separated with the string `sep`.
    ///
    pub def formatWith(f: a -> String, sep: String, v: MutList[a]): String & Impure =
        let sb = StringBuilder.new();
        let step = (x,i) ->
            if (i == 0)
                StringBuilder.appendString!(f(x), sb)
            else {
                StringBuilder.appendString!(sep, sb);
                StringBuilder.appendString!(f(x), sb)
            };
        foreachWithIndex(step, v);
        StringBuilder.toString(sb)

    ///
    /// Returns the concatenation of the string representation
    /// of each element in `v` with `sep` inserted between each element.
    ///
    pub def join(sep: String, v: MutList[a]): String & Impure with ToString[a] =
        joinWith(x -> ToString.toString(x), sep, v)

    ///
    /// Returns the concatenation of the string representation
    /// of each element in `v` according to `f` with `sep` inserted between each element.
    ///
    pub def joinWith(f: a -> String & ef, sep: String, v: MutList[a]): String & Impure =
        use StringBuilder.append!;
        let lastSep = String.length(sep);
        let sb = StringBuilder.new();
        foreach(x -> { append!(f(x), sb); append!(sep, sb) }, v);
        StringBuilder.toString(sb) |> String.dropRight(lastSep)

    ///
    /// Applies `f` to all the elements in `v`.
    ///
    pub def foreach(f: a -> Unit & ef, v: MutList[a]): Unit & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                ()
            else {
                f(a[i]);
                loop(i + 1)
            }
        };
        loop(0)

    ///
    /// Applies `f` to all the elements in `v`.
    ///
    pub def foreachWithIndex(f: (a, Int32) -> Unit & ef, v: MutList[a]): Unit & Impure =
        let MutList(ra, rl) = v;
        let a = deref ra;
        let l = deref rl;
        def loop(i) = {
            if (i >= l)
                ()
            else {
                f(a[i], i);
                loop(i + 1)
            }
        };
        loop(0)

    ///
    /// Compresses the given mutable list `v` if needed.
    ///
    /// The mutable list will be shrunk to 1/2 of its size if the load factor is less than 1/4.
    ///
    pub def compress!(v: MutList[a]): Unit & Impure =
        let c = capacity(v);
        let len = length(v);
        let loadFactor = Int32.toFloat32(len) / Int32.toFloat32(c);
        if (loadFactor < 1.0f32/4.0f32 and len > 0) {
            if (len == 1)
                shrinkTo!(1, v)
            else
                shrinkTo!(c / 2, v)
        }
        else ()

    ///
    /// Returns the capacity of `v`.
    ///
    def capacity(v: MutList[a]): Int32 & Impure =
        let MutList(a, _) = v;
        Array.length(deref a)

    ///
    /// Returns a sorted copy of MutList `v`, where the elements are ordered from low to high according to
    /// their `Order` instance.
    ///
    /// The sort is not stable, i.e., equal elements may appear in a different order than in the input `v`.
    ///
    /// The sort implementation is a Quicksort.
    ///
    pub def sort(v: MutList[a]): MutList[a] & Impure with Order[a] = sortWith(Order.compare, v)

    ///
    /// Returns a sorted copy of MutList `v`, where the elements are ordered from low to high according to
    /// the `Order` instance for the values obtained by applying `f` to each element.
    ///
    /// The sort is not stable, i.e., equal elements may appear in a different order than in the input `v`.
    ///
    /// The sort implementation is a Quicksort.
    ///
    pub def sortBy(f: a -> b, v: MutList[a]): MutList[a] & Impure with Order[b] = sortWith(Order.compare `on` f, v)

    ///
    /// Returns a sorted copy of MutList `v`, where the elements are ordered from low to high according to
    /// the comparison function `cmp`.
    ///
    /// The sort is not stable, i.e., equal elements may appear in a different order than in the input `v`.
    ///
    /// The sort implementation is a Quicksort.
    ///
    pub def sortWith(cmp: (a,a) -> Comparison, v: MutList[a]): MutList[a] & Impure =
        let vCopy = copy(v);
        sortWith!(cmp, vCopy);
        vCopy

    ///
    /// Sort MutList `v` so that elements are ordered from low to high according to their `Order` instance.
    /// The MutList is mutated in-place.
    ///
    /// The sort is not stable, i.e., equal elements may appear in a different order than in the input `v`.
    ///
    /// The sort implementation is a Quicksort.
    ///
    pub def sort!(v: MutList[a]): Unit & Impure with Order[a] = sortWith!(Order.compare, v)

    ///
    /// Sort MutList `v` so that elements are ordered from low to high according to the `Order` instance for
    /// the values obtained by applying `f` to each element. The MutList is mutated in-place.
    ///
    /// The sort is not stable, i.e., equal elements may appear in a different order than in the input `v`.
    ///
    /// The sort implementation is a Quicksort.
    ///
    pub def sortBy!(f: a -> b, v: MutList[a]): Unit & Impure with Order[b] = sortWith!(Order.compare `on` f, v)

    ///
    /// Sort MutList `v` so that elements are ordered from low to high according to the comparison function `cmp`.
    /// The MutList is mutated in-place.
    ///
    /// The sort is not stable, i.e., equal elements may appear in a different order than in the input `v`.
    ///
    /// The sort implementation is a Quicksort.
    ///
    pub def sortWith!(cmp: (a,a) -> Comparison, v: MutList[a]): Unit & Impure =
        let MutList(a, l) = v;
        Array.sortWithin!(cmp, 0, (deref l) - 1, deref a)

}
