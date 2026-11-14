//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

import UIKit

// MARK: - Symbols layout
//
// Opened by tapping the symbols key. Every symbol is available without
// shift; the layout has no shift key.

private let hash = SymbolKey(first: "#")
private let ampersand = SymbolKey(first: "&")
private let plus = SymbolKey(first: "+")
private let minus = SymbolKey(first: "-")
private let slash = SymbolKey(first: "/")
private let asterisk = SymbolKey(first: "*")
private let dollar = SymbolKey(first: "$")
private let question = SymbolKey(first: "?")

private let leftParen = SymbolKey(first: "(")
private let rightParen = SymbolKey(first: ")")
private let lessThan = SymbolKey(first: "<")
private let greaterThan = SymbolKey(first: ">")
private let backtick = SymbolKey(first: "`")
private let apostrophe = SymbolKey(first: "'")
private let quote = SymbolKey(first: "\"")
private let exclamation = SymbolKey(first: "!")

private let colon = SymbolKey(first: ":")
private let semicolon = SymbolKey(first: ";")
private let percent = SymbolKey(first: "%")
private let equal = SymbolKey(first: "=")
private let underDash = SymbolKey(first: "_")
private let comma = SymbolKey(first: ",")
private let period = SymbolKey(first: ".")
private let at = SymbolKey(first: "@")

let shortSymbolsKeySet: [[Key]] = [
    [hash, ampersand, plus, minus, slash, asterisk, dollar, question],
    [leftParen, rightParen, lessThan, greaterThan, backtick, apostrophe, quote, exclamation],
    [colon, semicolon, percent, equal, underDash, comma, period, at],
    [changeToNumbers, changeToLastLetters, longSpace, enter, backSpace]
]

let longSymbolsKeySet: [[Key]] = [
    [hash, ampersand, plus, minus, slash, asterisk, dollar, question, changeToNumbers, changeToLastLetters],
    [leftParen, rightParen, lessThan, greaterThan, backtick, apostrophe, quote, exclamation, enter, backSpace],
    [colon, semicolon, percent, equal, underDash, comma, period, at, shortSpace]
]

// MARK: - Numbers layout
//
// Opened by swiping up from the symbols key (or tapping "123" in the
// symbols layout). Number keys are double width, in phone keypad order.

private let _0 = SymbolKey(first: "0", span: 2, backgroundColor: customGray4)
private let _1 = SymbolKey(first: "1", span: 2, backgroundColor: customGray4)
private let _2 = SymbolKey(first: "2", span: 2, backgroundColor: customGray4)
private let _3 = SymbolKey(first: "3", span: 2, backgroundColor: customGray4)
private let _4 = SymbolKey(first: "4", span: 2, backgroundColor: customGray4)
private let _5 = SymbolKey(first: "5", span: 2, backgroundColor: customGray4)
private let _6 = SymbolKey(first: "6", span: 2, backgroundColor: customGray4)
private let _7 = SymbolKey(first: "7", span: 2, backgroundColor: customGray4)
private let _8 = SymbolKey(first: "8", span: 2, backgroundColor: customGray4)
private let _9 = SymbolKey(first: "9", span: 2, backgroundColor: customGray4)

private let pipe = SymbolKey(first: "|")
private let tilde = SymbolKey(first: "~")

let shortNumbersKeySet: [[Key]] = [
    [dollar, _1, _2, _3, question],
    [pipe, _4, _5, _6, exclamation],
    [tilde, _7, _8, _9, at],
    [changeToSymbolsFromNumbers, changeToLastLetters, tinySpace, _0, period, enter, backSpace]
]

// The number pad needs four rows, so landscape uses the same layout.
let longNumbersKeySet: [[Key]] = shortNumbersKeySet
