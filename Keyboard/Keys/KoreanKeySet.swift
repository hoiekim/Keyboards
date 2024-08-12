//
//  KoreanKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

private let ㅂ = KoreanKey(first: "ㅂ", second: "ㅃ")
private let ㅈ = KoreanKey(first: "ㅈ", second: "ㅉ")
private let ㄷ = KoreanKey(first: "ㄷ", second: "ㄸ")
private let ㄱ = KoreanKey(first: "ㄱ", second: "ㄲ")
private let ㅅ = KoreanKey(first: "ㅅ", second: "ㅆ")
private let ㅗ = KoreanKey(first: "ㅗ", second: "ㅛ")
private let ㅐ = KoreanKey(first: "ㅐ", second: "ㅒ")
private let ㅔ = KoreanKey(first: "ㅔ", second: "ㅖ")
private let ㅣ = KoreanKey(first: "ㅣ")
private let ㅁ = KoreanKey(first: "ㅁ")
private let ㄴ = KoreanKey(first: "ㄴ")
private let ㅇ = KoreanKey(first: "ㅇ")
private let ㄹ = KoreanKey(first: "ㄹ")
private let ㅎ = KoreanKey(first: "ㅎ")
private let ㅓ = KoreanKey(first: "ㅓ", second: "ㅕ")
private let ㅏ = KoreanKey(first: "ㅏ", second: "ㅑ")
private let ㅋ = KoreanKey(first: "ㅋ")
private let ㅌ = KoreanKey(first: "ㅌ")
private let ㅊ = KoreanKey(first: "ㅊ")
private let ㅍ = KoreanKey(first: "ㅍ")
private let ㅜ = KoreanKey(first: "ㅜ", second: "ㅠ")
private let ㅡ = KoreanKey(first: "ㅡ")

let koreanKeySet: [[Key]] = [
    [ㅂ, ㅈ, ㄷ, ㄱ, ㅅ, ㅗ, ㅐ, ㅔ],
    [ㅁ, ㄴ, ㅇ, ㄹ, ㅎ, ㅓ, ㅏ, ㅣ],
    [blank, ㅋ, ㅌ, ㅊ, ㅍ, ㅜ, ㅡ, blank],
    [shift, changeKeySet, space, enter, backSpace]
]
