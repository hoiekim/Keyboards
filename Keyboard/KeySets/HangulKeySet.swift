//
//  HangulKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

private let ㅂ = HangulKey(firstUnicode: LETTER_ㅂ, secondUnicode: LETTER_ㅃ)
private let ㅈ = HangulKey(firstUnicode: LETTER_ㅈ, secondUnicode: LETTER_ㅉ)
private let ㄷ = HangulKey(firstUnicode: LETTER_ㄷ, secondUnicode: LETTER_ㄸ)
private let ㄱ = HangulKey(firstUnicode: LETTER_ㄱ, secondUnicode: LETTER_ㄲ)
private let ㅅ = HangulKey(firstUnicode: LETTER_ㅅ, secondUnicode: LETTER_ㅆ)
private let ㅗ = HangulKey(firstUnicode: LETTER_ㅗ, secondUnicode: LETTER_ㅛ)
private let ㅐ = HangulKey(firstUnicode: LETTER_ㅐ, secondUnicode: LETTER_ㅒ)
private let ㅔ = HangulKey(firstUnicode: LETTER_ㅔ, secondUnicode: LETTER_ㅖ)
private let ㅣ = HangulKey(firstUnicode: LETTER_ㅣ)
private let ㅁ = HangulKey(firstUnicode: LETTER_ㅁ)
private let ㄴ = HangulKey(firstUnicode: LETTER_ㄴ)
private let ㅇ = HangulKey(firstUnicode: LETTER_ㅇ)
private let ㄹ = HangulKey(firstUnicode: LETTER_ㄹ)
private let ㅎ = HangulKey(firstUnicode: LETTER_ㅎ)
private let ㅓ = HangulKey(firstUnicode: LETTER_ㅓ, secondUnicode: LETTER_ㅕ)
private let ㅏ = HangulKey(firstUnicode: LETTER_ㅏ, secondUnicode: LETTER_ㅑ)
private let ㅋ = HangulKey(firstUnicode: LETTER_ㅋ)
private let ㅌ = HangulKey(firstUnicode: LETTER_ㅌ)
private let ㅊ = HangulKey(firstUnicode: LETTER_ㅊ)
private let ㅍ = HangulKey(firstUnicode: LETTER_ㅍ)
private let ㅜ = HangulKey(firstUnicode: LETTER_ㅜ, secondUnicode: LETTER_ㅠ)
private let ㅡ = HangulKey(firstUnicode: LETTER_ㅡ)

let koreanKeySet: [[Key]] = [
    [ㅂ, ㅈ, ㄷ, ㄱ, ㅅ, ㅗ, ㅐ, ㅔ],
    [ㅁ, ㄴ, ㅇ, ㄹ, ㅎ, ㅓ, ㅏ, ㅣ],
    [blank, ㅋ, ㅌ, ㅊ, ㅍ, ㅜ, ㅡ, blank],
    [shift, changeKeySet, space, enter, backSpace]
]
