//
//  Key.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

struct TapHistoryElement: Equatable {
    static func == (lhs: TapHistoryElement, rhs: TapHistoryElement) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }
    
    let timestamp: TimeInterval
    let key: Key
    let context: KeyInputContext
}

class KeyInputContext {
    var isShifted = false
    var isCapsLocked = false
    var isLongHold = false
    var keySetName = KeySetName.ENGLISH
    var lastLetterKeySetName = KeySetName.ENGLISH
    var isSplit = false
    var isPortrait = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
    var tapHistory = Queue<TapHistoryElement>(maxSize: 3)

    func copy() -> KeyInputContext {
        let newContext = KeyInputContext()
        newContext.isShifted = isShifted
        newContext.isCapsLocked = isCapsLocked
        newContext.keySetName = keySetName
        newContext.lastLetterKeySetName = lastLetterKeySetName
        newContext.isSplit = isSplit
        newContext.isPortrait = isPortrait
        newContext.tapHistory = tapHistory.copy()
        return newContext
    }
    
    func override(from: PartialKeyInputContext) {
        if from.isShifted != nil { self.isShifted = from.isShifted! }
        if from.isCapsLocked != nil { self.isCapsLocked = from.isCapsLocked! }
        if from.keySetName != nil { self.keySetName = from.keySetName! }
        if from.lastLetterKeySetName != nil { self.lastLetterKeySetName = from.lastLetterKeySetName! }
        if from.isPortrait != nil { self.isPortrait = from.isPortrait! }
        if from.tapHistory != nil { self.tapHistory = from.tapHistory! }
    }
    
    func getDiff(from: KeyInputContext) -> PartialKeyInputContext {
        return PartialKeyInputContext(
            isShifted: from.isShifted != self.isShifted ? self.isShifted : nil,
            isCapsLocked: from.isCapsLocked != self.isCapsLocked ? self.isCapsLocked : nil,
            keySetName: from.keySetName != self.keySetName ? self.keySetName : nil,
            lastLetterKeySetName: from.lastLetterKeySetName != self.lastLetterKeySetName
                ? self.lastLetterKeySetName
                : nil,
            isPortrait: from.isPortrait != self.isPortrait ? self.isPortrait : nil,
            tapHistory: from.tapHistory != self.tapHistory ? self.tapHistory : nil
        )
    }

    func getKeySet() -> [[Key]] {
        // Split layout reuses the short (portrait) key sets so that muscle
        // memory is shared between portrait and wide screens.
        let useShort = isPortrait || isSplit
        switch keySetName {
        case KeySetName.ENGLISH:
            return useShort ? shortEnglishKeySet : longEnglishKeySet
        case KeySetName.KOREAN:
            return useShort ? shortKoreanKeySet : longKoreanKeySet
        case KeySetName.SYMBOLS:
            return useShort ? shortSymbolsKeySet : longSymbolsKeySet
        case KeySetName.NUMBERS:
            return useShort ? shortNumbersKeySet : longNumbersKeySet
        }
    }

    func setKeySet(_ name: KeySetName) {
        keySetName = name
        if name == KeySetName.ENGLISH || name == KeySetName.KOREAN {
            lastLetterKeySetName = name
        }
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

struct PartialKeyInputContext {
    let isShifted: Bool?
    let isCapsLocked: Bool?
    let keySetName: KeySetName?
    let lastLetterKeySetName: KeySetName?
    let isPortrait: Bool?
    let tapHistory: Queue<TapHistoryElement>?
}

enum KeySetName {
    case ENGLISH
    case KOREAN
    case SYMBOLS
    case NUMBERS
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
