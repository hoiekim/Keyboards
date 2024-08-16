//
//  UtilKey.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/12/24.
//

import UIKit

class UtilKey: Key {
    typealias OnTapUtilKey = (UITextDocumentProxy, KeyInputContext) -> Void

    let id: String
    let span: Int
    var _defaultImage: String?
    var _imageOnShift: String?
    var _imageOnCapsLock: String?
    var _backgroundColor: UIColor?
    private let _onTap: OnTapUtilKey

    init(
        id: String,
        span: Int = 1,
        defaultImage: String? = nil,
        imageOnShift: String? = nil,
        imageOnCapsLock: String? = nil,
        backgroundColor: UIColor? = nil,
        onTap: @escaping OnTapUtilKey
    ) {
        self.id = "UtilKey_" + id
        self.span = span
        self._defaultImage = defaultImage
        self._imageOnShift = imageOnShift
        self._imageOnCapsLock = imageOnCapsLock
        self._backgroundColor = backgroundColor
        self._onTap = onTap
    }

    func getTitle(_ context: KeyInputContext) -> String? {
        return nil
    }

    func getImage(_ context: KeyInputContext) -> String? {
        if context.isCapsLocked {
            return self._imageOnCapsLock ?? self._defaultImage
        } else if context.isShifted {
            return self._imageOnShift ?? self._defaultImage
        } else {
            return self._defaultImage
        }
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return self._backgroundColor ?? customGray1
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        self._onTap(document, context)
    }
}
