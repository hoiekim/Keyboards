//
//  HangulKey.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

private let syllableBase: UInt32 = 0xac00
private let syllableEnd: UInt32 = 0xd7a3

let LETTER_ㄱ: UInt32 = 0x3131
let LETTER_ㄲ: UInt32 = 0x3132
let LETTER_ㄴ: UInt32 = 0x3134
let LETTER_ㄷ: UInt32 = 0x3137
let LETTER_ㄸ: UInt32 = 0x3138
let LETTER_ㄹ: UInt32 = 0x3139
let LETTER_ㅁ: UInt32 = 0x3141
let LETTER_ㅂ: UInt32 = 0x3142
let LETTER_ㅃ: UInt32 = 0x3143
let LETTER_ㅅ: UInt32 = 0x3145
let LETTER_ㅆ: UInt32 = 0x3146
let LETTER_ㅇ: UInt32 = 0x3147
let LETTER_ㅈ: UInt32 = 0x3148
let LETTER_ㅉ: UInt32 = 0x3149
let LETTER_ㅊ: UInt32 = 0x314a
let LETTER_ㅋ: UInt32 = 0x314b
let LETTER_ㅌ: UInt32 = 0x314c
let LETTER_ㅍ: UInt32 = 0x314d
let LETTER_ㅎ: UInt32 = 0x314e

let LETTER_ㅏ: UInt32 = 0x314f
let LETTER_ㅐ: UInt32 = 0x3150
let LETTER_ㅑ: UInt32 = 0x3151
let LETTER_ㅒ: UInt32 = 0x3152
let LETTER_ㅓ: UInt32 = 0x3153
let LETTER_ㅔ: UInt32 = 0x3154
let LETTER_ㅕ: UInt32 = 0x3155
let LETTER_ㅖ: UInt32 = 0x3156
let LETTER_ㅗ: UInt32 = 0x3157
let LETTER_ㅛ: UInt32 = 0x315b
let LETTER_ㅜ: UInt32 = 0x315c
let LETTER_ㅠ: UInt32 = 0x3160
let LETTER_ㅡ: UInt32 = 0x3161
let LETTER_ㅣ: UInt32 = 0x3163

let CHOSEONG_ㄱ: UInt32 = 0x1100
let CHOSEONG_ㄲ: UInt32 = 0x1101
let CHOSEONG_ㄴ: UInt32 = 0x1102
let CHOSEONG_ㄷ: UInt32 = 0x1103
let CHOSEONG_ㄸ: UInt32 = 0x1104
let CHOSEONG_ㄹ: UInt32 = 0x1105
let CHOSEONG_ㅁ: UInt32 = 0x1106
let CHOSEONG_ㅂ: UInt32 = 0x1107
let CHOSEONG_ㅃ: UInt32 = 0x1108
let CHOSEONG_ㅅ: UInt32 = 0x1109
let CHOSEONG_ㅆ: UInt32 = 0x110a
let CHOSEONG_ㅇ: UInt32 = 0x110b
let CHOSEONG_ㅈ: UInt32 = 0x110c
let CHOSEONG_ㅉ: UInt32 = 0x110d
let CHOSEONG_ㅊ: UInt32 = 0x110e
let CHOSEONG_ㅋ: UInt32 = 0x110f
let CHOSEONG_ㅌ: UInt32 = 0x1110
let CHOSEONG_ㅍ: UInt32 = 0x1111
let CHOSEONG_ㅎ: UInt32 = 0x1112

