//
//  UIKeyButton.swift
//  Extension
//
//  Created by Hoie Kim on 8/18/24.
//

import UIKit

private var keyAssociationKey: UInt8 = 0

class UIKeyButton: UIButton {
    var key: Key? = nil
    let cornerLabel = UILabel()
    
    func updateImage(_ context: KeyInputContext) {
        guard let key = self.key else { return }
        let title = key.getTitle(context)
        let titleSuperscript = key.getTitleSuperscript(context)
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
            
            setTitleSuperscript(titleSuperscript)
        }
    }
    
    func setTitleSuperscript(_ titleSuperscript: String?) {
        cornerLabel.removeFromSuperview()
        if titleSuperscript == nil { return }
        
        cornerLabel.text = titleSuperscript
        cornerLabel.font = UIFont.systemFont(ofSize: 12)
        cornerLabel.textColor = .white
        cornerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cornerLabel)

        NSLayoutConstraint.activate([
            cornerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            cornerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
