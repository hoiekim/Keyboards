//
//  EnglishKeySet.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit

private let KQ = EnglishKey(first: "K", second: "Q")
private let BV = EnglishKey(first: "B", second: "V")
private let ZX = EnglishKey(first: "Z", second: "X")
private let D = EnglishKey(first: "D")
private let T = EnglishKey(first: "T")
private let G = EnglishKey(first: "G")
private let J = EnglishKey(first: "J")
private let H = EnglishKey(first: "H")
private let S = EnglishKey(first: "S")
private let R = EnglishKey(first: "R")
private let C = EnglishKey(first: "C")
private let P = EnglishKey(first: "P")
private let F = EnglishKey(first: "F")
private let N = EnglishKey(first: "N")
private let M = EnglishKey(first: "M")
private let L = EnglishKey(first: "L")
private let X = EnglishKey(first: "X")
private let W = EnglishKey(first: "W", backgroundColor: customGray3)
private let O = EnglishKey(first: "O", backgroundColor: customGray3)
private let A = EnglishKey(first: "A", backgroundColor: customGray3)
private let Y = EnglishKey(first: "Y", backgroundColor: customGray3)
private let I = EnglishKey(first: "I", backgroundColor: customGray3)
private let E = EnglishKey(first: "E", backgroundColor: customGray3)
private let U = EnglishKey(first: "U", backgroundColor: customGray3)

let englishKeySet: [[Key]] = [
    [KQ, D, T, G, H, J, O, A],
    [BV, F, P, R, C, Y, I, E],
    [ZX, S, N, M, L, W, U, changeLanguage],
    [shift, symbols, space, enter, backSpace]
]
