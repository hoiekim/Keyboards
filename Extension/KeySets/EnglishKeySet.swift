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
private let TTH = EnglishKey(first: "T", second: "TH")
private let G = EnglishKey(first: "G")
private let J = EnglishKey(first: "J")
private let H = EnglishKey(first: "H")
private let SSH = EnglishKey(first: "S", second: "SH")
private let R = EnglishKey(first: "R")
private let CCH = EnglishKey(first: "C", second: "CH")
private let PPH = EnglishKey(first: "P", second: "PH")
private let F = EnglishKey(first: "F")
private let NNG = EnglishKey(first: "N", second: "NG")
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
    [KQ, TTH, D, G, H, J, Y, I],
    [BV, PPH, F, R, L, O, A, E],
    [ZX, SSH, CCH, NNG, M, W, U, changeLanguage],
    [shift, symbols, space, enter, backSpace]
]
