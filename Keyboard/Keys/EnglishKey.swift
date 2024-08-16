//
//  EnglishKey.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/16/24.
//

import UIKit

class EnglishKey: Key {
    let id: String
    let span: Int = 1
    let first: String
    let second: String?

    init(first: String, second: String? = nil) {
        self.id = "EnglishKey_" + (second == nil ? first : first + "_" + second!)
        self.first = first
        self.second = second
    }

    func getTitle(_ context: KeyInputContext) -> String? {
        let title = second == nil ? first : [first, second!].joined(separator: " ")
        if context.isShifted || context.isCapsLocked {
            return title.uppercased()
        } else {
            return title.lowercased()
        }
    }

    func getImage(_ context: KeyInputContext) -> String? {
        return nil
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return UIColor.systemIndigo
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let keyValue = getKeyValue(document: document, context: context)
        let isShifted = context.isShifted
        let isCapsLocked = context.isCapsLocked
        if isShifted || isCapsLocked { document.insertText(keyValue.uppercased()) }
        else { document.insertText(keyValue.lowercased()) }
    }

    private func getKeyValue(
        document: UITextDocumentProxy,
        context: KeyInputContext
    ) -> String {
        if second == nil { return first }
        else if context.isDoubleTapped {
            document.deleteBackward()
            return second!
        } else {
            return first
        }
    }
}
