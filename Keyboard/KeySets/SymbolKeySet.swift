//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

private let _0 = SymbolKey(first: "0")
private let _1 = SymbolKey(first: "1")
private let _2 = SymbolKey(first: "2")
private let _3 = SymbolKey(first: "3")
private let _4 = SymbolKey(first: "4")
private let _5 = SymbolKey(first: "5")
private let _6 = SymbolKey(first: "6")
private let _7 = SymbolKey(first: "7")
private let _8 = SymbolKey(first: "8")
private let _9 = SymbolKey(first: "9")
private let period = SymbolKey(first: ".", second: ",", third: "∙")
private let question = SymbolKey(first: "/", second: "\\")
private let exclamation = SymbolKey(first: "?", second: "!")
private let at = SymbolKey(first: "@", second: "#")
private let dollar = SymbolKey(first: "$", second: "%")
private let colon = SymbolKey(first: ":", second: ";")
private let comparison = SymbolKey(first: "<", second: ">")
private let paranthesis = SymbolKey(first: "(", second: ")")
private let bracket = SymbolKey(first: "[", second: "]")
private let and = SymbolKey(first: "&", second: "|")
let dash = SymbolKey(first: "-", second: "_", third: "~")
private let equals = SymbolKey(first: "=", second: "+")
private let asterisk = SymbolKey(first: "*", second: "^")
private let quote = SymbolKey(first: "'", second: "\"", third: "`")

let symbolKeySet: [[Key]] = [
    [dash, equals, asterisk, dollar, at, _7, _8, _9],
    [quote, comparison, bracket, paranthesis, and, _4, _5, _6],
    [period, colon, question, exclamation, _0, _1, _2, _3],
    [shift, symbols, space, enter, backSpace]
]
