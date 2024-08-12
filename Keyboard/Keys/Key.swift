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
    var title: String { get }
    func onTap(document: UITextDocumentProxy, context: KeyInputContext) -> Void
    var span: Int { get }
    var backgroundColor: UIColor? { get }
}

class SingleKey: Key {
    let id: String
    var title: String
    let span: Int
    var backgroundColor: UIColor?

    init(title: String, span: Int = 1, backgroundColor: UIColor? = nil) {
        self.id = title
        self.title = title
        self.span = span
        self.backgroundColor = backgroundColor
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        SingleKey.onTapSingleKey(
            title: title,
            document: document,
            context: context
        )
    }

    static func onTapSingleKey(
        title: String,
        document: UIKeyInput,
        context: KeyInputContext
    ) {
        let isShifted = context.isShifted
        let isCapsLocked = context.isCapsLocked
        if isShifted || isCapsLocked { document.insertText(title.uppercased()) }
        else { document.insertText(title.lowercased()) }
    }
}

class DoubleKey: Key {
    let id: String
    var title: String
    var first: String
    var second: String
    let span: Int
    var backgroundColor: UIColor?

    init(title: String, first: String, second: String, span: Int = 1, backgroundColor: UIColor? = nil) {
        self.id = first + "_" + second
        self.title = title
        self.first = first
        self.second = second
        self.span = span
        self.backgroundColor = backgroundColor
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let isDoubleTap = context.isDoubleTapped
        if isDoubleTap { document.deleteBackward() }
        let title = if !isDoubleTap { first } else { second }
        SingleKey.onTapSingleKey(title: title, document: document, context: context)
    }
}

class UtilKey: Key {
    typealias OnTapUtilKey = (UtilKey, UITextDocumentProxy, KeyInputContext) -> Void

    let id: String
    var title: String
    let span: Int
    var backgroundColor: UIColor?
    var _onTap: OnTapUtilKey

    init(
        id: String,
        title: String,
        span: Int = 1,
        backgroundColor: UIColor? = nil,
        onTap: @escaping OnTapUtilKey
    ) {
        self.id = id
        self.title = title
        self.span = span
        self.backgroundColor = backgroundColor
        self._onTap = onTap
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        _onTap(self, document, context)
    }
}

class KoreanKey: Key {
    let id: String
    var title: String
    let first: String
    let second: String?

    let span: Int
    var backgroundColor: UIColor?

    func updateTitle(context: KeyInputContext) {
        if (context.isShifted || context.isCapsLocked) && second != nil {
            title = second!
        } else {
            title = first
        }
    }

    init(
        first: String,
        second: String? = nil,
        span: Int = 1,
        backgroundColor: UIColor? = nil
    ) {
        self.id = second == nil ? first : first + "_" + second!
        self.title = first
        self.first = first
        self.second = second
        self.span = span
        self.backgroundColor = backgroundColor
    }

    private let choseongBase: UInt32 = 0x1100
    private let choseongEnd: UInt32 = 0x115F
    private let jungseongBase: UInt32 = 0x1161
    private let jungseongEnd: UInt32 = 0x11A2
    private let jongseongBase: UInt32 = 0x11A8
    private let syllableBase: UInt32 = 0xAC00
    private let syllableEnd: UInt32 = 0xD7A3

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let isSecond = context.isShifted || context.isCapsLocked || context.isDoubleTapped
        let key = isSecond && second != nil ? second! : first

        guard let beforeText = document.documentContextBeforeInput else { return document.insertText(key) }
        guard let components = decompose(beforeText) else { return document.insertText(key) }

        let isConsonant = isChoseung(key)
        let isVowel = isJungseung(key)
        if isConsonant == isVowel { return }

        let (initial, medial, final) = components
        
        if context.isDoubleTapped && second != nil {
            document.deleteBackward()
            if isConsonant && final != nil {
                document.insertText(compose(initial!, medial!)!)
            } else if isVowel && initial != nil {
                document.insertText(initial!)
            }
        }

