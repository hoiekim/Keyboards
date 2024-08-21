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

let symbols = UtilKey(
    id: "symbols",
    remountOnTap: true,
    defaultImage: "dollarsign",
    onTap: { _, context in
        if isKeySetsEqual(context.keySet, symbolKeySet) {
            context.keySet = lastLanguage
        } else {
            lastLanguage = context.keySet
            context.keySet = symbolKeySet
        }
    }
)

let changeLanguage = UtilKey(
    id: "changeLanguage",
    remountOnTap: true,
    defaultImage: "globe",
    onTap: { _, context in
        if isKeySetsEqual(context.keySet, symbolKeySet) {
            context.keySet = lastLanguage
        } else if isKeySetsEqual(context.keySet, englishKeySet) {
            context.keySet = koreanKeySet
        } else {
            context.keySet = englishKeySet
        }
    }
)

let blank = UtilKey(
    id: "blank",
    backgroundColor: UIColor.clear,
    onTap: { _, _ in }
)
