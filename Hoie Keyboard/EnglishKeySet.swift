//
//  EnglishKeySet.swift
//  Hoie Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

private let DT = DoubleKey(title: "DT", first: "D", second: "T")
private let KQ = DoubleKey(title: "KQ", first: "K", second: "Q")
private let G = SingleKey(title: "G")
private let J = SingleKey(title: "J")
private let H = SingleKey(title: "H")
private let Y = SingleKey(title: "Y")
private let I = SingleKey(title: "I")
private let BV = DoubleKey(title: "BV", first: "B", second: "V")
private let SZ = DoubleKey(title: "SZ", first: "S", second: "Z")
private let R = SingleKey(title: "R")
private let C = SingleKey(title: "C")
private let W = SingleKey(title: "W")
private let O = SingleKey(title: "O")
private let A = SingleKey(title: "A")
private let PF = DoubleKey(title: "PF", first: "P", second: "F")
private let N = SingleKey(title: "N")
private let M = SingleKey(title: "M")
private let L = SingleKey(title: "L")
private let X = SingleKey(title: "X")
private let E = SingleKey(title: "E")
private let U = SingleKey(title: "U")

let englishKeySet: [[Key]] = [
    [DT, KQ, G, J, H, Y, I],
    [BV, SZ, R, C, W, O, A],
    [PF, N, M, L, X, E, U]
]
