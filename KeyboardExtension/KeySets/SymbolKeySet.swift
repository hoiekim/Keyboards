//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

import UIKit

private let _0 = SymbolKey(first: "0", third: "`", backgroundColor: customGray3)
private let _1 = SymbolKey(first: "1", third: "∙", backgroundColor: customGray3)
private let _2 = SymbolKey(first: "2", third: "~", backgroundColor: customGray3)
private let _3 = SymbolKey(first: "3", third: "º", backgroundColor: customGray3)
private let _4 = SymbolKey(first: "4", third: "{", backgroundColor: customGray3)
private let _5 = SymbolKey(first: "5", third: "}", backgroundColor: customGray3)
private let _6 = SymbolKey(first: "6", third: "₩", backgroundColor: customGray3)
private let _7 = SymbolKey(first: "7", third: "[", backgroundColor: customGray3)
private let _8 = SymbolKey(first: "8", third: "]", backgroundColor: customGray3)
private let _9 = SymbolKey(first: "9", third: "♪", backgroundColor: customGray3)
private let question = SymbolKey(first: "?", third: "<")
private let exclamation = SymbolKey(first: "!", third: ">")
private let dash = SymbolKey(first: "-", third: "_")
private let equals = SymbolKey(first: "=", third: "+")
private let asterisk = SymbolKey(first: "*", third: "^")
private let at = SymbolKey(first: "@", third: "#")
private let dollar = SymbolKey(first: "$", third: "%")
private let and = SymbolKey(first: "&", third: "|")
private let paranthesisOpen = SymbolKey(first: "(", third: "/")
private let paranthesisClose = SymbolKey(first: ")", third: "\\")
private let period = SymbolKey(first: ".", third: ",")
private let colon = SymbolKey(first: ":", third: ";")
private let quote = SymbolKey(first: "'", third: "\"")

let symbolKeySet: [[Key]] = [
    [question, exclamation, dash, equals, asterisk, _7, _8, _9],
    [at, dollar, and, paranthesisOpen, paranthesisClose, _4, _5, _6],
    [shift, period, colon, quote, _0, _1, _2, _3],
    [changeToEnglish, changeToKorean, space, enter, backSpace]
]
