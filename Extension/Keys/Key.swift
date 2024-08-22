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
}

protocol Key {
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
