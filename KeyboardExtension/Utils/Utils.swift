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

func calculateKeyWidth(
    span: Int,
    spanTotal: Int,
    containerSize: CGFloat
) -> CGFloat {
    let oneSpanSize = containerSize / CGFloat(spanTotal)
    return oneSpanSize * CGFloat(span)
}

func isKeySetsEqual(_ keySet1: [[Key]], _ keySet2: [[Key]]) -> Bool {
    if keySet1.count != keySet2.count { return false }
    for (index, keyArray1) in keySet1.enumerated() {
        let keyArray2 = keySet2[index]
        if keyArray1.count != keyArray2.count { return false }
        for (key1, key2) in zip(keyArray1, keyArray2) {
            if key1.id != key2.id { return false }
        }
    }
    return true
}

func isKeyInKeySet(_ key: Key, _ keySet: [[Key]]) -> Bool {
    for (_, keyArray) in keySet.enumerated() {
        for (_, keyInKeySet) in keyArray.enumerated() {
            if key.id == keyInKeySet.id { return true }
        }
    }
    return false
}

let darkBackground = UIColor(white: 0.1675, alpha: 0.01)
let lightBackground = UIColor(white: 0.8175, alpha: 0.01)
let customGray1 = UIColor(white: 0.25, alpha: 1.0)
let customGray2 = UIColor(white: 0.35, alpha: 1.0)
let customGray3 = UIColor(white: 0.4, alpha: 1.0)

func isPortrait() -> Bool {
    return UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
}

class Queue<T> {
    private var elements: [T] = []
    private let maxSize: Int

    init(maxSize: Int) {
        self.maxSize = maxSize
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
}
