import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";

import {test; suite; skip} "mo:test";

import BufferDeque "../src/BufferDeque";

suite("BufferDeque", func() {
	test("Add 3 items to the end of the buffer", func() {
		let buffer = BufferDeque.new<Nat>();
                    
        assert buffer.capacity() == 10;
        assert buffer.size() == 0;
        assert BufferDeque.isEmpty(buffer);
        
        buffer.addBack(1);
        buffer.addBack(2);
        buffer.addBack(3);

        assert buffer.capacity() == 10;
        assert buffer.size() == 3;
        assert not BufferDeque.isEmpty(buffer);

        assert buffer.get(0) == 1;
        assert buffer.get(1) == 2;
        assert buffer.get(2) == 3;

        assert BufferDeque.peekFront(buffer) == ?1;
        assert BufferDeque.peekBack(buffer) == ?3;
        assert BufferDeque.toArray(buffer) == [1, 2, 3];
	});

    test("Add 3 items to the front of the buffer", func() {
		let buffer = BufferDeque.new<Nat>();
                    
        assert buffer.capacity() == 10;
        assert buffer.size() == 0;
        assert BufferDeque.isEmpty(buffer);
        
        buffer.addFront(1);
        buffer.addFront(2);
        buffer.addFront(3);

        assert buffer.capacity() == 10;
        assert buffer.size() == 3;
        assert not BufferDeque.isEmpty(buffer);

        assert buffer.get(0) == 3;
        assert buffer.get(1) == 2;
        assert buffer.get(2) == 1;

        assert BufferDeque.peekFront(buffer) == ?3;
        assert BufferDeque.peekBack(buffer) == ?1;
        assert BufferDeque.toArray(buffer) == [3, 2, 1];
	});

    test("init fromArray()", func(){
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert buffer.capacity() == 5;
        assert buffer.size() == 5;

        assert BufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];
    });

    test("replace items in of the buffer", func() {
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        buffer.put(1, 10);
        buffer.put(3, 20);

        assert BufferDeque.toArray(buffer) == [1, 10, 3, 20, 5];
    });

    test("remove items from the ends of the buffer", func() {
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert buffer.popFront() == ?1;
        assert buffer.popBack() == ?5;

        assert buffer.popFront() == ?2;
        assert buffer.popBack() == ?4;

        assert buffer.size() == 1;
        assert BufferDeque.toArray(buffer) == [3];
    });

    test("append from other buffers with the BufferInterface", func() {
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3]);

        let trad_buffer = Buffer.fromArray<Nat>([4, 5, 6]);
        let debuf = BufferDeque.fromArray<Nat>([7, 8, 9]);

        buffer.append(trad_buffer);
        assert buffer.size() == 6;

        buffer.append(debuf);
        assert buffer.size() == 9;

        assert BufferDeque.toArray(buffer) == [1, 2, 3, 4, 5, 6, 7, 8, 9];
    });

    test("prepend from other buffers", func(){
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3]);

        let trad_buffer = Buffer.fromArray<Nat>([4, 5, 6]);
        let debuf = BufferDeque.fromArray<Nat>([7, 8, 9]);

        buffer.prepend(trad_buffer);
        assert buffer.size() == 6;

        buffer.prepend(debuf);
        assert buffer.size() == 9;

        assert BufferDeque.toArray(buffer) == [7, 8, 9, 4, 5, 6, 1, 2, 3];
    });

    test("remove item from buffer", func(){
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert buffer.remove(4) == 5;
        assert buffer.size() == 4;

        assert buffer.remove(1) == 2;
        assert buffer.size() == 3;

        assert buffer.remove(1) == 3;
        assert buffer.size() == 2;

        assert buffer.remove(0) == 1;
        assert buffer.size() == 1;

        assert BufferDeque.toArray(buffer) == [4];
    });

    test("remove a range of items from the buffer", func(){
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        assert buffer.removeRange(2, 4) == [3, 4];
        assert buffer.size() == 3;

        assert BufferDeque.toArray(buffer) == [1, 2, 5];

        assert buffer.removeRange(0, 2) == [1, 2];
        assert buffer.size() == 1;

        assert BufferDeque.toArray(buffer) == [5];
    });

    test("rotate buffer with filled capacity", func(){
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        buffer.rotateLeft(1);
        assert BufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        buffer.rotateLeft(2);
        assert BufferDeque.toArray(buffer) == [4, 5, 1, 2, 3];

        buffer.rotateLeft(3);
        assert BufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        buffer.rotateLeft(4);
        assert BufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];

        buffer.rotateRight(5);
        assert BufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];

        buffer.rotateRight(4);
        assert BufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        buffer.rotateRight(3);
        assert BufferDeque.toArray(buffer) == [4, 5, 1, 2, 3];

        buffer.rotateRight(2);
        assert BufferDeque.toArray(buffer) == [2, 3, 4, 5, 1];

        buffer.rotateRight(1);
        assert BufferDeque.toArray(buffer) == [1, 2, 3, 4, 5];
    });

    test("rotate sparse buffer", func(){
        let buffer = BufferDeque.fromArray<Nat>([1, 2, 3, 4, 5]);

        buffer.reserve(10);

        buffer.rotateLeft(1);
        Debug.print(debug_show buffer.internal_array());
        Debug.print(debug_show BufferDeque.toArray(buffer));
        assert BufferDeque.toArray(buffer) == [4, 5, 3, 4, 5];

    });
});