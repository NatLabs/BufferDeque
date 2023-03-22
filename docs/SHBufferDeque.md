# SHBufferDeque
A Stable Heap Buffer Deque

## Type `SHBufferDeque`
``` motoko no-repl
type SHBufferDeque<A> = { var elems : [var ?A]; var start : Nat; var count : Nat }
```


## Function `new`
``` motoko no-repl
func new<A>() : SHBufferDeque<A>
```


## Function `withCapacity`
``` motoko no-repl
func withCapacity<A>(init_capacity : Nat) : SHBufferDeque<A>
```


## Function `init`
``` motoko no-repl
func init<A>(capacity : Nat, val : A) : SHBufferDeque<A>
```


## Function `size`
``` motoko no-repl
func size<A>(self : SHBufferDeque<A>) : Nat
```

