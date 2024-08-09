//
//  SymbolKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/9/24.
//

private let _0 = SingleKey(title: "0")
private let _1 = SingleKey(title: "1")
private let _2 = SingleKey(title: "2")
private let _3 = SingleKey(title: "3")
private let _4 = SingleKey(title: "4")
private let _5 = SingleKey(title: "5")
private let _6 = SingleKey(title: "6")
private let _7 = SingleKey(title: "7")
private let _8 = SingleKey(title: "8")
private let _9 = SingleKey(title: "9")
private let period = DoubleKey(title:". ,", first: ".", second: ",")
private let question = DoubleKey(title:"? /", first: "?", second: "/")
private let exclamation = DoubleKey(title:"! ~", first: "!", second: "~")
private let at = DoubleKey(title:"@ #", first: "@", second: "#")
private let dollar = DoubleKey(title:"$ %", first: "$", second: "%")
private let colon = DoubleKey(title:": ;", first: ":", second: ";")
private let paranthesis = DoubleKey(title:"( )", first: "(", second: ")")
private let and = DoubleKey(title:"& |", first: "&", second: "|")
let dash = DoubleKey(title:"- _", first: "-", second: "_")
private let equals = DoubleKey(title:"= +", first: "=", second: "+")
private let asterisk = DoubleKey(title:"* ^", first: "*", second: "^")

let symbolKeySet: [[Key]] = [
    [dash, equals, asterisk, at, _7, _8, _9],
    [dollar, colon, paranthesis, and, _4, _5, _6],
    [period, question, exclamation, _0, _1, _2, _3],
    [shift, changeKeySet, space, enter, backSpace]
]
