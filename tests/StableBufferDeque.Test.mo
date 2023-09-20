import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

import {test; suite; skip} "mo:test";

import StableBufferDeque "../src/StableBufferDeque";

suite("StableBufferDeque", func() {
	test("Add 3 items to the end of the buffer", func() {
		let buffer = StableBufferDeque.new<Nat>();

        assert StableBufferDeque.capacity(buffer) == 0;
        assert StableBufferDeque.size(buffer) == 0;
        assert StableBufferDeque.isEmpty(buffer);
        
        StableBufferDeque.addBack(buffer, 1);
        StableBufferDeque.addBack(buffer, 2);
        StableBufferDeque.addBack(buffer, 3);

        assert StableBufferDeque.size(buffer) == 3;
        assert not StableBufferDeque.isEmpty(buffer);

        assert StableBufferDeque.get(buffer, 0) == 1;
        assert StableBufferDeque.get(buffer, 1) == 2;
        assert StableBufferDeque.get(buffer, 2) == 3;

        assert StableBufferDeque.peekFront(buffer) == ?1;
        assert StableBufferDeque.peekBack(buffer) == ?3;
        assert StableBufferDeque.toArray(buffer) == [1, 2, 3];
	});

    test("Add 3 items to the front of the buffer", func() {
		let buffer = StableBufferDeque.withCapacity<Nat>(10);
                    
        assert StableBufferDeque.capacity(buffer) == 10;
        assert StableBufferDeque.size(buffer) == 0;
        assert StableBufferDeque.isEmpty(buffer);
        
        StableBufferDeque.addFront(buffer, 1);
        StableBufferDeque.addFront(buffer, 2);
        StableBufferDeque.addFront(buffer, 3);

        assert StableBufferDeque.capacity(buffer) == 10;
        assert StableBufferDeque.size(buffer) == 3;
        assert not StableBufferDeque.isEmpty(buffer);

        assert StableBufferDeque.get(buffer, 0) == 3;
        assert StableBufferDeque.get(buffer, 1) == 2;
        assert StableBufferDeque.get(buffer, 2) == 1;

        assert StableBufferDeque.peekFront(buffer) == ?3;
        assert StableBufferDeque.peekBack(buffer) == ?1;
        assert StableBufferDeque.toArray(buffer) == [3, 2, 1];
        assert Iter.toArray(StableBufferDeque.vals(buffer)) == [3, 2, 1];
	});

    test("init fromArray()", func(){
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert StableBufferDeque.capacity(buffer) == 5;
        assert StableBufferDeque.size(buffer) == 5;

        assert StableBufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];
        assert Iter.toArray(StableBufferDeque.vals(buffer)) == [1, 2, 3, 4, 5];
    });

    test("replace items in of the buffer", func() {
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        StableBufferDeque.put(buffer, 1, 10);
        StableBufferDeque.put(buffer, 3, 20);

        assert StableBufferDeque.toArray(buffer) == [1, 10, 3, 20, 5];
        assert Iter.toArray(StableBufferDeque.vals(buffer)) == [1, 10, 3, 20, 5];
    });

    test("remove items from the ends of the buffer", func() {
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert StableBufferDeque.popFront(buffer) == ?1;
        assert StableBufferDeque.popBack(buffer) == ?5;

        assert StableBufferDeque.popFront(buffer) == ?2;
        assert StableBufferDeque.popBack(buffer) == ?4;

        assert StableBufferDeque.size(buffer) == 1;
        assert StableBufferDeque.toArray(buffer) == [3];
    });

    test("append from other buffers with the BufferInterface", func() {
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3]);

        let trad_buffer = StableBufferDeque.fromArray<Nat>([4, 5, 6]);
        let debuf = StableBufferDeque.fromArray<Nat>([7, 8, 9]);

        StableBufferDeque.append(buffer, trad_buffer);
        assert StableBufferDeque.size(buffer) == 6;

        StableBufferDeque.append(buffer, debuf);
        assert StableBufferDeque.size(buffer) == 9;

        assert StableBufferDeque.toArray(buffer) == [1, 2, 3, 4, 5, 6, 7, 8, 9];
    });

    test("prepend from other buffers", func(){
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3]);

        let trad_buffer = StableBufferDeque.fromArray<Nat>([4, 5, 6]);
        let debuf = StableBufferDeque.fromArray<Nat>([7, 8, 9]);

        StableBufferDeque.prepend(buffer, trad_buffer);
        assert StableBufferDeque.size(buffer) == 6;

        StableBufferDeque.prepend(buffer, debuf);
        assert StableBufferDeque.size(buffer) == 9;

        assert StableBufferDeque.toArray(buffer) == [7, 8, 9, 4, 5, 6, 1, 2, 3];
        assert Iter.toArray(StableBufferDeque.vals(buffer)) == [7, 8, 9, 4, 5, 6, 1, 2, 3];
    });

    test("remove item from buffer", func(){
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert StableBufferDeque.remove(buffer, 4) == 5;
        assert StableBufferDeque.size(buffer) == 4;

        assert StableBufferDeque.remove(buffer, 1) == 2;
        assert StableBufferDeque.size(buffer) == 3;

        assert StableBufferDeque.remove(buffer, 1) == 3;
        assert StableBufferDeque.size(buffer) == 2;

        assert StableBufferDeque.remove(buffer, 0) == 1;
        assert StableBufferDeque.size(buffer) == 1;

        assert StableBufferDeque.toArray(buffer) == [4];
        assert Iter.toArray(StableBufferDeque.vals(buffer)) == [4];
    });

    test("remove a range of items from the buffer", func(){
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert StableBufferDeque.removeRange(buffer, 2, 4) == [3, 4];
        assert StableBufferDeque.size(buffer) == 3;

        assert StableBufferDeque.toArray(buffer) == [1, 2, 5];

        assert StableBufferDeque.removeRange(buffer, 0, 2) == [1, 2];
        assert StableBufferDeque.size(buffer) == 1;

        assert StableBufferDeque.toArray(buffer) == [5];
    });

    test("rotate buffer with filled capacity", func(){
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert StableBufferDeque.capacity(buffer) == 5;
        
        StableBufferDeque.rotateLeft(buffer, 1);
        assert StableBufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        StableBufferDeque.rotateLeft(buffer, 2);
        assert StableBufferDeque.toArray(buffer) == [4, 5, 1, 2, 3];

        StableBufferDeque.rotateRight(buffer, 2);
        assert StableBufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        StableBufferDeque.rotateRight(buffer, 1);
        assert StableBufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];

        StableBufferDeque.rotateRight(buffer, 5);
        assert StableBufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];
    });

    test("rotate sparse buffer", func(){
        let buffer = StableBufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);
        StableBufferDeque.reserve(buffer, 10);

        assert StableBufferDeque.capacity(buffer) == 10;

        StableBufferDeque.rotateLeft(buffer, 1);
        assert StableBufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        StableBufferDeque.rotateLeft(buffer, 2);
        assert StableBufferDeque.toArray(buffer) == [4, 5, 1, 2, 3];

        StableBufferDeque.rotateRight(buffer, 1);
        assert StableBufferDeque.toArray(buffer) == [3, 4, 5, 1, 2];

        StableBufferDeque.rotateRight(buffer, 2);
        assert StableBufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];

        StableBufferDeque.rotateRight(buffer, 15);
        assert StableBufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];
    });
});