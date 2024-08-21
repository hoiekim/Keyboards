//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

import UIKit

private let _0 = SymbolKey(first: "0", backgroundColor: customGray3)
private let _1 = SymbolKey(first: "1", backgroundColor: customGray3)
private let _2 = SymbolKey(first: "2", backgroundColor: customGray3)
private let _3 = SymbolKey(first: "3", backgroundColor: customGray3)
private let _4 = SymbolKey(first: "4", backgroundColor: customGray3)
private let _5 = SymbolKey(first: "5", backgroundColor: customGray3)
private let _6 = SymbolKey(first: "6", backgroundColor: customGray3)
private let _7 = SymbolKey(first: "7", backgroundColor: customGray3)
private let _8 = SymbolKey(first: "8", backgroundColor: customGray3)
private let _9 = SymbolKey(first: "9", backgroundColor: customGray3)
private let period = SymbolKey(first: ".", second: ",", third: "∙")
private let slash = SymbolKey(first: "/", second: "\\")
private let question = SymbolKey(first: "?", second: "!")
private let at = SymbolKey(first: "@", second: "#")
private let dollar = SymbolKey(first: "$", second: "%")
private let colon = SymbolKey(first: ":", second: ";")
private let comparison = SymbolKey(first: "<", second: ">", third: "[")
private let paranthesis = SymbolKey(first: "(", second: ")", third: "]")
private let and = SymbolKey(first: "&", second: "|")
private let dash = SymbolKey(first: "-", second: "_", third: "~")
private let equals = SymbolKey(first: "=", second: "+")
private let asterisk = SymbolKey(first: "*", second: "^")
private let quote = SymbolKey(first: "'", second: "\"", third: "`")

let language = UtilKey(
    id: "symbols",
    span: 2,
    remountOnTap: true,
    defaultImage: "character",
    onTap: { _, context in
        if isKeySetsEqual(context.keySet, symbolKeySet) {
            context.keySet = lastLanguage
        } else {
            lastLanguage = context.keySet
            context.keySet = symbolKeySet
        }
    }
)

let symbolKeySet: [[Key]] = [
    [question, dash, equals, asterisk, and, _7, _8, _9],
    [at, dollar, quote, comparison, paranthesis, _4, _5, _6],
    [shift, period, colon, slash, _0, _1, _2, _3],
    [language, space, enter, backSpace]
]