let JUNGSEONG_ㅏ: UInt32 = 0x1161
let JUNGSEONG_ㅐ: UInt32 = 0x1162
let JUNGSEONG_ㅑ: UInt32 = 0x1163
let JUNGSEONG_ㅒ: UInt32 = 0x1164
let JUNGSEONG_ㅓ: UInt32 = 0x1165
let JUNGSEONG_ㅔ: UInt32 = 0x1166
let JUNGSEONG_ㅕ: UInt32 = 0x1167
let JUNGSEONG_ㅖ: UInt32 = 0x1168
let JUNGSEONG_ㅗ: UInt32 = 0x1169
let JUNGSEONG_ㅘ: UInt32 = 0x116a
let JUNGSEONG_ㅙ: UInt32 = 0x116b
let JUNGSEONG_ㅚ: UInt32 = 0x116c
let JUNGSEONG_ㅛ: UInt32 = 0x116d
let JUNGSEONG_ㅜ: UInt32 = 0x116e
let JUNGSEONG_ㅝ: UInt32 = 0x116f
let JUNGSEONG_ㅞ: UInt32 = 0x1170
let JUNGSEONG_ㅟ: UInt32 = 0x1171
let JUNGSEONG_ㅠ: UInt32 = 0x1172
let JUNGSEONG_ㅡ: UInt32 = 0x1173
let JUNGSEONG_ㅢ: UInt32 = 0x1174
let JUNGSEONG_ㅣ: UInt32 = 0x1175

let JONGSEONG_PLACEHOLDER: UInt32 = 0x11a7
let JONGSEONG_ᆨ: UInt32 = 0x11a8
let JONGSEONG_ᆩ: UInt32 = 0x11a9
let JONGSEONG_ᆪ: UInt32 = 0x11aa
let JONGSEONG_ᆫ: UInt32 = 0x11ab
let JONGSEONG_ᆬ: UInt32 = 0x11ac
let JONGSEONG_ᆭ: UInt32 = 0x11ad
let JONGSEONG_ᆮ: UInt32 = 0x11ae
let JONGSEONG_ᆯ: UInt32 = 0x11af
let JONGSEONG_ᆰ: UInt32 = 0x11b0
let JONGSEONG_ᆱ: UInt32 = 0x11b1
let JONGSEONG_ᆲ: UInt32 = 0x11b2
let JONGSEONG_ᆳ: UInt32 = 0x11b3
let JONGSEONG_ᆴ: UInt32 = 0x11b4
let JONGSEONG_ᆵ: UInt32 = 0x11b5
let JONGSEONG_ᆶ: UInt32 = 0x11b6
let JONGSEONG_ᆷ: UInt32 = 0x11b7
let JONGSEONG_ᆸ: UInt32 = 0x11b8
let JONGSEONG_ᆹ: UInt32 = 0x11b9
let JONGSEONG_ᆺ: UInt32 = 0x11ba
let JONGSEONG_ᆻ: UInt32 = 0x11bb
let JONGSEONG_ᆼ: UInt32 = 0x11bc
let JONGSEONG_ᆽ: UInt32 = 0x11bd
let JONGSEONG_ᆾ: UInt32 = 0x11be
let JONGSEONG_ᆿ: UInt32 = 0x11bf
let JONGSEONG_ᇀ: UInt32 = 0x11c0
let JONGSEONG_ᇁ: UInt32 = 0x11c1
let JONGSEONG_ᇂ: UInt32 = 0x11c2

class HangulKey: Key {
    let id: String
    let first: String
    let second: String?
    let span: Int = 1

    init(
        firstUnicode: UInt32,
        secondUnicode: UInt32? = nil
    ) {
        let first = unicodeToString(firstUnicode)
        let second = secondUnicode != nil ? unicodeToString(secondUnicode!) : nil
        self.id = "HangulKey_" + (second == nil ? first : first + "_" + second!)
        self.first = first
        self.second = second
    }

    func getTitle(_ context: KeyInputContext) -> String? {
        if (context.isShifted || context.isCapsLocked) && second != nil {
            return second!
        } else {
            return first
        }
    }

