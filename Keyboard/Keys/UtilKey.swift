//
//  UtilKey.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/12/24.
//

import UIKit

class UtilKey: Key {
    typealias OnTapUtilKey = (UtilKey, UITextDocumentProxy, KeyInputContext) -> Void

    let id: String
    var title: String
    let span: Int
    var backgroundColor: UIColor?
    var _onTap: OnTapUtilKey

    init(
        id: String,
        title: String,
        span: Int = 1,
        backgroundColor: UIColor? = nil,
        onTap: @escaping OnTapUtilKey
    ) {
        self.id = "UtilKey_" + id
        self.title = title
        self.span = span
        self.backgroundColor = backgroundColor
        self._onTap = onTap
    }

    func onTap(document: UITextDocumentProxy, context: KeyInputContext) {
        _onTap(self, document, context)
    }
}
