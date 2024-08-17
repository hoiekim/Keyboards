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

func deleteLine(_ document: UITextDocumentProxy) {
    let beforeText = document.documentContextBeforeInput
    let lastLetter = beforeText?.last
    if lastLetter == "\n" { return document.deleteBackward() }
    guard let lastLine = beforeText?.split(separator: "\n").last else { return }
    for _ in 0 ..< lastLine.count {
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
        if context.isCapsLocked {
            deleteLine(document)
        } else if context.isShifted {
            deleteWord(document)
        } else {
            document.deleteBackward()
        }
    }
)

let shift = UtilKey(
    id: "shift",
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
    span: 3,
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
    span: 2,
    defaultImage: "return",
    onTap: { document, _ in document.insertText("\n") }
)

var lastLanguage: [[Key]] = englishKeySet

let symbols = UtilKey(
    id: "symbols",
    defaultImage: "dollarsign",
    onTap: { _, context in
        if isKeySetsEqual(context.keySet, symbolKeySet) {
            context.keySet = lastLanguage
            symbols._defaultImage = "dollarsign"
        } else {
            context.keySet = symbolKeySet
            symbols._defaultImage = "character"
        }
    }
)

let changeLanguage = UtilKey(
    id: "changeLanguage",
    defaultImage: "globe",
    onTap: { _, context in
        if isKeySetsEqual(context.keySet, englishKeySet) {
            lastLanguage = koreanKeySet
        } else {
            lastLanguage = englishKeySet
        }
        context.keySet = lastLanguage
    }
)

let blank = UtilKey(
    id: "blank",
    backgroundColor: UIColor.clear,
    onTap: { _, _ in }
)
