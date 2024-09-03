//
//  UIKeyButton.swift
//  Extension
//
//  Created by Hoie Kim on 8/18/24.
//

import UIKit

private var keyAssociationKey: UInt8 = 0

class UIKeyButton: UIButton {
    var key: Key = blank
    var context = KeyInputContext()
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    let cornerLabel = UILabel()
    
    convenience init(
        key: Key,
        context: KeyInputContext,
        impactFeedbackGenerator: UIImpactFeedbackGenerator?
    ) {
        self.init(type: .custom)
        self.key = key
        self.context = context
        self.impactFeedbackGenerator = impactFeedbackGenerator
        self.addTarget(self, action: #selector(onTouchDown), for: .touchDown)
    }
    
    func updateImage() {
        let key = self.key
        let context = self.context
        let title = key.getTitle(context)
        let titleSuperscript = key.getTitleSuperscript(context)
        let image = key.getImage(context)
        let backgroundColor = key.getBackgroundColor(context)
        
        UIView.performWithoutAnimation {
            self.setImage(image, for: .normal)
            self.tintColor = .white
            self.setTitle(title, for: .normal)
            self.setTitleColor(UIColor.white, for: .normal)
            self.backgroundColor = backgroundColor ?? customGray1
            
            setTitleSuperscript(titleSuperscript)
        }
    }
    
    func setTitleSuperscript(_ titleSuperscript: String?) {
        cornerLabel.removeFromSuperview()
        if titleSuperscript == nil { return }
        
        cornerLabel.text = titleSuperscript
        cornerLabel.font = UIFont.systemFont(ofSize: 10)
        cornerLabel.textColor = .white
        cornerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cornerLabel)

        NSLayoutConstraint.activate([
            cornerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            cornerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    private var tapHighlightTimer: Timer?
    
    @objc func onTouchDown(sender: UIKeyButton) {
        if self.key.id == blank.id { return }
        impactFeedbackGenerator?.impactOccurred()
        sender.backgroundColor = .systemIndigo
        tapHighlightTimer?.invalidate()
        tapHighlightTimer = Timer.scheduledTimer(
            withTimeInterval: 0.15,
            repeats: false
        ) { _ in
            sender.backgroundColor = self.key.getBackgroundColor(self.context)
        }
    }
}
