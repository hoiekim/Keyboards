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
    let remountOnTap: Bool
    let updateButtonImagesOnTap: Bool
    private let _onTap: OnTapUtilKey
    var title: String?
    var _defaultImage: String?
    var _imageOnShift: String?
    var _imageOnCapsLock: String?
    var _backgroundColor: UIColor?
    var locale: String?

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
        locale: String? = nil,
        onTap: @escaping OnTapUtilKey
    ) {
        self.id = "UtilKey_" + id
        self.span = span
        self.remountOnTap = remountOnTap
        self.updateButtonImagesOnTap = updateButtonImagesOnTap
        self.locale = locale
        self.title = title
        self._defaultImage = defaultImage
        self._imageOnShift = imageOnShift
        self._imageOnCapsLock = imageOnCapsLock
        self._backgroundColor = backgroundColor
        self._onTap = onTap
    }

    func getTitle(_ context: KeyInputContext) -> String? {
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
        
        let locale = Locale(identifier: locale ?? "en-US")
        let imageConfig = UIImage.SymbolConfiguration(locale: locale)
        
        return UIImage(
            systemName: imageName,
            withConfiguration: imageConfig
        )
    }

    func getBackgroundColor(_ context: KeyInputContext) -> UIColor? {
        return self._backgroundColor ?? customGray1
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        self._onTap(document, context)
    }
}
