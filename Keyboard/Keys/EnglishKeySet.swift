//
//  EnglishKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

let KQ = DoubleKey(title: "K Q", first: "K", second: "Q")
private let D = SingleKey(title: "D")
private let T = SingleKey(title: "T")
private let G = SingleKey(title: "G")
private let J = SingleKey(title: "J")
private let H = SingleKey(title: "H")
private let Y = SingleKey(title: "Y")
private let I = SingleKey(title: "I")
private let BV = DoubleKey(title: "B V", first: "B", second: "V")
private let S = SingleKey(title: "S")
private let Z = SingleKey(title: "Z")
private let R = SingleKey(title: "R")
private let C = SingleKey(title: "C")
private let W = SingleKey(title: "W")
private let O = SingleKey(title: "O")
private let A = SingleKey(title: "A")
private let P = SingleKey(title: "P")
private let F = SingleKey(title: "F")
private let N = SingleKey(title: "N")
private let M = SingleKey(title: "M")
private let L = SingleKey(title: "L")
private let X = SingleKey(title: "X")
private let E = SingleKey(title: "E")
private let U = SingleKey(title: "U")

let englishKeySet: [[Key]] = [
    [KQ, D, T, G, J, H, Y, I],
    [BV, S, Z, R, C, W, O, A],
    [P, F, N, M, L, X, E, U],
    [shift, changeKeySet, space, enter, backSpace]
]
