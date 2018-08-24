//
//  Stack.swift
//  BubbleBlastSaga
//
//  Created by Calvin Tantio on 18/2/18.
//  Copyright © 2018 Calvin Tantio. All rights reserved.
//

struct Stack<T> {
    var elements = [T]()

    /// Adds an element to the top of the stack.
    /// - Parameter item: The element to be added to the stack
    mutating func push(_ item: T) {
        elements.append(item)
    }

    /// Adds all the elements of the specified array to the top
    /// of the stack in order starting from the element with the
    /// lowest index in the array.
    /// - Parameter items: The elements to be added to the stack
    mutating func push(contentsOf items: [T]) {
        for item in items {
            elements.append(item)
        }
    }

    /// Removes the element at the top of the stack and return it.
    /// - Returns: element at the top of the stack
    mutating func pop() -> T? {
        return elements.popLast()
    }

    /// Returns, but does not remove, the element at the top of the stack.
    /// - Returns: element at the top of the stack
    func peek() -> T? {
        return elements.last
    }

    /// The number of elements currently in the stack.
    var count: Int {
        return elements.count
    }

    /// Whether the stack is empty.
    var isEmpty: Bool {
        return elements.isEmpty
    }

    /// Removes all elements in the stack.
    mutating func removeAll() {
        elements.removeAll()
    }

    /// Returns an array of the elements in their respective pop order, i.e.
    /// first element in the array is the first element to be popped.
    /// - Returns: array of elements in their respective pop order
    func toArray() -> [T] {
        var arrayReturned = [T]()

        for element in elements.reversed() {
            arrayReturned.append(element)
        }

        return arrayReturned
    }
}
