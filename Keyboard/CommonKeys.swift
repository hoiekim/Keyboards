//
//  CommonKeys.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/6/24.
//

import UIKit

typealias OnTapUtilKey = (UtilKey, UIKeyInput, KeyInputContext) -> Void

class UtilKey: Key {
    let id: String
    var title: String
    var _onTap: OnTapUtilKey
    var isShift: Bool
    
    init(
        id: String,
        title: String,
        onTap: @escaping OnTapUtilKey,
        isShift: Bool = false
    ) {
        self.id = id
        self.title = title
        self._onTap = onTap
        self.isShift = isShift
    }
    
    func onTap(uiKeyInput: UIKeyInput, context: KeyInputContext) {
        self._onTap(self, uiKeyInput, context)
    }
    
    func setTitle(newTitle: String) {
        self.title = newTitle
    }
}

let backSpace = UtilKey(
    id: "backSpace",
    title: "⌫",
    onTap: { (key, uiKeyInput, context) in
        uiKeyInput.deleteBackward()
    }
)

let TITLE_SHIFT_DEFAULT = "⇧"
let TITLE_SHIFT_DEPERRESED = "⇪"
let TITLE_SHIFT_LOCKED = "⏏︎"

let shift = UtilKey(
    id: "shift",
    title: TITLE_SHIFT_DEFAULT,
    onTap: { (key, uiKeyInput, context) in
        if context.isDoubleTapped {
            context.isCapsLocked = true
            key.setTitle(newTitle: TITLE_SHIFT_LOCKED)
        } else {
            if context.isCapsLocked {
                context.isCapsLocked = false
                context.isShifted = false
                key.setTitle(newTitle: TITLE_SHIFT_DEFAULT)
            } else if context.isShifted {
                context.isShifted = false
                key.setTitle(newTitle: TITLE_SHIFT_DEFAULT)
            } else {
                context.isShifted = true
                key.setTitle(newTitle: TITLE_SHIFT_DEPERRESED)
            }
        }
    },
    isShift: true
)

let space = SingleKey(title: " ")

let enter = UtilKey(
    id: "enter",
    title: "⏎",
    onTap: { (key, uiKeyInput, context) in
        uiKeyInput.insertText("\n")
    }
)
