//
//  KeyButton.swift
//  Hoie Keyboard
//
//  Created by Hoie Kim on 8/4/24.
//

import UIKit
import ObjectiveC.runtime

private var keyAssociationKey: UInt8 = 0

extension UIButton {
    var key: Key? {
        get {
            return objc_getAssociatedObject(self, &keyAssociationKey) as? Key
        }
        set {
            objc_setAssociatedObject(
                self,
                &keyAssociationKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