    func getImage(_ context: KeyInputContext) -> String? {
        return nil
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return UIColor.systemBlue
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        let isSecond = context.isShifted || context.isCapsLocked
        let key = isSecond && second != nil ? second! : first

        let isConsonant = isConsonant(key)
        let isVowel = isVowel(key)

        // invalid key
        if isConsonant == isVowel { return }

        guard let beforeText = document.documentContextBeforeInput else { return document.insertText(key) }
        guard let lastString = beforeText.last else { return document.insertText(key) }
        guard let components = decompose(String(lastString)) else { return document.insertText(key) }

        let (initial, medial, final) = components

        switch (initial, medial, final) {
        case (.some, .some, .some):
            if isConsonant {
                if let combined = combineJongseong(final!, key) {
                    document.deleteBackward()
                    let syllable = compose(initial!, medial!, combined)!
                    document.insertText(syllable)
                } else {
                    document.insertText(key)
                }
            } else {
                let jungseong = letterToJungseong(key)!
                if let (jongseoung, choseoung) = splitJongseoung(final!) {
                    let syllable1 = compose(initial!, medial!, jongseoung)!
                    let syllable2 = compose(choseoung, jungseong)!
                    document.deleteBackward()
                    document.insertText(syllable1)
                    document.insertText(syllable2)
                } else {
                    let choseong = jongseongToChoseong(final!)!
                    let syllable1 = compose(initial!, medial!)!
                    let syllable2 = compose(choseong, jungseong)!
                    document.deleteBackward()
                    document.insertText(syllable1)
                    document.insertText(syllable2)
                }
            }
        case (.some, .some, nil):
            if isConsonant {
                if let jongseong = letterToJongseong(key) {
                    let syllable = compose(initial!, medial!, jongseong)!
                    document.deleteBackward()
                    document.insertText(syllable)
                } else {
                    document.insertText(key)
                }
            } else {
                if let combined = combineVowels(medial!, key) {
                    let syllable = compose(initial!, combined)!
                    document.deleteBackward()
                    document.insertText(syllable)
                } else {
                    document.insertText(key)
                }
            }
        case (.some, nil, nil):
            if isConsonant {
                document.insertText(key)
            } else {
                let jungseong = letterToJungseong(key)!
                let syllable = compose(initial!, jungseong)!
                document.deleteBackward()
                document.insertText(syllable)
            }
        default:
            document.insertText(key)
        }
    }
}

private func unicodeToString(_ unicode: UInt32) -> String {
    return String(Character(UnicodeScalar(unicode)!))
}

typealias Components = (initial: String?, medial: String?, final: String?)

private func decompose(_ string: String) -> Components? {
    if !isSyllable(string) { return letterToComponent(string) }

    guard let scalarValue = string.unicodeScalars.first?.value else { return nil }
    let syllableIndex = scalarValue - syllableBase

    let initialIndex = syllableIndex / 28 / 21
    let initials = [
        CHOSEONG_ㄱ,
        CHOSEONG_ㄲ,
        CHOSEONG_ㄴ,
        CHOSEONG_ㄷ,
        CHOSEONG_ㄸ,
        CHOSEONG_ㄹ,
        CHOSEONG_ㅁ,
        CHOSEONG_ㅂ,
        CHOSEONG_ㅃ,
        CHOSEONG_ㅅ,
        CHOSEONG_ㅆ,
        CHOSEONG_ㅇ,
        CHOSEONG_ㅈ,
        CHOSEONG_ㅉ,
        CHOSEONG_ㅊ,
        CHOSEONG_ㅋ,
        CHOSEONG_ㅌ,
        CHOSEONG_ㅍ,
        CHOSEONG_ㅎ
    ]

    let medialIndex = (syllableIndex % (28 * 21)) / 28
    let medials = [
        JUNGSEONG_ㅏ,
        JUNGSEONG_ㅐ,
        JUNGSEONG_ㅑ,
        JUNGSEONG_ㅒ,
        JUNGSEONG_ㅓ,
        JUNGSEONG_ㅔ,
        JUNGSEONG_ㅕ,
        JUNGSEONG_ㅖ,
        JUNGSEONG_ㅗ,
        JUNGSEONG_ㅘ,
        JUNGSEONG_ㅙ,
        JUNGSEONG_ㅚ,
        JUNGSEONG_ㅛ,
        JUNGSEONG_ㅜ,
        JUNGSEONG_ㅝ,
        JUNGSEONG_ㅞ,
        JUNGSEONG_ㅟ,
        JUNGSEONG_ㅠ,
        JUNGSEONG_ㅡ,
        JUNGSEONG_ㅢ,
        JUNGSEONG_ㅣ
    ]

    let finalIndex = syllableIndex % 28
    let finals = [
        nil,
        JONGSEONG_ᆨ,
        JONGSEONG_ᆩ,
        JONGSEONG_ᆪ,
        JONGSEONG_ᆫ,
        JONGSEONG_ᆬ,
        JONGSEONG_ᆭ,
        JONGSEONG_ᆮ,
        JONGSEONG_ᆯ,
        JONGSEONG_ᆰ,
        JONGSEONG_ᆱ,
        JONGSEONG_ᆲ,
        JONGSEONG_ᆳ,
        JONGSEONG_ᆴ,
        JONGSEONG_ᆵ,
        JONGSEONG_ᆶ,
        JONGSEONG_ᆷ,
        JONGSEONG_ᆸ,
        JONGSEONG_ᆹ,
        JONGSEONG_ᆺ,
        JONGSEONG_ᆻ,
        JONGSEONG_ᆼ,
        JONGSEONG_ᆽ,
        JONGSEONG_ᆾ,
        JONGSEONG_ᆿ,
        JONGSEONG_ᇀ,
        JONGSEONG_ᇁ,
        JONGSEONG_ᇂ
    ]

    let initial = initials[Int(initialIndex)]
    let medial = medials[Int(medialIndex)]
    let final = finals[Int(finalIndex)]

    let initialString = unicodeToString(initial)
    let medialString = unicodeToString(medial)
    let finalString = (final != nil) ? unicodeToString(final!) : nil

    return (initialString, medialString, finalString)
}

