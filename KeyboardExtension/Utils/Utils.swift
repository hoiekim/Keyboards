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
    containerSize: CGFloat,
    spacing: CGFloat
) -> CGFloat {
    let numberOfSpaces = spanTotal + 1
    let totalSpacing = CGFloat(numberOfSpaces) * spacing
    let oneSpanSize = (containerSize - totalSpacing) / CGFloat(spanTotal)
    let mergedSpacing = CGFloat(max(0, span - 1)) * spacing
    return (oneSpanSize * CGFloat(span)) + mergedSpacing
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

let customGray0 = UIColor(white: 0.1, alpha: 1.0)
let customGray1 = UIColor(white: 0.25, alpha: 1.0)
let customGray2 = UIColor(white: 0.35, alpha: 1.0)
let customGray3 = UIColor(white: 0.4, alpha: 1.0)
