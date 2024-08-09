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

    init(isShifted: Bool, isCapsLocked: Bool, isDoubleTap: Bool, keySet: [[Key]]) {
        self.isShifted = isShifted
        self.isCapsLocked = isCapsLocked
        self.isDoubleTapped = isDoubleTap
        self.keySet = keySet
    }
}

protocol Key {
    var id: String { get }
    var title: String { get }
    func onTap(document: UITextDocumentProxy, context: KeyInputContext) -> Void
    var span: Int { get }
}

private func onTapSingleKey(
    title: String,
    document: UIKeyInput,
    context: KeyInputContext
) {
    let isShifted = context.isShifted
    let isCapsLocked = context.isCapsLocked
    if isShifted || isCapsLocked { document.insertText(title.uppercased()) }
    else { document.insertText(title.lowercased()) }
}

class SingleKey: Key {
    let id: String
    var title: String
    let span: Int

    init(title: String, span: Int = 1) {
        self.id = title
        self.title = title
        self.span = span
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        onTapSingleKey(
            title: title,
            document: document,
            context: context
        )
    }
}

private func onTapDoubleKey(
    first: String,
    second: String,
    document: UIKeyInput,
    context: KeyInputContext
) {
    let isDoubleTap = context.isDoubleTapped
    if isDoubleTap { document.deleteBackward() }
    let title = if !isDoubleTap { first } else { second }
    onTapSingleKey(title: title, document: document, context: context)
}

class DoubleKey: Key {
    let id: String
    var title: String
    var first: String
    var second: String
    let span: Int

    init(title: String, first: String, second: String, span: Int = 1) {
        self.id = first + "_" + second
        self.title = title
        self.first = first
        self.second = second
        self.span = span
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        onTapDoubleKey(
            first: first,
            second: second,
            document: document,
            context: context
        )
    }
}
