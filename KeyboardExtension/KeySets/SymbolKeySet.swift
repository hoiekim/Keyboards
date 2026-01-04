//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

import UIKit

private let _0 = SymbolKey(first: "0", third: "`", backgroundColor: customGray4)
private let _1 = SymbolKey(first: "1", third: "∙", backgroundColor: customGray4)
private let _2 = SymbolKey(first: "2", third: "&", backgroundColor: customGray4)
private let _3 = SymbolKey(first: "3", third: "|", backgroundColor: customGray4)
private let _4 = SymbolKey(first: "4", third: "(", backgroundColor: customGray4)
private let _5 = SymbolKey(first: "5", third: ")", backgroundColor: customGray4)
private let _6 = SymbolKey(first: "6", third: "{", backgroundColor: customGray4)
private let _7 = SymbolKey(first: "7", third: "[", backgroundColor: customGray4)
private let _8 = SymbolKey(first: "8", third: "]", backgroundColor: customGray4)
private let _9 = SymbolKey(first: "9", third: "<", backgroundColor: customGray4)

private let question = SymbolKey(first: "?", third: ">")
private let exclamation = SymbolKey(first: "!", third: "}")
private let at = SymbolKey(first: "@")

private let tilde = SymbolKey(first: "~", third: "º")
private let underDash = SymbolKey(first: "_")
private let minus = SymbolKey(first: "-")
private let plus = SymbolKey(first: "+", third: "%")

private let colon = SymbolKey(first: ":", third: ";")
private let dollar = SymbolKey(first: "$", third: "₩")
private let asterisk = SymbolKey(first: "*", third: "^")
private let slash = SymbolKey(first: "/", third: "\\")

private let quote = SymbolKey(first: "\"", third: "'")
private let comma = SymbolKey(first: ",")
private let equal = SymbolKey(first: "=", third: "#")

private let period = SymbolKey(first: ".")
private let periodComma = SymbolKey(first: ".", third: ",")

let shortSymbolsKeySet: [[Key]] = [
    [tilde, underDash, minus, plus, _7, _8, _9, question],
    [colon, dollar, asterisk, slash, _4, _5, _6, exclamation],
    [shift, quote, comma, equal, _1, _2, _3, at],
    [changeToEnglish, changeToKorean, mediumSpace, _0, period, backSpace]
]

let longSymbolsKeySet: [[Key]] = [
    [tilde, underDash, minus, plus, _7, _8, _9, at, changeToEnglish, changeToKorean],
    [dollar, asterisk, slash, equal, _4, _5, _6, question, exclamation, backSpace],
    [shift, quote, colon, _0, _1, _2, _3, periodComma, shortSpace]
]
