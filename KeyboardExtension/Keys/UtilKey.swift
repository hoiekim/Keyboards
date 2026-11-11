//
//  UtilKey.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/12/24.
//

import UIKit

class UtilKey: Key {
    static let className = "UtilKey"
    let className = "UtilKey"

    let id: String
    let span: Int
    let remountOnTap: Bool
    let updateButtonImagesOnTap: Bool
    private let _onTap: OnTapUtilKey
    private let _getTitle: ((KeyInputContext) -> String?)?
    var title: String?
    var _defaultImage: String?
    var _imageOnShift: String?
    var _imageOnCapsLock: String?
    var _backgroundColor: UIColor?

    init(
        id: String,
        span: Int = 1,
        remountOnTap: Bool = false,
        updateButtonImagesOnTap: Bool = false,
        title: String? = nil,
        defaultImage: String? = nil,
        imageOnShift: String? = nil,
        imageOnCapsLock: String? = nil,
        backgroundColor: UIColor? = nil,
        getTitle: ((KeyInputContext) -> String?)? = nil,
        onTap: @escaping OnTapUtilKey
    ) {
        self.id = id.hasPrefix("UtilKey_") ? id : "UtilKey_" + id
        self.span = span
        self.remountOnTap = remountOnTap
        self.updateButtonImagesOnTap = updateButtonImagesOnTap
        self.title = title
        self._defaultImage = defaultImage
        self._imageOnShift = imageOnShift
        self._imageOnCapsLock = imageOnCapsLock
        self._backgroundColor = backgroundColor
        self._getTitle = getTitle
        self._onTap = onTap
    }

    /// Returns a copy of this key with a different span. The copy keeps the
    /// same id so that it behaves exactly like the original key (e.g. space
    /// keys split into two halves in the split layout).
    func withSpan(_ span: Int) -> UtilKey {
        return UtilKey(
            id: id,
            span: span,
            remountOnTap: remountOnTap,
            updateButtonImagesOnTap: updateButtonImagesOnTap,
            title: title,
            defaultImage: _defaultImage,
            imageOnShift: _imageOnShift,
            imageOnCapsLock: _imageOnCapsLock,
            backgroundColor: _backgroundColor,
            getTitle: _getTitle,
            onTap: _onTap
        )
    }

    func getTitle(_ context: KeyInputContext) -> String? {
        if let getTitle = _getTitle { return getTitle(context) }
        return title
    }
    
    func getTitleSuperscript(_ context: KeyInputContext) -> String? { return nil }

    func getImage(_ context: KeyInputContext) -> UIImage? {
        let imageName = if context.isCapsLocked {
            self._imageOnCapsLock ?? self._defaultImage
        } else if context.isShifted {
            self._imageOnShift ?? self._defaultImage
        } else {
            self._defaultImage
        }
        
        guard let imageName = imageName else { return nil }
        
        return UIImage(systemName: imageName)
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return self._backgroundColor ?? customGray1
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        self._onTap(document, context)
    }
}

typealias OnTapUtilKey = (UITextDocumentProxy, KeyInputContext) -> Void
