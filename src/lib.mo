/// A Buffer that with an amortized time of O(1) additions at both ends

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

module {

    // The following constants are used to manage the capacity.
    // The length of `elements` is increased by `INCREASE_FACTOR` when capacity is reached.
    // The length of `elements` is decreased by `DECREASE_FACTOR` when capacity is strictly less than
    // `DECREASE_THRESHOLD`.

    // INCREASE_FACTOR = INCREASE_FACTOR_NUME / INCREASE_FACTOR_DENOM (with floating point division)
    // Keep INCREASE_FACTOR low to minimize cycle limit problem
    private let INCREASE_FACTOR_NUME = 3;
    private let INCREASE_FACTOR_DENOM = 2;
    private let DECREASE_THRESHOLD = 4; // Don't decrease capacity too early to avoid thrashing
    private let DECREASE_FACTOR = 2;
    private let DEFAULT_CAPACITY = 8;

    /// > Adapted from the base implementation of the `Buffer` class
    private func newCapacity(oldCapacity : Nat) : Nat {
        if (oldCapacity == 0) {
            1;
        } else {
            // calculates ceil(oldCapacity * INCREASE_FACTOR) without floats
            ((oldCapacity * INCREASE_FACTOR_NUME) + INCREASE_FACTOR_DENOM - 1) / INCREASE_FACTOR_DENOM;
        };
    };

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
        public func put(i: Nat, elem: A) {
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
        public func pushFront(elem: A) {
            if (count == capacity()) {
                reserve(newCapacity(capacity()));
            };

            start := get_index(capacity() - 1);
            elems[start] := ?elem;
            count += 1;
        };

        /// Adds an element to the end of the buffer
        public func pushBack(elem: A){
            if (count == capacity()) {
                reserve(newCapacity(capacity()));
            };

            elems[get_index(count)] := ?elem;
            count += 1;
        };

        /// Removes an element from the start of the buffer and returns it if it exists.
        /// If the buffer is empty, it returns `null`.
        public func popFront() : ?A {
            if (count == 0){
                return null;
            };

            let elem = elems[start];
            elems[start] := null;
            start := get_index(1);
            count -= 1;
            return elem;
        };

        public func popBack() : ?A {
            if (count == 0){
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

        /// Returns an iterator over the elements of the buffer.
        /// 
        /// Note: The values in the iterator will change if the buffer is modified before the iterator is consumed.
        public func range(start: Nat, end: Nat) : Iter.Iter<A> {
            Iter.map(
                Iter.range(start, end - 1),
                func (i: Nat) : A = get(i)
            )
        };

        public func vals(): Iter.Iter<A> {
            Iter.map(
                Iter.range(start, count - 1),
                func (i: Nat) : A = get(i)
            )
        };

    };

    public func new<A>() : BufferDeque<A> {
        BufferDeque<A>(DEFAULT_CAPACITY);
    };

    public func init<A>(capacity: Nat, val: A) : BufferDeque<A> {
        let buffer = BufferDeque<A>(capacity);
        
        for (i in Iter.range(0, capacity - 1)){
            buffer.pushBack(val);
        };

        buffer
    };

    public func tabulate<A>(capacity: Nat, f: Nat -> A) : BufferDeque<A> {
        let buffer = BufferDeque<A>(capacity);
        
        for (i in Iter.range(0, capacity - 1)){
            buffer.pushBack(f(i));
        };

        buffer
    };

    public func peekFront<A>(buffer : BufferDeque<A>) : ?A {
        buffer.getOpt(0);
    };

    public func peekBack<A>(buffer : BufferDeque<A>) : ?A {
        buffer.getOpt(buffer.size() - 1);
    };
};
