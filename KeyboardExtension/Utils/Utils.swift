//
//  Utils.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/8/24.
//

import UIKit

func coalesce<T>(_ elements: T?...) -> [T] {
    return elements.compactMap { $0 }
}

func minOfCoalesced(_ numbers: Int?...) -> Int? {
    let validNumbers = numbers.compactMap { $0 }
    return validNumbers.min()
}

let darkBackground = UIColor(white: 0.1675, alpha: 0.01)
let lightBackground = UIColor(white: 0.8175, alpha: 0.01)
let customGray1 = UIColor(white: 0.25, alpha: 1.0)
let customGray2 = UIColor(white: 0.35, alpha: 1.0)
let customGray3 = UIColor(white: 0.4, alpha: 1.0)

func isPortrait() -> Bool {
    return UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
}

class Queue<T: Equatable>: Equatable {
    private var elements: [T] = []
    private let maxSize: Int

    init(maxSize: Int) {
        self.maxSize = maxSize
    }
    
    static func ==(lhs: Queue<T>, rhs: Queue<T>) -> Bool {
        return lhs.elements == rhs.elements
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var isFull: Bool {
        return elements.count == maxSize
    }

    func enqueue(_ element: T) {
        if isFull {
            dequeue() // Remove the oldest element if the queue is full
        }
        elements.append(element)
    }

    @discardableResult
    func dequeue() -> T? {
        return isEmpty ? nil : elements.removeFirst()
    }

    func peek(_ index: Int) -> T? {
        if elements.count < index + 1 { return nil }
        return elements[index]
    }

    var count: Int {
        return elements.count
    }

    func copy() -> Queue<T> {
        let newQueue = Queue<T>(maxSize: maxSize)
        elements.forEach { e in newQueue.enqueue(e) }
        return newQueue
    }
    
    func clear() {
        self.elements.removeAll()
    }
}
