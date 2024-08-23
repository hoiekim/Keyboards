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

func deleteWord(_ document: UITextDocumentProxy) -> String? {
    guard let beforeText = document.documentContextBeforeInput else { return nil }
    if beforeText.last == "\n" {
        document.deleteBackward()
        return "\n"
    }
    trimSpacesBefore(document)
    guard let beforeText = document.documentContextBeforeInput else { return nil }
    if beforeText.last == "\n" { return nil }
    let lineStart = beforeText.split(separator: "\n").last
    let lineStartCount = lineStart?.count
    let wordStart = beforeText.split(separator: " ").last
    let wordStartCount = wordStart?.count
    let deleteCount = minOfCoalesced(lineStartCount, wordStartCount) ?? beforeText.count
    for _ in 0 ..< deleteCount {
        document.deleteBackward()
    }
    trimSpacesBefore(document)
    switch (lineStartCount, wordStartCount, beforeText) {
    case (nil, nil, _): return beforeText
    case (nil, .some, _): return String(wordStart!)
    case (.some, nil, _): return String(lineStart!)
    case (.some, .some, _):
        if lineStartCount! <= wordStartCount! { return String(lineStart!) }
        else { return String(wordStart!) }
    }
}

private var backSpaceCache = ""

let backSpace = UtilKey(
    id: "backSpace",
    defaultImage: "delete.backward",
    onTap: { document, context in
        if context.isCapsLocked || context.isShifted {
            backSpaceCache = deleteWord(document) ?? ""
        } else {
            if let last = document.documentContextBeforeInput?.last {
                backSpaceCache = String(last)
                document.deleteBackward()
            }
        }
    },
    onCancelTap: { document, _ in
        document.insertText(backSpaceCache)
        backSpaceCache = ""
    }
)

var contextCache: KeyInputContext?

let shift = UtilKey(
    id: "shift",
    updateButtonImagesOnTap: true,
    defaultImage: "shift",
    imageOnShift: "shift.fill",
    imageOnCapsLock: "capslock.fill",
    onTap: { _, context in
        contextCache = KeyInputContext(context)
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
    },
    onCancelTap: { _, context in
        if contextCache != nil {
            context.copyFrom(contextCache!)
            contextCache = nil
        }
    }
)

private var isSpaceCanceled = true

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
        isSpaceCanceled = false
    },
    onCancelTap: { document, _ in
        if !isSpaceCanceled {
            document.deleteBackward()
            isSpaceCanceled = true
        }
    }
)

private var isEnterCanceled = true

let enter = UtilKey(
    id: "enter",
    defaultImage: "return",
    onTap: { document, _ in
        document.insertText("\n")
        isEnterCanceled = false
    },
    onCancelTap: { document, _ in
        if !isEnterCanceled {
            document.deleteBackward()
            isEnterCanceled = true
        }
    }
)

var lastLanguage: [[Key]] = englishKeySet

let changeToSymbols = UtilKey(
    id: "changeToSymbol",
    remountOnTap: true,
    title: "$1",
    onTap: { _, context in
        contextCache = KeyInputContext(context)
        context.keySet = symbolKeySet
    },
    onCancelTap: { _, context in
        if contextCache != nil {
            context.copyFrom(contextCache!)
            contextCache = nil
        }
    }
)

let changeToEnglish = UtilKey(
    id: "changeToEnglish",
    remountOnTap: true,
    defaultImage: "character",
    locale: "en-US",
    onTap: { _, context in
        contextCache = KeyInputContext(context)
        context.keySet = englishKeySet
    },
    onCancelTap: { _, context in
        if contextCache != nil {
            context.copyFrom(contextCache!)
            contextCache = nil
        }
    }
)

let changeToKorean = UtilKey(
    id: "changeToKorean",
    remountOnTap: true,
    defaultImage: "character",
    locale: "ko-KR",
    onTap: { _, context in
        contextCache = KeyInputContext(context)
        context.keySet = koreanKeySet
    },
    onCancelTap: { _, context in
        if contextCache != nil {
            context.copyFrom(contextCache!)
            contextCache = nil
        }
    }
)

let blank = UtilKey(
    id: "blank",
    backgroundColor: UIColor.clear,
    onTap: { _, _ in },
    onCancelTap: { _, _ in }
)
