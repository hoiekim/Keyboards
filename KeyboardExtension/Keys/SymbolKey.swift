//
//  SymbolKey.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/16/24.
//

import UIKit

class SymbolKey: Key {
    static let className = "SymbolKey"
    let className = "SymbolKey"
    
    let id: String
    let span: Int = 1
    let remountOnTap = false
    let updateButtonImagesOnTap = false
    let first: String
    let second: String?
    let third: String?
    var _backgroundColor: UIColor?

    init(
        first: String,
        second: String? = nil,
        third: String? = nil,
        backgroundColor: UIColor? = nil
    ) {
        let values: [String] = [first, second, third].compactMap { $0 }
        self.id = "SymbolKey_" + values.joined(separator: "_")
        self.first = first
        self.second = second
        self.third = third
        self._backgroundColor = backgroundColor
    }

    func getTitle(_ context: KeyInputContext) -> String? {
        if third != nil && (context.isShifted || context.isCapsLocked) {
            return third
        } else {
            let values: [String] = [first, second].compactMap { $0 }
            return values.joined(separator: " ")
        }
    }
    
    func getTitleSuperscript(_ context: KeyInputContext) -> String? {
        return nil
    }

    func getImage(_ context: KeyInputContext) -> UIImage? {
        return nil
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return self._backgroundColor ?? customGray2
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let keyValue = getKeyValue(document: document, context: context)
        let isShifted = context.isShifted
        let isCapsLocked = context.isCapsLocked
        if isShifted || isCapsLocked { document.insertText(keyValue.uppercased()) }
        else { document.insertText(keyValue.lowercased()) }
    }
    
    private var isSingleKeyRemoved = false

    private func getKeyValue(
        document: UITextDocumentProxy,
        context: KeyInputContext
    ) -> String {
        if third != nil && (context.isShifted || context.isCapsLocked) {
            return third!
        } else {
            if second == nil { return first }
            else if context.isDoubleTapped() {
                if !isSingleKeyRemoved {
                    document.deleteBackward()
                    isSingleKeyRemoved = true
                }
                return second!
            } else {
                isSingleKeyRemoved = false
                return first
            }
        }
    }
}
