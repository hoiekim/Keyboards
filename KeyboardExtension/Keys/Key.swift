//
//  Key.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

class KeyInputContext {
    var isShifted = false
    var isCapsLocked = false
    var isDoubleTapped = false
    var isHeld = false
    var keySetName = KeySetName.ENGLISH
    var isPortrait = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
    
    var undoStack: [String] = []
    var redoStack: [String] = []
    
    convenience init(_ copyFrom: KeyInputContext) {
        self.init()
        self.isShifted = copyFrom.isShifted
        self.isCapsLocked = copyFrom.isCapsLocked
        self.isDoubleTapped = copyFrom.isDoubleTapped
        self.isHeld = copyFrom.isHeld
        self.keySetName = copyFrom.keySetName
        self.undoStack = copyFrom.undoStack
        self.redoStack = copyFrom.redoStack
    }
    
    static func copyFrom(_ context: KeyInputContext) -> KeyInputContext {
        let newContext = KeyInputContext()
        newContext.isShifted = context.isShifted
        newContext.isCapsLocked = context.isCapsLocked
        newContext.isDoubleTapped = context.isDoubleTapped
        newContext.isHeld = context.isHeld
        newContext.keySetName = context.keySetName
        newContext.undoStack = context.undoStack
        newContext.redoStack = context.redoStack
        return newContext
    }
    
    func getKeySet() -> [[Key]] {
        switch(keySetName) {
        case KeySetName.ENGLISH:
            return isPortrait ? shortEnglishKeySet : longEnglishKeySet
        case KeySetName.KOREAN:
            return isPortrait ? shortKoreanKeySet : longKoreanKeySet
        case KeySetName.SYMBOLS:
            return isPortrait ? shortSymbolsKeySet : longSymbolsKeySet
        }
    }
    
    func setKeySet(_ name: KeySetName) {
        self.keySetName = name
    }
}

enum KeySetName {
    case ENGLISH
    case KOREAN
    case SYMBOLS
}

protocol Key {
    var className: String { get }
    var id: String { get }
    var span: Int { get }
    var remountOnTap: Bool { get }
    var updateButtonImagesOnTap: Bool { get }
    func onTap(document: UITextDocumentProxy, context: KeyInputContext) -> Void
    func getTitle(_ context: KeyInputContext) -> String?
    func getTitleSuperscript(_ context: KeyInputContext) -> String?
    func getImage(_ context: KeyInputContext) -> UIImage?
    func getBackgroundColor(_ context: KeyInputContext) -> UIColor?
}

func updateUndoStack(_ document: UITextDocumentProxy, _ context: KeyInputContext) {
    context.redoStack.removeAll()
    let beforeText = document.documentContextBeforeInput ?? ""
    let afterText = document.documentContextAfterInput ?? ""
    context.undoStack.append(beforeText + afterText)
    print(context.undoStack)
    print(context.redoStack)
}
