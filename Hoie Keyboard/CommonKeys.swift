//
//  CommonKeys.swift
//  Hoie Keyboard
//
//  Created by Hoie Kim on 8/6/24.
//

import UIKit

class UtilKey: Key {
    var title: String
    var onTap: OnTap
    
    init(title: String, onTap: @escaping OnTap) {
        self.title = title
        self.onTap = onTap
    }
}

let backSpace = UtilKey(title: "⌫", onTap: { (uiKeyInput, context) in
    uiKeyInput.deleteBackward()
})

let shift = UtilKey(title: "⇧", onTap: { (uiKeyInput, context) in
    if context.isDoubleTap {
        context.isCapsLock = true
    } else {
        if context.isCapsLock {
            context.isCapsLock = false
            context.isShift = false
        } else if context.isShift {
            context.isShift = false
        } else {
            context.isShift = true
        }
    }
})
