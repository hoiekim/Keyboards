//
//  UIButton.swift
//  Hoie UIButton
//
//  Created by Hoie Kim on 8/4/24.
//

import ObjectiveC.runtime
import UIKit

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
