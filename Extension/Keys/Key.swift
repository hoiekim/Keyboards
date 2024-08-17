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
    func onTap(document: UITextDocumentProxy, context: KeyInputContext) -> Void
    var span: Int { get }
    func getTitle(_ context: KeyInputContext) -> String?
    func getImage(_ context: KeyInputContext) -> String?
    func getBackgroundColor(_ context: KeyInputContext) -> UIColor?
}
