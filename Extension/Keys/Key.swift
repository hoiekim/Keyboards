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
    func getImage(_ context: KeyInputContext) -> String?
    func getBackgroundColor(_ context: KeyInputContext) -> UIColor?
}