private func compose(_ initial: String, _ medial: String, _ final: String? = nil) -> String? {
    let initialIndex = initial.unicodeScalars.first!.value - CHOSEONG_ㄱ
    let medialIndex = medial.unicodeScalars.first!.value - JUNGSEONG_ㅏ
    let finalIndex = final != nil ? final!.unicodeScalars.first!.value - JONGSEONG_PLACEHOLDER : 0
    let syllableValue = syllableBase + (initialIndex * 21 * 28) + (medialIndex * 28) + finalIndex
    let syllable = unicodeToString(syllableValue)
    if isSyllable(syllable) { return syllable }
    else { return nil }
}

private func isConsonant(_ string: String) -> Bool {
    let unicode = string.unicodeScalars.first!.value
    return unicode >= LETTER_ㄱ && unicode <= LETTER_ㅎ
}

private func isVowel(_ string: String) -> Bool {
    let unicode = string.unicodeScalars.first!.value
    return unicode >= LETTER_ㅏ && unicode <= LETTER_ㅣ
}

private func isSyllable(_ string: String) -> Bool {
    let unicode = string.unicodeScalars.first!.value
    return unicode >= syllableBase && unicode <= syllableEnd
}

private func jongseongToChoseong(_ string: String) -> String? {
    if !isConsonant(string) { return nil }
    let unicode = string.unicodeScalars.first!.value
    switch unicode {
    case JONGSEONG_ᆨ: return unicodeToString(CHOSEONG_ㄱ)
    case JONGSEONG_ᆩ: return unicodeToString(CHOSEONG_ㄲ)
    case JONGSEONG_ᆫ: return unicodeToString(CHOSEONG_ㄴ)
    case JONGSEONG_ᆮ: return unicodeToString(CHOSEONG_ㄷ)
    case JONGSEONG_ᆯ: return unicodeToString(CHOSEONG_ㄹ)
    case JONGSEONG_ᆷ: return unicodeToString(CHOSEONG_ㅁ)
    case JONGSEONG_ᆸ: return unicodeToString(CHOSEONG_ㅂ)
    case JONGSEONG_ᆺ: return unicodeToString(CHOSEONG_ㅅ)
    case JONGSEONG_ᆻ: return unicodeToString(CHOSEONG_ㅆ)
    case JONGSEONG_ᆼ: return unicodeToString(CHOSEONG_ㅇ)
    case JONGSEONG_ᆽ: return unicodeToString(CHOSEONG_ㅈ)
    case JONGSEONG_ᆾ: return unicodeToString(CHOSEONG_ㅊ)
    case JONGSEONG_ᆿ: return unicodeToString(CHOSEONG_ㅋ)
    case JONGSEONG_ᇀ: return unicodeToString(CHOSEONG_ㅌ)
    case JONGSEONG_ᇁ: return unicodeToString(CHOSEONG_ㅍ)
    case JONGSEONG_ᇂ: return unicodeToString(CHOSEONG_ㅎ)
    default: return nil
    }
}

