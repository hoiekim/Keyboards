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
    var keySet: [[Key]]
    var undoStack: [String] = []
    var redoStack: [String] = []

    init(keySet: [[Key]]) {
        self.keySet = keySet
    }
    
    convenience init(_ copyFrom: KeyInputContext) {
        self.init(keySet: copyFrom.keySet)
        self.isShifted = copyFrom.isShifted
        self.isCapsLocked = copyFrom.isCapsLocked
        self.isDoubleTapped = copyFrom.isDoubleTapped
        self.isHeld = copyFrom.isHeld
        self.undoStack = copyFrom.undoStack
        self.redoStack = copyFrom.redoStack
    }
    
    func copyFrom(_ context: KeyInputContext) {
        self.keySet = context.keySet
        self.isShifted = context.isShifted
        self.isCapsLocked = context.isCapsLocked
        self.isDoubleTapped = context.isDoubleTapped
        self.isHeld = context.isHeld
        self.undoStack = context.undoStack
        self.redoStack = context.redoStack
    }
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
