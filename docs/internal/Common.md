# internal/Common

## Value `INCREASE_FACTOR_NUME`
``` motoko no-repl
let INCREASE_FACTOR_NUME
```


## Value `INCREASE_FACTOR_DENOM`
``` motoko no-repl
let INCREASE_FACTOR_DENOM
```


## Value `DECREASE_THRESHOLD`
``` motoko no-repl
let DECREASE_THRESHOLD
```


## Value `DECREASE_FACTOR`
``` motoko no-repl
let DECREASE_FACTOR
```


## Value `DEFAULT_CAPACITY`
``` motoko no-repl
let DEFAULT_CAPACITY
```


## Function `newCapacity`
``` motoko no-repl
func newCapacity(oldCapacity : Nat) : Nat
```

> Adapted from the base implementation of the `Buffer` class

## Type `BufferInterface`
``` motoko no-repl
type BufferInterface<A> = { get : Nat -> A; size : () -> Nat }
```

