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
    
    convenience init() {
        self.init(type: .custom)
        self.addTarget(self, action: #selector(onTouchDown), for: .touchDown)
    }
    
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
            self.backgroundColor = backgroundColor ?? customGray1
            
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
    
    private var context: KeyInputContext?
    
    func setContext(_ context: KeyInputContext) {
        self.context = context
    }
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    
    func setImpactFeedbackGenerator(_ generator: UIImpactFeedbackGenerator) {
        self.impactFeedbackGenerator = generator
    }
    
    private var tapHighlightTimer: Timer?
    
    @objc func onTouchDown(sender: UIKeyButton) {
        impactFeedbackGenerator?.impactOccurred()
        sender.backgroundColor = .systemIndigo
        tapHighlightTimer?.invalidate()
        tapHighlightTimer = Timer.scheduledTimer(
            withTimeInterval: 0.3,
            repeats: false
        ) { _ in
            sender.backgroundColor = self.key!.getBackgroundColor(self.context!)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? self : hitView
    }
}