private func letterToChoseong(_ string: String) -> String? {
    if !isConsonant(string) { return nil }
    let unicode = string.unicodeScalars.first!.value
    switch unicode {
    case LETTER_ㄱ: return unicodeToString(CHOSEONG_ㄱ)
    case LETTER_ㄲ: return unicodeToString(CHOSEONG_ㄲ)
    case LETTER_ㄴ: return unicodeToString(CHOSEONG_ㄴ)
    case LETTER_ㄷ: return unicodeToString(CHOSEONG_ㄷ)
    case LETTER_ㄸ: return unicodeToString(CHOSEONG_ㄸ)
    case LETTER_ㄹ: return unicodeToString(CHOSEONG_ㄹ)
    case LETTER_ㅁ: return unicodeToString(CHOSEONG_ㅁ)
    case LETTER_ㅂ: return unicodeToString(CHOSEONG_ㅂ)
    case LETTER_ㅃ: return unicodeToString(CHOSEONG_ㅃ)
    case LETTER_ㅅ: return unicodeToString(CHOSEONG_ㅅ)
    case LETTER_ㅆ: return unicodeToString(CHOSEONG_ㅆ)
    case LETTER_ㅇ: return unicodeToString(CHOSEONG_ㅇ)
    case LETTER_ㅈ: return unicodeToString(CHOSEONG_ㅈ)
    case LETTER_ㅉ: return unicodeToString(CHOSEONG_ㅉ)
    case LETTER_ㅊ: return unicodeToString(CHOSEONG_ㅊ)
    case LETTER_ㅋ: return unicodeToString(CHOSEONG_ㅋ)
    case LETTER_ㅌ: return unicodeToString(CHOSEONG_ㅌ)
    case LETTER_ㅍ: return unicodeToString(CHOSEONG_ㅍ)
    case LETTER_ㅎ: return unicodeToString(CHOSEONG_ㅎ)
    default: return nil
    }
}

private func letterToJungseong(_ string: String) -> String? {
    if isConsonant(string) { return nil }
    let unicode = string.unicodeScalars.first!.value
    switch unicode {
    case LETTER_ㅏ: return unicodeToString(JUNGSEONG_ㅏ)
    case LETTER_ㅐ: return unicodeToString(JUNGSEONG_ㅐ)
    case LETTER_ㅑ: return unicodeToString(JUNGSEONG_ㅑ)
    case LETTER_ㅒ: return unicodeToString(JUNGSEONG_ㅒ)
    case LETTER_ㅓ: return unicodeToString(JUNGSEONG_ㅓ)
    case LETTER_ㅔ: return unicodeToString(JUNGSEONG_ㅔ)
    case LETTER_ㅕ: return unicodeToString(JUNGSEONG_ㅕ)
    case LETTER_ㅖ: return unicodeToString(JUNGSEONG_ㅖ)
    case LETTER_ㅗ: return unicodeToString(JUNGSEONG_ㅗ)
    case LETTER_ㅛ: return unicodeToString(JUNGSEONG_ㅛ)
    case LETTER_ㅜ: return unicodeToString(JUNGSEONG_ㅜ)
    case LETTER_ㅠ: return unicodeToString(JUNGSEONG_ㅠ)
    case LETTER_ㅡ: return unicodeToString(JUNGSEONG_ㅡ)
    case LETTER_ㅣ: return unicodeToString(JUNGSEONG_ㅣ)
    default: return nil
    }
}

