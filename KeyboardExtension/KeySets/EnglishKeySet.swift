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
private let WWH = EnglishKey(first: "W", second: "WH", backgroundColor: customGray3)
private let O = EnglishKey(first: "O", backgroundColor: customGray3)
private let A = EnglishKey(first: "A", backgroundColor: customGray3)
private let Y = EnglishKey(first: "Y", backgroundColor: customGray3)
private let I = EnglishKey(first: "I", backgroundColor: customGray3)
private let E = EnglishKey(first: "E", backgroundColor: customGray3)
private let U = EnglishKey(first: "U", backgroundColor: customGray3)

let longEnglishSpace = UtilKey(
    id: "englishSpace",
    span: 4,
    onTap: onTapEnglishSpace
)

let shortEnglishSpace = UtilKey(
    id: "englishSpace",
    span: 2,
    onTap: onTapEnglishSpace
)

let onTapEnglishSpace: OnTapUtilKey = { document, context in
    if context.isDoubleTapped() {
        document.deleteBackward()
        document.insertText(". ")
    } else {
        let beforeText = document.documentContextBeforeInput
        if let lastWord = beforeText?.split(separator: " ").last {
            let replacement: String? = switch lastWord {
            case "Dont": "Don't"
            case "dont": "don't"
            case "Didnt": "Didn't"
            case "didnt": "didn't"
            case "Cant": "Can't"
            case "cant": "can't"
            case "Couldnt": "Couldn't"
            case "couldnt": "couldn't"
            case "Couldve": "Could've"
            case "couldve": "could've"
            case "Shouldnt": "Shouldn't"
            case "shouldnt": "shouldn't"
            case "Shouldve": "Should've"
            case "shouldve": "should've"
            case "Wont": "Won't"
            case "wont": "won't"
            case "Wouldnt": "Wouldn't"
            case "wouldnt": "wouldn't"
            case "Wouldve": "Would've"
            case "wouldve": "would've"
            case "Mustnt": "Mustn't"
            case "mustnt": "mustn't"
            case "Mustve": "Must've"
            case "mustve": "must've"
            case "Havent": "Haven't"
            case "havent": "haven't"
            case "Hasnt": "Hasn't"
            case "hasnt": "hasn't"
            case "Hadnt": "Hadn't"
            case "hadnt": "hadn't"
            case "Isnt": "Isn't"
            case "isnt": "isn't"
            case "Wasnt": "Wasn't"
            case "wasnt": "wasn't"
            case "Arent": "Aren't"
            case "arent": "aren't"
            case "Werent": "Weren't"
            case "werent": "weren't"
            case "Aint": "Ain't"
            case "aint": "ain't"
            case "Im": "I'm"
            case "Ive": "I've"
            case "Ill": "I'll"
            case "Id": "I'd"
            case "Youre": "You're"
            case "youre": "you're"
            case "Youve": "You've"
            case "youve": "you've"
            case "Youll": "You'll"
            case "youll": "you'll"
            case "Youd": "You'd"
            case "youd": "you'd"
            case "Theyre": "They're"
            case "theyre": "they're"
            case "Theyve": "They've"
            case "theyve": "they've"
            case "Theyll": "They'll"
            case "theyll": "they'll"
            case "Shes": "She's"
            case "shes": "she's"
            case "Hes": "He's"
            case "hes": "he's"
            case "Its": "It's"
            case "its": "it's"
            case "Itll": "It'll"
            case "itll": "it'll"
            case "Itd": "It'd"
            case "itd": "it'd"
            case "Thats": "That's"
            case "thats": "that's"
            case "Thatll": "That'll"
            case "thatll": "that'll"
            case "Thatd": "That'd"
            case "thatd": "that'd"
            case "Theres": "There's"
            case "theres": "there's"
            case "Heres": "Here's"
            case "heres": "here's"
            case "Lets": "Let's"
            default: nil
            }
            
            if replacement != nil {
                for _ in 0 ..< lastWord.count {
                    document.deleteBackward()
                }
                document.insertText(replacement!)
            }
        }
        document.insertText(" ")
    }
}

let shortEnglishKeySet: [[Key]] = [
    [KQ, D, T, R, L, U, I, O],
    [F, P, H, S, G, J, A, E],
    [shift, ZX, C, BV, N, M, WWH, Y],
    [changeToSymbols, changeToKorean, longEnglishSpace, enter, backSpace]
]

let longEnglishKeySet: [[Key]] = [
    [KQ, D, T, R, L, U, I, O, changeToSymbols, changeToKorean],
    [F, P, H, S, G, J, A, E, enter, backSpace],
    [shift, ZX, C, BV, N, M, WWH, Y, shortEnglishSpace]
]
