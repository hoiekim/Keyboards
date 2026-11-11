//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

import UIKit

// MARK: - Symbols layout
//
// Opened by tapping the symbols key. Every commonly used symbol is available
// without shift. Rarely used symbols live on the shifted layer (third).

private let hash = SymbolKey(first: "#", third: "~")
private let underDash = SymbolKey(first: "_", third: "∙")
private let minus = SymbolKey(first: "-", third: "º")
private let plus = SymbolKey(first: "+", third: "€")
private let leftParen = SymbolKey(first: "(", third: "[")
private let rightParen = SymbolKey(first: ")", third: "]")
private let apostrophe = SymbolKey(first: "'", third: "`")
private let question = SymbolKey(first: "?")

private let colon = SymbolKey(first: ":")
private let dollar = SymbolKey(first: "$", third: "₩")
private let asterisk = SymbolKey(first: "*", third: "^")
private let slash = SymbolKey(first: "/", third: "\\")
private let lessThan = SymbolKey(first: "<", third: "{")
private let greaterThan = SymbolKey(first: ">", third: "}")
private let percent = SymbolKey(first: "%")
private let exclamation = SymbolKey(first: "!")

private let quote = SymbolKey(first: "\"")
private let comma = SymbolKey(first: ",")
private let equal = SymbolKey(first: "=")
private let ampersand = SymbolKey(first: "&", third: "|")
private let semicolon = SymbolKey(first: ";")
private let period = SymbolKey(first: ".", third: "…")
private let at = SymbolKey(first: "@")

let shortSymbolsKeySet: [[Key]] = [
    [hash, underDash, minus, plus, leftParen, rightParen, apostrophe, question],
    [colon, dollar, asterisk, slash, lessThan, greaterThan, percent, exclamation],
    [shift, quote, comma, equal, ampersand, semicolon, period, at],
    [changeToEnglish, changeToKorean, mediumSpace, changeToNumbers, enter, backSpace]
]

let longSymbolsKeySet: [[Key]] = [
    [hash, underDash, minus, plus, leftParen, rightParen, apostrophe, question, changeToEnglish, changeToKorean],
    [colon, dollar, asterisk, slash, lessThan, greaterThan, percent, exclamation, changeToNumbers, backSpace],
    [shift, quote, comma, equal, ampersand, semicolon, period, at, shortSpace]
]

// MARK: - Numbers layout
//
// Opened by dragging right from the symbols key (or tapping "123" in the
// symbols layout). Numbers sit on the left side in phone keypad order and
// the symbols most often typed together with numbers sit on the right.

private let _0 = SymbolKey(first: "0", backgroundColor: customGray4)
private let _1 = SymbolKey(first: "1", backgroundColor: customGray4)
private let _2 = SymbolKey(first: "2", backgroundColor: customGray4)
private let _3 = SymbolKey(first: "3", backgroundColor: customGray4)
private let _4 = SymbolKey(first: "4", backgroundColor: customGray4)
private let _5 = SymbolKey(first: "5", backgroundColor: customGray4)
private let _6 = SymbolKey(first: "6", backgroundColor: customGray4)
private let _7 = SymbolKey(first: "7", backgroundColor: customGray4)
private let _8 = SymbolKey(first: "8", backgroundColor: customGray4)
private let _9 = SymbolKey(first: "9", backgroundColor: customGray4)

private let numPlus = SymbolKey(first: "+")
private let numMinus = SymbolKey(first: "-")
private let numLeftParen = SymbolKey(first: "(")
private let numRightParen = SymbolKey(first: ")")
private let numAsterisk = SymbolKey(first: "*")
private let numSlash = SymbolKey(first: "/")
private let numEqual = SymbolKey(first: "=")
private let numPercent = SymbolKey(first: "%")
private let numColon = SymbolKey(first: ":")
private let numDollar = SymbolKey(first: "$")
private let numHash = SymbolKey(first: "#")
private let numComma = SymbolKey(first: ",")
private let numPeriod = SymbolKey(first: ".")

let shortNumbersKeySet: [[Key]] = [
    [_1, _2, _3, numPlus, numMinus, numLeftParen, numRightParen, question],
    [_4, _5, _6, numAsterisk, numSlash, numEqual, numPercent, exclamation],
    [_7, _8, _9, numColon, numDollar, numHash, numComma, at],
    [changeToLastLetters, _0, numPeriod, mediumSpace, changeToSymbolsFromNumbers, backSpace]
]

let longNumbersKeySet: [[Key]] = [
    [_1, _2, _3, numPlus, numMinus, numLeftParen, numRightParen, question, changeToEnglish, changeToKorean],
    [_4, _5, _6, numAsterisk, numSlash, numEqual, numPercent, exclamation, changeToSymbolsFromNumbers, backSpace],
    [_7, _8, _9, _0, numPeriod, numComma, numColon, numDollar, shortSpace]
]
