//
//  Key.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

struct TapHistoryElement {
    var timestamp: TimeInterval
    var key: Key
    var context: KeyInputContext
}

class KeyInputContext {
    var isShifted = false
    var isCapsLocked = false
    var keySetName = KeySetName.ENGLISH
    var isPortrait = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
    var tapHistory = Queue<TapHistoryElement>(maxSize: 3)

    func copy() -> KeyInputContext {
        let newContext = KeyInputContext()
        newContext.isShifted = isShifted
        newContext.isCapsLocked = isCapsLocked
        newContext.keySetName = keySetName
        newContext.isPortrait = isPortrait
        newContext.tapHistory = tapHistory.copy()
        return newContext
    }

    func getKeySet() -> [[Key]] {
        switch keySetName {
        case KeySetName.ENGLISH:
            return isPortrait ? shortEnglishKeySet : longEnglishKeySet
        case KeySetName.KOREAN:
            return isPortrait ? shortKoreanKeySet : longKoreanKeySet
        case KeySetName.SYMBOLS:
            return isPortrait ? shortSymbolsKeySet : longSymbolsKeySet
        }
    }

    func setKeySet(_ name: KeySetName) {
        keySetName = name
    }

    func isDoubleTapped() -> Bool {
        let count = tapHistory.count
        if count < 2 { return false }
        guard let first = tapHistory.peek(count - 2) else { return false }
        guard let second = tapHistory.peek(count - 1) else { return false }
        if first.key.id != second.key.id { return false }
        return second.timestamp - first.timestamp < 0.5
    }

    func isShiftedDoubleTapped() -> Bool {
        if !isDoubleTapped() { return false }
        guard let first = tapHistory.peek(tapHistory.count - 2) else { return false }
        return first.context.isShifted
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
