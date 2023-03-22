# BufferDeque
A Buffer that with an amortized time of O(1) additions at both ends

## Class `BufferDeque<A>`

``` motoko no-repl
class BufferDeque<A>(init_capacity : Nat)
```


### Function `size`
``` motoko no-repl
func size() : Nat
```

Returns the number of items in the buffer


### Function `capacity`
``` motoko no-repl
func capacity() : Nat
```

Returns the capacity of the deque.


### Function `internal_array`
``` motoko no-repl
func internal_array() : [?A]
```

for debugging purposes


### Function `internal_start`
``` motoko no-repl
func internal_start() : Nat
```



### Function `get`
``` motoko no-repl
func get(i : Nat) : A
```

Retrieves the element at the given index.
Traps if the index is out of bounds.


### Function `getOpt`
``` motoko no-repl
func getOpt(i : Nat) : ?A
```

Retrieves an element at the given index, if it exists.
If not it returns `null`.


### Function `put`
``` motoko no-repl
func put(i : Nat, elem : A)
```

Overwrites the element at the given index.


### Function `reserve`
``` motoko no-repl
func reserve(capacity : Nat)
```

Changes the capacity to `capacity`. Traps if `capacity` < `size`.

```motoko include=initialize

buffer.reserve(4);
buffer.add(10);
buffer.add(11);
buffer.capacity(); // => 4
```

Runtime: O(capacity)

Space: O(capacity)

> Adapted from the base implementation of the `Buffer` class


### Function `addFront`
``` motoko no-repl
func addFront(elem : A)
```

Adds an element to the start of the buffer.


### Function `addBack`
``` motoko no-repl
func addBack(elem : A)
```

Adds an element to the end of the buffer


### Function `popFront`
``` motoko no-repl
func popFront() : ?A
```

Removes an element from the start of the buffer and returns it if it exists.
If the buffer is empty, it returns `null`.


### Function `popBack`
``` motoko no-repl
func popBack() : ?A
```

Removes an element from the end of the buffer and returns it if it exists.
If the buffer is empty, it returns `null`.
Runtime: `O(1)` amortized


### Function `clear`
``` motoko no-repl
func clear()
```

Removes all elements from the buffer and resizes it to the default capacity.


### Function `append`
``` motoko no-repl
func append(other : BufferInterface<A>)
```

Adds all the elements in the given buffer to the end of this buffer.
The `BufferInterface<A>` type is used to allow for any type that has a `size` and `get` method.


### Function `prepend`
``` motoko no-repl
func prepend(other : BufferInterface<A>)
```

Adds all the elements in the given buffer to the start of this buffer.


### Function `remove`
``` motoko no-repl
func remove(i : Nat) : A
```

Removes an element at the given index and returns it. Traps if the index is out of bounds.
Runtime: `O(min(i, size - i))`


### Function `removeRange`
``` motoko no-repl
func removeRange(_start : Nat, end : Nat) : [A]
```

Removes a range of elements from the buffer and returns them as an array.
Traps if the range is out of bounds.


### Function `range`
``` motoko no-repl
func range(start : Nat, end : Nat) : Iter.Iter<A>
```

Returns an iterator over the elements of the buffer.
Note: The values in the iterator will change if the buffer is modified before the iterator is consumed.


### Function `swap`
``` motoko no-repl
func swap(i : Nat, j : Nat)
```

Swaps the elements at the given indices.


### Function `rotateLeft`
``` motoko no-repl
func rotateLeft(n : Nat)
```

Rotates the buffer to the left by the given amount.
Runtime: `O(min(n, size - n))`


### Function `rotateRight`
``` motoko no-repl
func rotateRight(n : Nat)
```

Rotates the buffer to the right by the given amount.
Runtime: `O(min(n, size - n))`


### Function `vals`
``` motoko no-repl
func vals() : Iter.Iter<A>
```

Returns an iterator over the elements of the buffer.

## Function `new`
``` motoko no-repl
func new<A>() : BufferDeque<A>
```

Creates an empty buffer.

## Function `init`
``` motoko no-repl
func init<A>(capacity : Nat, val : A) : BufferDeque<A>
```

Creates a buffer with the given capacity and initializes all elements to the given value.

## Function `tabulate`
``` motoko no-repl
func tabulate<A>(capacity : Nat, f : Nat -> A) : BufferDeque<A>
```

Creates a buffer with the given capacity and initializes all elements using the given function.

## Function `peekFront`
``` motoko no-repl
func peekFront<A>(buffer : BufferDeque<A>) : ?A
```

Returns the element at the front of the buffer, or `null` if the buffer is empty.

## Function `peekBack`
``` motoko no-repl
func peekBack<A>(buffer : BufferDeque<A>) : ?A
```

Returns the element at the back of the buffer, or `null` if the buffer is empty.

## Function `isEmpty`
``` motoko no-repl
func isEmpty<A>(buffer : BufferDeque<A>) : Bool
```

Checks if the buffer is empty.

## Function `fromArray`
``` motoko no-repl
func fromArray<A>(arr : [A]) : BufferDeque<A>
```

Creates a buffer from the given array.

## Function `toArray`
``` motoko no-repl
func toArray<A>(buffer : BufferDeque<A>) : [A]
```

Returns the buffer as an array.
