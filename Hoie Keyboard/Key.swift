//
//  Key.swift
//  Hoie Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

class KeyInputContext {
    var isShift: Bool
    var isCapsLock: Bool
    var isDoubleTap: Bool
    var keySet: [[Key]]
    
    init(isShift: Bool, isCapsLock: Bool, isDoubleTap: Bool, keySet: [[Key]]) {
        self.isShift = isShift
        self.isCapsLock = isCapsLock
        self.isDoubleTap = isDoubleTap
        self.keySet = keySet
    }
}

typealias OnTap = (UIKeyInput, KeyInputContext) -> Void

protocol Key {
    var title: String { get }
    var onTap: OnTap { get }
}

private func onTapSingleKey(
    title: String,
    uiKeyInput: UIKeyInput,
    context: KeyInputContext
) {
    let isShift = context.isShift
    let isCapsLock = context.isCapsLock
    if isShift || isCapsLock { uiKeyInput.insertText(title.uppercased()) }
    else { uiKeyInput.insertText(title.lowercased()) }
}

class SingleKey: Key {
    var title: String
    var onTap: OnTap

    init(title: String) {
        self.title = title
        self.onTap = { uiKeyInput, context in
            onTapSingleKey(
                title: title,
                uiKeyInput: uiKeyInput,
                context: context
            )
        }
    }
}

private func onTapDoubleKey(
    first: String,
    second: String,
    uiKeyInput: UIKeyInput,
    context: KeyInputContext
) {
    let isDoubleTap = context.isDoubleTap
    if isDoubleTap { uiKeyInput.deleteBackward() }
    let title = if !isDoubleTap { first } else { second }
    onTapSingleKey(title: title, uiKeyInput: uiKeyInput, context: context)
}

class DoubleKey: Key {
    var title: String
    var onTap: OnTap

    init(title: String, first: String, second: String) {
        self.title = title
        self.onTap = { uiKeyInput, context in
            onTapDoubleKey(
                first: first,
                second: second,
                uiKeyInput: uiKeyInput,
                context: context
            )
        }
    }
}