private func letterToJongseong(_ string: String) -> String? {
    if !isConsonant(string) { return nil }
    let unicode = string.unicodeScalars.first!.value
    switch unicode {
    case LETTER_ㄱ: return unicodeToString(JONGSEONG_ᆨ)
    case LETTER_ㄲ: return unicodeToString(JONGSEONG_ᆩ)
    case LETTER_ㄴ: return unicodeToString(JONGSEONG_ᆫ)
    case LETTER_ㄷ: return unicodeToString(JONGSEONG_ᆮ)
    case LETTER_ㄸ: return nil
    case LETTER_ㄹ: return unicodeToString(JONGSEONG_ᆯ)
    case LETTER_ㅁ: return unicodeToString(JONGSEONG_ᆷ)
    case LETTER_ㅂ: return unicodeToString(JONGSEONG_ᆸ)
    case LETTER_ㅃ: return nil
    case LETTER_ㅅ: return unicodeToString(JONGSEONG_ᆺ)
    case LETTER_ㅆ: return unicodeToString(JONGSEONG_ᆻ)
    case LETTER_ㅇ: return unicodeToString(JONGSEONG_ᆼ)
    case LETTER_ㅈ: return unicodeToString(JONGSEONG_ᆽ)
    case LETTER_ㅉ: return nil
    case LETTER_ㅊ: return unicodeToString(JONGSEONG_ᆾ)
    case LETTER_ㅋ: return unicodeToString(JONGSEONG_ᆿ)
    case LETTER_ㅌ: return unicodeToString(JONGSEONG_ᇀ)
    case LETTER_ㅍ: return unicodeToString(JONGSEONG_ᇁ)
    case LETTER_ㅎ: return unicodeToString(JONGSEONG_ᇂ)
    default: return nil
    }
}

private func letterToComponent(_ string: String) -> Components? {
    if isConsonant(string) {
        return (letterToChoseong(string), nil, nil)
    } else {
        return (nil, letterToJungseong(string), nil)
    }
}

private func combineJongseong(_ first: String, _ second: String) -> String? {
    let firstUnicode = first.unicodeScalars.first!.value
    let secondUnicode = second.unicodeScalars.first!.value
    switch (firstUnicode, secondUnicode) {
    case (JONGSEONG_ᆨ, LETTER_ㅅ): return unicodeToString(JONGSEONG_ᆪ)
    case (JONGSEONG_ᆫ, LETTER_ㅈ): return unicodeToString(JONGSEONG_ᆬ)
    case (JONGSEONG_ᆫ, LETTER_ㅎ): return unicodeToString(JONGSEONG_ᆭ)
    case (JONGSEONG_ᆯ, LETTER_ㄱ): return unicodeToString(JONGSEONG_ᆰ)
    case (JONGSEONG_ᆯ, LETTER_ㅁ): return unicodeToString(JONGSEONG_ᆱ)
    case (JONGSEONG_ᆯ, LETTER_ㅂ): return unicodeToString(JONGSEONG_ᆲ)
    case (JONGSEONG_ᆯ, LETTER_ㅅ): return unicodeToString(JONGSEONG_ᆳ)
    case (JONGSEONG_ᆯ, LETTER_ㅌ): return unicodeToString(JONGSEONG_ᆴ)
    case (JONGSEONG_ᆯ, LETTER_ㅍ): return unicodeToString(JONGSEONG_ᆵ)
    case (JONGSEONG_ᆯ, LETTER_ㅎ): return unicodeToString(JONGSEONG_ᆶ)
    case (JONGSEONG_ᆸ, LETTER_ㅅ): return unicodeToString(JONGSEONG_ᆹ)
    default: return nil
    }
}

