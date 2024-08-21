//
//  UtilKeys.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/6/24.
//

import UIKit

func trimSpacesBefore(_ document: UITextDocumentProxy) {
    while document.documentContextBeforeInput?.last == " " {
        document.deleteBackward()
    }
}

func deleteWord(_ document: UITextDocumentProxy) {
    guard let beforeText = document.documentContextBeforeInput else { return }
    if beforeText.last == "\n" { return document.deleteBackward() }
    trimSpacesBefore(document)
    guard let beforeText = document.documentContextBeforeInput else { return }
    if beforeText.last == "\n" { return }
    let lineStart = beforeText.split(separator: "\n").last?.count
    let wordStart = beforeText.split(separator: " ").last?.count
    let deleteCount = minOfCoalesced(lineStart, wordStart) ?? beforeText.count
    for _ in 0 ..< deleteCount {
        document.deleteBackward()
    }
    trimSpacesBefore(document)
}

let backSpace = UtilKey(
    id: "backSpace",
    defaultImage: "delete.backward",
    onTap: { document, context in
        if context.isCapsLocked || context.isShifted {
            deleteWord(document)
        } else {
            document.deleteBackward()
        }
    }
)

let shift = UtilKey(
    id: "shift",
    updateButtonImagesOnTap: true,
    defaultImage: "shift",
    imageOnShift: "shift.fill",
    imageOnCapsLock: "capslock.fill",
    onTap: { _, context in
        if context.isDoubleTapped {
            context.isCapsLocked = true
        } else {
            if context.isCapsLocked {
                context.isCapsLocked = false
                context.isShifted = false
            } else if context.isShifted {
                context.isShifted = false
            } else {
                context.isShifted = true
            }
        }
    }
)

let space = UtilKey(
    id: "space",
    span: 4,
    imageOnShift: "arrow.forward.to.line",
    onTap: { document, context in
        if context.isShifted && !context.isCapsLocked {
            document.insertText("\t")
        } else {
            document.insertText(" ")
        }
    }
)

let enter = UtilKey(
    id: "enter",
    defaultImage: "return",
    onTap: { document, _ in document.insertText("\n") }
)

var lastLanguage: [[Key]] = englishKeySet

let changeToSymbols = UtilKey(
    id: "changeToSymbol",
    remountOnTap: true,
    title: "$1",
    onTap: { _, context in
        context.keySet = symbolKeySet
    }
)

let changeToEnglish = UtilKey(
    id: "changeToEnglish",
    remountOnTap: true,
    defaultImage: "character",
    locale: "en-US",
    onTap: { _, context in
        context.keySet = englishKeySet
    }
)

let changeToKorean = UtilKey(
    id: "changeToKorean",
    remountOnTap: true,
    defaultImage: "character",
    locale: "ko-KR",
    onTap: { _, context in
        context.keySet = koreanKeySet
    }
)

let blank = UtilKey(
    id: "blank",
    backgroundColor: UIColor.clear,
    onTap: { _, _ in }
)
