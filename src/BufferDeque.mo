/// A Buffer that with an amortized time of O(1) additions at both ends

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

import Common "internal/Common";

module {

    let {
        newCapacity;
        INCREASE_FACTOR_NUME;
        INCREASE_FACTOR_DENOM;
        DECREASE_THRESHOLD;
        DECREASE_FACTOR;
        DEFAULT_CAPACITY;
    } = Common;

    type BufferInterface<A> = Common.BufferInterface<A>;

    public class BufferDeque<A>(init_capacity : Nat) {
        var start = 0;
        var count = 0;

        var elems : [var ?A] = Array.init<?A>(init_capacity, null);

        /// Returns the number of items in the buffer
        public func size() : Nat = count;

        /// Returns the capacity of the deque.
        public func capacity() : Nat = elems.size();

        // Returns the internal index of the element at the perceived index `i`.
        private func get_index(i : Nat) : Nat = (start + i) % capacity();

        /// Retrieves the element at the given index.
        /// Traps if the index is out of bounds.
        public func get(i : Nat) : A {
            if (i >= count) {
                Debug.trap("BufferDeque get(): Index " # debug_show (i) # " out of bounds");
            };

            switch (elems[get_index(i)]) {
                case (?elem) elem;
                case (null) Debug.trap("BufferDeque get(): Index " # debug_show (i) # " out of bounds");
            };
        };

        /// Retrieves an element at the given index, if it exists.
        /// If not it returns `null`.
        public func getOpt(i : Nat) : ?A {
            if (i < count) {
                elems[get_index(i)];
            } else {
                null;
            };
        };

        /// Overwrites the element at the given index.
        public func put(i : Nat, elem : A) {
            if (i >= count) {
                Debug.trap("BufferDeque put(): Index " # debug_show (i) # " out of bounds");
            };

            elems[get_index(i)] := ?elem;
        };

        /// Changes the capacity to `capacity`. Traps if `capacity` < `size`.
        ///
        /// ```motoko include=initialize
        ///
        /// buffer.reserve(4);
        /// buffer.add(10);
        /// buffer.add(11);
        /// buffer.capacity(); // => 4
        /// ```
        ///
        /// Runtime: O(capacity)
        ///
        /// Space: O(capacity)
        ///
        /// > Adapted from the base implementation of the `Buffer` class
        public func reserve(capacity : Nat) {
            if (capacity < count) {
                Debug.trap "capacity must be >= size in reserve";
            };

            let elems2 = Array.init<?A>(capacity, null);

            var i = 0;
            while (i < count) {
                elems2[i] := elems[get_index(i)];
                i += 1;
            };

            elems := elems2;
            start := 0;
        };

        /// Adds an element to the start of the buffer.
        public func pushFront(elem : A) {
            if (count == capacity()) {
                reserve(newCapacity(capacity()));
            };

            start := get_index(capacity() - 1);
            elems[start] := ?elem;
            count += 1;
        };

        /// Adds an element to the end of the buffer
        public func pushBack(elem : A) {
            if (count == capacity()) {
                reserve(newCapacity(capacity()));
            };

            elems[get_index(count)] := ?elem;
            count += 1;
        };

        /// Removes an element from the start of the buffer and returns it if it exists.
        /// If the buffer is empty, it returns `null`.
        public func popFront() : ?A {
            if (count == 0) {
                return null;
            };

            let elem = elems[start];
            elems[start] := null;
            start := get_index(1);
            count -= 1;
            return elem;
        };

        public func popBack() : ?A {
            if (count == 0) {
                return null;
            };

            let elem = elems[get_index(count - 1)];
            elems[get_index(count - 1)] := null;
            count -= 1;
            return elem;
        };

        public func clear() {
            start := 0;
            count := 0;
            elems := Array.init<?A>(DEFAULT_CAPACITY, null);
        };

        /// Adds all the elements in the given buffer to the end of this buffer.
        /// The `BufferInterface<A>` type is used to allow for any type that has a `size` and `get` method.
        public func append(other: BufferInterface<A>) {
            for (elem in Iter.range(0, other.size() - 1)) {
                pushBack(other.get(elem));
            };
        };

        public func remove(i: Nat): A {
            if (i >= count) {
                Debug.trap("BufferDeque remove(): Index " # debug_show (i) # " out of bounds");
            };

            let index = get_index(i);
            let elem = get(index);

            let shift_left = i > count / 2;

            let iter = if (shift_left) {
                Iter.map<Nat, (Nat, Nat)>(
                    Iter.range(i + 2, count),
                    func(i : Nat) : (Nat, Nat) {
                        (get_index(i - 2), get_index(i - 1));
                    },
                );
            } else {
                Iter.map<Nat, (Nat, Nat)>(
                    Iter.range(1, i),
                    func(i : Nat) : (Nat, Nat) {
                        (get_index(i - 1), get_index(i));
                    },
                );
            };

            for ((i, j) in iter) {
                elems[j] := elems[i];
            };

            if (index == start or not shift_left) {
                start := get_index(1);
            };

            count -= 1;
            elem;
        };

        public func insertBuffer<A>(i: Nat, other: BufferInterface<A>){
            
        };

        /// Returns an iterator over the elements of the buffer.
        ///
        /// Note: The values in the iterator will change if the buffer is modified before the iterator is consumed.
        public func range(start : Nat, end : Nat) : Iter.Iter<A> {
            Iter.map(
                Iter.range(start, end - 1),
                func(i : Nat) : A = get(i),
            );
        };

        public func drain(start : Nat, end : Nat) : Iter.Iter<A> {
            let iter = range(start, end);
            clear();
            iter;
        };

        public func vals() : Iter.Iter<A> {
            Iter.map(
                Iter.range(start, count - 1),
                func(i : Nat) : A = get(i),
            );
        };
    };

    public func new<A>() : BufferDeque<A> {
        BufferDeque<A>(DEFAULT_CAPACITY);
    };

    public func init<A>(capacity : Nat, val : A) : BufferDeque<A> {
        let buffer = BufferDeque<A>(capacity);

        for (i in Iter.range(0, capacity - 1)) {
            buffer.pushBack(val);
        };

        buffer;
    };

    public func tabulate<A>(capacity : Nat, f : Nat -> A) : BufferDeque<A> {
        let buffer = BufferDeque<A>(capacity);

        for (i in Iter.range(0, capacity - 1)) {
            buffer.pushBack(f(i));
        };

        buffer;
    };

    public func peekFront<A>(buffer : BufferDeque<A>) : ?A {
        buffer.getOpt(0);
    };

    public func peekBack<A>(buffer : BufferDeque<A>) : ?A {
        buffer.getOpt(buffer.size() - 1);
    };
};
