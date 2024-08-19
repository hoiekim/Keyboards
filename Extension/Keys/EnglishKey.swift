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
    let remountOnTap = false
    let updateButtonImagesOnTap = false
    let first: String
    let second: String?
    let _backgroundColor: UIColor?

    init(first: String, second: String? = nil, backgroundColor: UIColor? = nil) {
        self.id = "EnglishKey_" + (second == nil ? first : first + "_" + second!)
        self.first = first
        self.second = second
        self._backgroundColor = backgroundColor
    }

    func getTitle(_ context: KeyInputContext) -> String? {
        if context.isShifted || context.isCapsLocked {
            return first.uppercased()
        } else {
            return first.lowercased()
        }
    }

    func getTitleSuperscript(_ context: KeyInputContext) -> String? {
        if second == nil { return nil }
        if context.isShifted || context.isCapsLocked {
            return second!.uppercased()
        } else {
            return second!.lowercased()
        }
    }

    func getImage(_ context: KeyInputContext) -> String? {
        return nil
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return _backgroundColor ?? customGray2
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let keyValue = getKeyValue(document: document, context: context)
        if context.isShiftedDoubleTapped {
            document.insertText(keyValue.capitalized)
        } else {
            let isShifted = context.isShifted
            let isCapsLocked = context.isCapsLocked
            if isShifted || isCapsLocked {
                document.insertText(keyValue.uppercased())
            } else {
                document.insertText(keyValue.lowercased())
            }
        }
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
