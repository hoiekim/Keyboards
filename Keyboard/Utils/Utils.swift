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