private func splitJongseoung(_ jongseoung: String) -> (String?, String)? {
    let unicode = jongseoung.unicodeScalars.first!.value
    switch unicode {
    case JONGSEONG_ᆨ: return (nil, unicodeToString(CHOSEONG_ㄱ))
    case JONGSEONG_ᆩ: return (nil, unicodeToString(CHOSEONG_ㄲ))
    case JONGSEONG_ᆪ: return (unicodeToString(JONGSEONG_ᆨ), unicodeToString(CHOSEONG_ㅅ))
    case JONGSEONG_ᆫ: return (nil, unicodeToString(CHOSEONG_ㄴ))
    case JONGSEONG_ᆬ: return (unicodeToString(JONGSEONG_ᆫ), unicodeToString(CHOSEONG_ㅈ))
    case JONGSEONG_ᆭ: return (unicodeToString(JONGSEONG_ᆫ), unicodeToString(CHOSEONG_ㅎ))
    case JONGSEONG_ᆮ: return (nil, unicodeToString(CHOSEONG_ㄷ))
    case JONGSEONG_ᆯ: return (nil, unicodeToString(CHOSEONG_ㄹ))
    case JONGSEONG_ᆰ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㄱ))
    case JONGSEONG_ᆱ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㅁ))
    case JONGSEONG_ᆲ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㅂ))
    case JONGSEONG_ᆳ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㅅ))
    case JONGSEONG_ᆴ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㅌ))
    case JONGSEONG_ᆵ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㅍ))
    case JONGSEONG_ᆶ: return (unicodeToString(JONGSEONG_ᆯ), unicodeToString(CHOSEONG_ㅎ))
    case JONGSEONG_ᆷ: return (nil, unicodeToString(CHOSEONG_ㅁ))
    case JONGSEONG_ᆸ: return (nil, unicodeToString(CHOSEONG_ㅂ))
    case JONGSEONG_ᆹ: return (unicodeToString(JONGSEONG_ᆸ), unicodeToString(CHOSEONG_ㅅ))
    case JONGSEONG_ᆺ: return (nil, unicodeToString(CHOSEONG_ㅅ))
    case JONGSEONG_ᆻ: return (nil, unicodeToString(CHOSEONG_ㅆ))
    case JONGSEONG_ᆼ: return (nil, unicodeToString(CHOSEONG_ㅇ))
    case JONGSEONG_ᆽ: return (nil, unicodeToString(CHOSEONG_ㅈ))
    case JONGSEONG_ᆾ: return (nil, unicodeToString(CHOSEONG_ㅊ))
    case JONGSEONG_ᆿ: return (nil, unicodeToString(CHOSEONG_ㅋ))
    case JONGSEONG_ᇀ: return (nil, unicodeToString(CHOSEONG_ㅌ))
    case JONGSEONG_ᇁ: return (nil, unicodeToString(CHOSEONG_ㅍ))
    case JONGSEONG_ᇂ: return (nil, unicodeToString(CHOSEONG_ㅎ))
    default: return nil
    }
}

private func combineVowels(_ first: String, _ second: String) -> String? {
    let firstUnicode = first.unicodeScalars.first!.value
    let secondUnicode = second.unicodeScalars.first!.value
    switch (firstUnicode, secondUnicode) {
    case (JUNGSEONG_ㅏ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅐ)
    case (JUNGSEONG_ㅑ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅒ)
    case (JUNGSEONG_ㅓ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅔ)
    case (JUNGSEONG_ㅕ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅖ)
    case (JUNGSEONG_ㅗ, LETTER_ㅏ): return unicodeToString(JUNGSEONG_ㅘ)
    case (JUNGSEONG_ㅘ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅙ)
    case (JUNGSEONG_ㅗ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅚ)
    case (JUNGSEONG_ㅜ, LETTER_ㅓ): return unicodeToString(JUNGSEONG_ㅝ)
    case (JUNGSEONG_ㅝ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅞ)
    case (JUNGSEONG_ㅜ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅟ)
    case (JUNGSEONG_ㅡ, LETTER_ㅣ): return unicodeToString(JUNGSEONG_ㅢ)
    default: return nil
    }
}
