//
//  UIKeyButton.swift
//  Extension
//
//  Created by Hoie Kim on 8/18/24.
//

import UIKit

class UIKeyButton: UIButton {
    var key: Key = blank
    private var globalContext = KeyInputContext()
    private var localContext: KeyInputContext?
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private let visibleBox = UIButton()
    private let cornerLabel = UILabel()
    
    convenience init(
        key: Key,
        globalContext: KeyInputContext,
        impactFeedbackGenerator: UIImpactFeedbackGenerator?
    ) {
        self.init(type: .custom)
        self.key = key
        self.globalContext = globalContext
        self.impactFeedbackGenerator = impactFeedbackGenerator
        addTarget(self, action: #selector(onTouchDown), for: .touchDown)
        self.backgroundColor = .clear
    }
    
    func mountImage() {
        visibleBox.removeFromSuperview()
        
        let padding = CGFloat(3)
        let cornerRadius = CGFloat(8)
        
        visibleBox.translatesAutoresizingMaskIntoConstraints = false
        visibleBox.layer.cornerRadius = cornerRadius
        
        let backgroundColor = key.getBackgroundColor(globalContext)
        visibleBox.backgroundColor = backgroundColor ?? customGray1
        
        let title = key.getTitle(globalContext)
        visibleBox.setTitle(title, for: .normal)
        visibleBox.setTitleColor(UIColor.white, for: .normal)
        
        let image = key.getImage(globalContext)
        visibleBox.setImage(image, for: .normal)
        visibleBox.tintColor = .white
        
        visibleBox.isUserInteractionEnabled = false
        
        visibleBox.layer.shadowColor = UIColor.black.cgColor
        visibleBox.layer.shadowOpacity = 0.5
        visibleBox.layer.shadowOffset = CGSize(width: 0, height: 2)
        visibleBox.layer.shadowRadius = 2
        
        addSubview(visibleBox)
        
        let topConstraint = visibleBox.topAnchor.constraint(
            equalTo: topAnchor,
            constant: padding
        )
        
        let bottomConstraint = visibleBox.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -padding
        )
        
        let leftConstraint = visibleBox.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: padding
        )
        
        let rightConstraint = visibleBox.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -padding
        )
        
        topConstraint.isActive = true
        bottomConstraint.isActive = true
        leftConstraint.isActive = true
        rightConstraint.isActive = true
        
        cornerLabel.removeFromSuperview()
        if let titleSuperscript = key.getTitleSuperscript(globalContext) {
            mountCornerLabel(titleSuperscript)
        }
        
    }
    
    func mountCornerLabel(_ text: String) {
        cornerLabel.text = text
        cornerLabel.font = UIFont.systemFont(ofSize: 10)
        cornerLabel.textColor = .white
        cornerLabel.translatesAutoresizingMaskIntoConstraints = false
        cornerLabel.isUserInteractionEnabled = false
        
        visibleBox.addSubview(cornerLabel)
        
        let topConstraint = cornerLabel.topAnchor.constraint(
            equalTo: visibleBox.topAnchor,
            constant: 1
        )
        
        let rightConstraint = cornerLabel.trailingAnchor.constraint(
            equalTo: visibleBox.trailingAnchor,
            constant: text.count == 1 ? -8 : -3
        )
        
        topConstraint.isActive = true
        rightConstraint.isActive = true
    }
    
    func updateImage() {
        let backgroundColor = key.getBackgroundColor(globalContext)
        visibleBox.backgroundColor = backgroundColor ?? customGray1
        
        let title = key.getTitle(globalContext)
        visibleBox.setTitle(title, for: .normal)
        visibleBox.setTitleColor(UIColor.white, for: .normal)
        
        let image = key.getImage(globalContext)
        visibleBox.setImage(image, for: .normal)
        visibleBox.tintColor = .white
        
        if visibleBox.subviews.isEmpty {
            if let titleSuperscript = key.getTitleSuperscript(globalContext) {
                mountCornerLabel(titleSuperscript)
            } else {
                cornerLabel.text = nil
            }
        } else {
            if let titleSuperscript = key.getTitleSuperscript(globalContext) {
                cornerLabel.text = titleSuperscript
            } else {
                cornerLabel.text = nil
                cornerLabel.removeFromSuperview()
            }
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
        if key.id == blank.id { return }
        impactFeedbackGenerator?.impactOccurred()
        visibleBox.backgroundColor = .systemIndigo
        visibleBox.layer.shadowOffset = CGSize(width: 0, height: 0)
        tapHighlightTimer?.invalidate()
        tapHighlightTimer = Timer.scheduledTimer(
            withTimeInterval: 0.15,
            repeats: false
        ) { _ in
            let backgroundColor = self.key.getBackgroundColor(self.globalContext)
            self.visibleBox.backgroundColor = backgroundColor ?? customGray1
            self.visibleBox.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
    }
    
    func setLocalContext(_ c: KeyInputContext) {
        self.localContext = c
    }
    
    func onTap(document: UITextDocumentProxy) {
        let context = localContext ?? globalContext
        let contextSnapshot = context.copy()
        self.key.onTap(document: document, context: context)
        let diff = context.getDiff(from: contextSnapshot)
        globalContext.override(from: diff)
        self.localContext = nil
    }
}
