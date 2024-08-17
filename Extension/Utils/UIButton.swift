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
    
    func updateImage(_ context: KeyInputContext) {
        guard let key = self.key else { return }
        let title = key.getTitle(context)
        let image = key.getImage(context)
        let backgroundColor = key.getBackgroundColor(context)
        
        UIView.performWithoutAnimation {
            if image != nil {
                let uiImage = UIImage(
                    systemName: image!,
                    withConfiguration: UIImage.SymbolConfiguration(scale: .medium)
                )
                self.setImage(uiImage, for: .normal)
                self.tintColor = .white
            } else {
                self.setImage(nil, for: .normal)
            }
            self.setTitle(title, for: .normal)
            self.backgroundColor = backgroundColor ?? UIColor.darkGray
        }
    }
}
