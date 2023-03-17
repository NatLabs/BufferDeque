/// Stable Heap Buffer Deque

import Array "mo:base/Array";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

import {
    newCapacity;
    INCREASE_FACTOR_NUME;
    INCREASE_FACTOR_DENOM;
    DECREASE_THRESHOLD;
    DECREASE_FACTOR;
    DEFAULT_CAPACITY;
} "internal/Common";

module {
    public type SHBufferDeque<A> = {
        var elems : [var ?A];
        var start : Nat;
        var count : Nat;
    };

    public func new<A>() : SHBufferDeque<A> = {
        var elems = [var];
        var start = 0;
        var count = 0;
    };

    public func withCapacity<A>(init_capacity : Nat) : SHBufferDeque<A> = {
        var elems = Array.init<?A>(init_capacity, null);
        var start = 0;
        var count = 0;
    };

    public func init<A>(capacity: Nat, val: A) : SHBufferDeque<A> = {
        var elems = Array.init<?A>(capacity, ?val);
        var start = 0;
        var count = capacity;
    };

    public func size<A>(self : SHBufferDeque<A>) : Nat = self.count;

};
