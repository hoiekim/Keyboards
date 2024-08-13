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
    var backgroundColor: UIColor? { get }
}

class SingleKey: Key {
    let id: String
    var title: String
    let span: Int = 1
    var backgroundColor: UIColor?

    init(title: String, backgroundColor: UIColor? = nil) {
        self.id = "SingleKey_" + title
        self.title = title
        self.backgroundColor = backgroundColor
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        SingleKey.onTapSingleKey(
            title: title,
            document: document,
            context: context
        )
    }

    static func onTapSingleKey(
        title: String,
        document: UIKeyInput,
        context: KeyInputContext
    ) {
        let isShifted = context.isShifted
        let isCapsLocked = context.isCapsLocked
        if isShifted || isCapsLocked { document.insertText(title.uppercased()) }
        else { document.insertText(title.lowercased()) }
    }
}

class DoubleKey: Key {
    let id: String
    var title: String
    var first: String
    var second: String
    let span: Int = 1
    var backgroundColor: UIColor?

    init(title: String, first: String, second: String, backgroundColor: UIColor? = nil) {
        self.id = "DoubleKey_" + first + "_" + second
        self.title = title
        self.first = first
        self.second = second
        self.backgroundColor = backgroundColor
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let isDoubleTap = context.isDoubleTapped
        if isDoubleTap { document.deleteBackward() }
        let title = if !isDoubleTap { first } else { second }
        SingleKey.onTapSingleKey(title: title, document: document, context: context)
    }
}
