//
//  KoreanKeySet.swift
//  Hoie Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

private let ㅂ = DoubleKey(title: "ㅂ", first: "ㅂ", second: "ㅃ")
private let ㅈ = DoubleKey(title: "ㅈ", first: "ㅈ", second: "ㅉ")
private let ㄷ = DoubleKey(title: "ㄷ", first: "ㄷ", second: "ㄸ")
private let ㄱ = DoubleKey(title: "ㄱ", first: "ㄱ", second: "ㄲ")
private let ㅅ = DoubleKey(title: "ㅅ", first: "ㅅ", second: "ㅆ")
private let ㅗ = DoubleKey(title: "ㅗ", first: "ㅗ", second: "ㅛ")
private let ㅐ = DoubleKey(title: "ㅐ", first: "ㅐ", second: "ㅒ")
private let ㅔ = DoubleKey(title: "ㅔ", first: "ㅔ", second: "ㅖ")
private let ㅣ = SingleKey(title: "ㅣ")
private let ㅁ = SingleKey(title: "ㅁ")
private let ㄴ = SingleKey(title: "ㄴ")
private let ㅇ = SingleKey(title: "R")
private let ㄹ = SingleKey(title: "C")
private let ㅎ = SingleKey(title: "W")
private let ㅓ = DoubleKey(title: "ㅓ", first: "ㅓ", second: "ㅕ")
private let ㅏ = DoubleKey(title: "ㅏ", first: "ㅏ", second: "ㅑ")
private let ㅋ = SingleKey(title: "ㅋ")
private let ㅌ = SingleKey(title: "ㅌ")
private let ㅊ = SingleKey(title: "ㅊ")
private let ㅍ = SingleKey(title: "ㅍ")
private let ㅜ = DoubleKey(title: "ㅜ", first: "ㅜ", second: "ㅠ")
private let ㅡ = SingleKey(title: "ㅡ")

let koreanKeySet: [[Key]] = [
    [ㅂ, ㅈ, ㄷ, ㄱ, ㅅ, ㅗ, ㅐ, ㅔ],
    [ㅁ, ㄴ, ㅇ, ㄹ, ㅎ, ㅓ, ㅏ, ㅣ],
    [ㅋ, ㅌ, ㅊ, ㅍ, ㅜ, ㅡ]
]