        switch (initial, medial, final) {
        case (.some, .some, .some):
            if isConsonant {
                if let combined = combineConsonants(final!, key) {
                    document.deleteBackward()
                    return document.insertText(compose(initial!, medial!, combined)!)
                } else {
                    return document.insertText(key)
                }
            } else {
                if let (jongseoung, choseoung) = splitJongseoung(final!) {
                    document.deleteBackward()
                    document.insertText(compose(initial!, medial!, jongseoung)!)
                    return document.insertText(compose(choseoung, key)!)
                } else {
                    document.deleteBackward()
                    document.insertText(compose(initial!, medial!)!)
                    return document.insertText(compose(final!, key)!)
                }
            }
        case (.some, .some, nil):
            if isConsonant {
                // TODO: handle cases when double tapped consonants can't compose a syllable
                document.deleteBackward()
                return document.insertText(compose(initial!, medial!, key)!)
            } else {
                if let combined = combineVowels(medial!, key) {
                    document.deleteBackward()
                    return document.insertText(compose(initial!, combined)!)
                } else {
                    return document.insertText(key)
                }
            }
        case (.some, nil, nil):
            if isConsonant {
                return document.insertText(key)
            } else {
                document.deleteBackward()
                return document.insertText(compose(initial!, key)!)
            }
        default:
            document.insertText(key)
        }
    }

    typealias Components = (initial: String?, medial: String?, final: String?)

    private func decompose(_ string: String) -> Components? {
        // Check if the input is a Korean syllable
        if !isSyllable(string) {
            if isChoseung(string) {
                return (string, nil, nil)
            } else if isJungseung(string) {
                return (nil, string, nil)
            } else {
                return nil
            }
        }

        guard let scalarValue = string.unicodeScalars.first?.value else { return nil }
        let syllableIndex = scalarValue - syllableBase

        // Initial consonants (19 options)
        let initialIndex = syllableIndex / 28 / 21
        let initialConsonants = ["ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ",
                                 "ㅃ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ",
                                 "ㅌ", "ㅍ", "ㅎ"]

        // Medial vowels (21 options)
        let medialIndex = (syllableIndex % (28 * 21)) / 28
        let medialVowels = ["ㅏ", "ㅐ", "ㅑ", "ㅒ", "ㅓ", "ㅔ", "ㅕ", "ㅖ",
                            "ㅗ", "ㅘ", "ㅙ", "ㅚ", "ㅛ", "ㅜ", "ㅝ", "ㅞ",
                            "ㅟ", "ㅠ", "ㅡ", "ㅢ", "ㅣ"]

        // Final consonants (28 options, including empty final)
        let finalIndex = syllableIndex % 28
        let finalConsonants = ["", "ㄱ", "ㄲ", "ㄳ", "ㄴ", "ㄵ", "ㄶ", "ㄷ",
                               "ㄹ", "ㄺ", "ㄻ", "ㄼ", "ㄽ", "ㄾ", "ㄿ", "ㅀ",
                               "ㅁ", "ㅂ", "ㅄ", "ㅅ", "ㅆ", "ㅇ", "ㅈ", "ㅊ",
                               "ㅋ", "ㅌ", "ㅍ", "ㅎ"]

        // Extract initial, medial, and final components
        let initial = initialConsonants[Int(initialIndex)]
        let medial = medialVowels[Int(medialIndex)]
        let final = finalConsonants[Int(finalIndex)]

        return (initial, medial, final.isEmpty ? nil : final)
    }

    private func compose(_ initial: String, _ medial: String, _ final: String? = nil) -> String? {
        let initialIndex = initial.unicodeScalars.first!.value - choseongBase
        let medialIndex = medial.unicodeScalars.first!.value - jungseongBase
        let finalIndex = final != nil ? final!.unicodeScalars.first!.value - jongseongBase : 0
        let syllableValue = syllableBase + (initialIndex * 21 * 28) + (medialIndex * 28) + finalIndex
        let syllable = String(UnicodeScalar(syllableValue)!)
        if isSyllable(syllable) { return syllable }
        else { return nil }
    }

    private func isChoseung(_ string: String) -> Bool {
        guard let character = string.first else { return false }
        let unicode = character.unicodeScalars.first!.value
        return unicode >= choseongBase && unicode <= choseongEnd
    }

    private func isJungseung(_ string: String) -> Bool {
        guard let character = string.first else { return false }
        let unicode = character.unicodeScalars.first!.value
        return unicode >= jungseongBase && unicode <= jungseongEnd
    }

    private func isSyllable(_ string: String) -> Bool {
        guard let character = string.first else { return false }
        let unicode = character.unicodeScalars.first!.value
        return unicode >= syllableBase && unicode <= syllableEnd
    }

    private func choseongToJongseong(_ choseong: String) -> String? {
        if !isChoseung(choseong) { return nil }
        guard let character = choseong.first else { return nil }
        // Calculate the corresponding Jongseong Unicode scalar
        let choseongValue = character.unicodeScalars.first!.value
        let jongseongValue = choseongValue - choseongBase + jongseongBase
        // Convert the Unicode scalar to a Character
        return String(UnicodeScalar(jongseongValue)!)
    }
    
    private func combineConsonants(_ first: String, _ second: String) -> String? {
        switch (first, second) {
        case ("ㄱ", "ㅅ"): return "ㄳ"
        case ("ㄴ", "ㅈ"): return "ㄵ"
        case ("ㄴ", "ㅎ"): return "ㄶ"
        case ("ㄹ", "ㄱ"): return "ㄺ"
        case ("ㄹ", "ㅁ"): return "ㄻ"
        case ("ㄹ", "ㅂ"): return "ㄼ"
        case ("ㄹ", "ㅅ"): return "ㄽ"
        case ("ㄹ", "ㅌ"): return "ㄾ"
        case ("ㄹ", "ㅍ"): return "ㄿ"
        case ("ㄹ", "ㅎ"): return "ㅀ"
        case ("ㅂ", "ㅅ"): return "ㅄ"
        default: return nil
        }
    }
    
    private func splitJongseoung(_ jongseoung: String) -> (String, String)? {
        switch (jongseoung) {
        case "ㄳ": return ("ㄱ", "ㅅ")
        case "ㄵ": return ("ㄴ", "ㅈ")
        case "ㄶ": return ("ㄴ", "ㅎ")
        case "ㄺ": return ("ㄹ", "ㄱ")
        case "ㄻ": return ("ㄹ", "ㅁ")
        case "ㄼ": return ("ㄹ", "ㅂ")
        case "ㄽ": return ("ㄹ", "ㅅ")
        case "ㄾ": return ("ㄹ", "ㅌ")
        case "ㄿ": return ("ㄹ", "ㅍ")
        case "ㅀ": return ("ㄹ", "ㅎ")
        case "ㅄ": return ("ㅂ", "ㅅ")
        default: return nil
        }
    }
    
    private func combineVowels(_ first: String, _ second: String) -> String? {
        switch (first, second) {
        case ("ㅗ", "ㅏ"): return "ㅘ"
        case ("ㅗ", "ㅐ"): return "ㅙ"
        case ("ㅗ", "ㅣ"): return "ㅚ"
        case ("ㅜ", "ㅓ"): return "ㅝ"
        case ("ㅜ", "ㅔ"): return "ㅞ"
        case ("ㅜ", "ㅣ"): return "ㅟ"
        case ("ㅡ", "ㅣ"): return "ㅢ"
        default: return nil
        }
    }
}
