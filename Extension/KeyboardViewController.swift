//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/3/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    let keyInputContext = KeyInputContext(keySet: englishKeySet)
    
    let buttonSpacing: CGFloat = 5

    var impactFeedbackGenerator: UIImpactFeedbackGenerator?

    override func updateViewConstraints() {
        super.updateViewConstraints()
        adjustButtonSizes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        impactFeedbackGenerator = hasFullAccess ? UIImpactFeedbackGenerator(style: .light) : nil
        impactFeedbackGenerator?.prepare()
        mountButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // removes delays on touches on screen edges
        if let window = view.window,
            let recognizers = window.gestureRecognizers {
            recognizers.forEach { r in
                r.delaysTouchesBegan = false
                r.cancelsTouchesInView = false
                r.isEnabled = false
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    private func adjustButtonSizes() {
        let keySet = keyInputContext.keySet
        let maxNumberOfSpans = keySet.map { $0.reduce(0) { $0 + $1.span } }.max()!
        for (_, rowView) in buttonsView.arrangedSubviews.enumerated() {
            guard let rowStackView = rowView as? UIStackView else { continue }
            for (_, subView) in rowStackView.arrangedSubviews.enumerated() {
                guard let button = subView as? UIKeyButton else { continue }
                let key = button.key!
                let keyWidth = calculateKeyWidth(
                    span: key.span,
                    spanTotal: maxNumberOfSpans,
                    containerSize: view.bounds.width,
                    spacing: buttonSpacing
                )
                button.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
            }
        }
    }
    
    var buttonsView = UIStackView()
    
    private func mountButtons() {
        buttonsView.removeFromSuperview()
        buttonsView = UIStackView()
        buttonsView.axis = .vertical
        buttonsView.distribution = .fillEqually
        buttonsView.spacing = 5
        buttonsView.translatesAutoresizingMaskIntoConstraints = false

        for row in keyInputContext.keySet {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = buttonSpacing
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            for key in row {
                let button = createButton(withKey: key)
                rowStackView.addArrangedSubview(button)
            }
            
            let minimumRowHeight: CGFloat = 45.0
            let constraint = rowStackView
                .heightAnchor
                .constraint(greaterThanOrEqualToConstant: minimumRowHeight)
            constraint.isActive = true
            
            buttonsView.addArrangedSubview(rowStackView)
        }
        
        view.addSubview(buttonsView)
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            buttonsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
    
    private func createButton(withKey key: Key) -> UIButton {
        let button = UIKeyButton()
        button.setContext(keyInputContext)
        button.setImpactFeedbackGenerator(impactFeedbackGenerator!)
        button.key = key
        let title = key.getTitle(keyInputContext)
        let titleSuperscript = key.getTitleSuperscript(keyInputContext)
        let image = key.getImage(keyInputContext)
        let backgroundColor = key.getBackgroundColor(keyInputContext)
        
        if image != nil {
            let uiImageConfig = UIImage.SymbolConfiguration(scale: .medium)
            let uiImage = UIImage(
                systemName: image!,
                withConfiguration: uiImageConfig
            )
            button.setImage(uiImage, for: .normal)
            button.tintColor = .white
        }
        
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        
        if titleSuperscript != nil {
            button.setTitleSuperscript(titleSuperscript!)
        }
        
        button.backgroundColor = backgroundColor ?? UIColor.darkGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(onTouchDown), for: .touchDown)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        button.addGestureRecognizer(panGesture)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.3
        button.addGestureRecognizer(longPressRecognizer)
        return button
    }
    
    private var tapHighlightTimer: Timer?
    
    @objc func onTouchDown(sender: UIKeyButton) {
        handleDoubleTap(sender.key!)
    }
    
    @objc func onTouchUpInside(sender: UIKeyButton) {
        if keyInputContext.isHeld {
            keyInputContext.isHeld = false
        } else {
            let key = sender.key!
            key.onTap(document: textDocumentProxy, context: keyInputContext)
            afterTap(key)
        }
    }
    
    func afterTap(_ key: Key) {
        let isShiftKey = key.id == shift.id
        let isCapsLocked = keyInputContext.isCapsLocked
        
        if !isCapsLocked && !isShiftKey {
            keyInputContext.isShifted = false
        }
        
        if key.remountOnTap {
            mountButtons()
            adjustButtonSizes()
        } else {
            updateButtonImages()
        }
    }
    
    private var lastTappedKey: Key? = nil
    private var isFirstTappedKeyShifted: Bool = false
    private var doubleTapTimer: Timer?
    
    func handleDoubleTap(_ key: Key) {
        if lastTappedKey?.id == key.id {
            keyInputContext.isDoubleTapped = true
            keyInputContext.isShifted = isFirstTappedKeyShifted
        } else {
            lastTappedKey = key
            isFirstTappedKeyShifted = keyInputContext.isShifted
            keyInputContext.isDoubleTapped = false
        }
        doubleTapTimer?.invalidate()
        doubleTapTimer = Timer.scheduledTimer(
            timeInterval: 0.35,
            target: self,
            selector: #selector(resetDoubleTap),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func resetDoubleTap() {
        lastTappedKey = nil
        keyInputContext.isDoubleTapped = false
    }
    
    private func updateButtonImages() {
        for (_, rowView) in buttonsView.arrangedSubviews.enumerated() {
            guard let rowStackView = rowView as? UIStackView else { continue }
            for (_, subView) in rowStackView.arrangedSubviews.enumerated() {
                guard let button = subView as? UIKeyButton else { continue }
                button.updateImage(keyInputContext)
            }
        }
    }
    
    var lastTimestamp: TimeInterval?
    var lastUpdatedTranslationX = CGFloat(0)
    var backSpaceCache = ""
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIKeyButton else { return }
        guard let key = button.key else { return }
        
        let currentTime = Date().timeIntervalSince1970
        let translationX = gesture.translation(in: view).x
        var offsetMultiplier = CGFloat(30)
        
        if let lastTimestamp = lastTimestamp {
            let distance = translationX - lastUpdatedTranslationX
            let timeElapsed = currentTime - lastTimestamp
            let speed = abs(distance / CGFloat(timeElapsed))
            offsetMultiplier *= max(min(speed / 300, 2), 1)
        }

        let distance = translationX - lastUpdatedTranslationX
        let offset = Int((distance / view.bounds.width) * offsetMultiplier)
        if offset > 0 || offset < 0 {
            impactFeedbackGenerator?.impactOccurred()
            if key.id == backSpace.id || key.id == hangulBackSpace.id {
                if offset < 0 {
                    for _ in 0 ..< abs(offset) {
                        let before = textDocumentProxy.documentContextBeforeInput
                        guard let last = before?.last else { continue }
                        backSpaceCache.insert(last, at: backSpaceCache.startIndex)
                        textDocumentProxy.deleteBackward()
                    }
                } else {
                    for _ in 0 ..< offset {
                        guard let first = backSpaceCache.first else { continue }
                        backSpaceCache.removeFirst()
                        textDocumentProxy.insertText(String(first))
                    }
                }
            } else {
                textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
            }
            lastUpdatedTranslationX = translationX
            lastTimestamp = currentTime
        }
        
        if gesture.state == .ended {
            lastUpdatedTranslationX = CGFloat(0)
            lastTimestamp = nil
            backSpaceCache = ""
        }
    }
    
    var holdTimer: Timer?
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let button = gesture.view as? UIKeyButton else { return }
        guard let key = button.key else { return }
        
        if key.id == shift.id { return }
        if key.id == symbols.id { return }
        if key.id == changeLanguage.id { return }
        if key.id == enter.id { return }
        
        if gesture.state == .began {
            self.doubleTapTimer?.invalidate()
            
            self.impactFeedbackGenerator?.impactOccurred()
            key.onTap(document: self.textDocumentProxy, context: self.keyInputContext)
            
            self.keyInputContext.isHeld = true
            
            holdTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { _ in
                self.impactFeedbackGenerator?.impactOccurred()
                key.onTap(document: self.textDocumentProxy, context: self.keyInputContext)
            }
        } else if gesture.state == .ended {
            holdTimer?.invalidate()
            self.afterTap(key)
            self.resetDoubleTap()
            self.keyInputContext.isHeld = false
        }
    }
}
