//
//  Key.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

class KeyInputContext {
    var isShifted: Bool
    var isCapsLocked: Bool
    var isDoubleTapped: Bool
    var keySet: [[Key]]

    init(isShift: Bool, isCapsLock: Bool, isDoubleTap: Bool, keySet: [[Key]]) {
        self.isShifted = isShift
        self.isCapsLocked = isCapsLock
        self.isDoubleTapped = isDoubleTap
        self.keySet = keySet
    }
}

protocol Key {
    var id: String { get }
    var title: String { get }
    func onTap(uiKeyInput: UIKeyInput, context: KeyInputContext) -> Void
    var isShift: Bool { get }
}

private func onTapSingleKey(
    title: String,
    uiKeyInput: UIKeyInput,
    context: KeyInputContext
) {
    let isShift = context.isShifted
    let isCapsLock = context.isCapsLocked
    if isShift || isCapsLock { uiKeyInput.insertText(title.uppercased()) }
    else { uiKeyInput.insertText(title.lowercased()) }
}

class SingleKey: Key {
    let id: String
    var title: String
    var isShift = false

    init(title: String) {
        self.id = title
        self.title = title
    }

    func onTap(uiKeyInput: UIKeyInput, context: KeyInputContext) {
        onTapSingleKey(
            title: title,
            uiKeyInput: uiKeyInput,
            context: context
        )
    }
}

private func onTapDoubleKey(
    first: String,
    second: String,
    uiKeyInput: UIKeyInput,
    context: KeyInputContext
) {
    let isDoubleTap = context.isDoubleTapped
    if isDoubleTap { uiKeyInput.deleteBackward() }
    let title = if !isDoubleTap { first } else { second }
    onTapSingleKey(title: title, uiKeyInput: uiKeyInput, context: context)
}

class DoubleKey: Key {
    let id: String
    var title: String
    var first: String
    var second: String
    var isShift = false

    init(title: String, first: String, second: String) {
        self.id = first + "_" + second
        self.title = title
        self.first = first
        self.second = second
    }

    func onTap(uiKeyInput: UIKeyInput, context: KeyInputContext) {
        onTapDoubleKey(
            first: first,
            second: second,
            uiKeyInput: uiKeyInput,
            context: context
        )
    }
}
