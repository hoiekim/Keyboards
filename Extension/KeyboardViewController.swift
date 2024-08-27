//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/3/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    let keyInputContext = KeyInputContext(keySet: englishKeySet)
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    let buttonSpacing: CGFloat = 5
    var buttonsView = UIStackView()

    override func updateViewConstraints() {
        super.updateViewConstraints()
        adjustButtonSizes()
        updateButtonImages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        impactFeedbackGenerator = hasFullAccess ? UIImpactFeedbackGenerator(style: .light) : nil
        impactFeedbackGenerator?.prepare()
        view.backgroundColor = customGray0
        mountButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // removes delays on touches on screen edges
        if let window = view.window,
           let recognizers = window.gestureRecognizers
        {
            for r in recognizers {
                r.delaysTouchesBegan = false
                r.cancelsTouchesInView = false
                r.isEnabled = false
            }
        }
        
        handleAutoCapitalization()
        updateButtonImages()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
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
            
            let rowHeight: CGFloat = 45.0
            let constraint = rowStackView
                .heightAnchor
                .constraint(equalToConstant: rowHeight)
            constraint.isActive = true
            
            buttonsView.addArrangedSubview(rowStackView)
        }
        
        view.addSubview(buttonsView)
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            buttonsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    private func createButton(withKey key: Key) -> UIButton {
        let button = UIKeyButton(
            key: key,
            context: keyInputContext,
            impactFeedbackGenerator: impactFeedbackGenerator
        )
        
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)
        button.addTarget(self, action: #selector(onTouchDown), for: .touchDown)
        
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        button.addGestureRecognizer(panGesture)
        
        let longPressRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        longPressRecognizer.minimumPressDuration = 0.3
        button.addGestureRecognizer(longPressRecognizer)
        
        return button
    }
    
    private func adjustButtonSizes() {
        let keySet = keyInputContext.keySet
        let maxNumberOfSpans = keySet.map { $0.reduce(0) { $0 + $1.span } }.max()!
        for (_, rowView) in buttonsView.arrangedSubviews.enumerated() {
            guard let rowStackView = rowView as? UIStackView else { continue }
            for (_, subView) in rowStackView.arrangedSubviews.enumerated() {
                guard let button = subView as? UIKeyButton else { continue }
                let key = button.key
                let keyWidth = calculateKeyWidth(
                    span: key.span,
                    spanTotal: maxNumberOfSpans,
                    containerSize: view.bounds.width,
                    spacing: buttonSpacing
                )
                button.removeConstraints(button.constraints)
                button.widthAnchor.constraint(equalToConstant: keyWidth).isActive = true
            }
        }
    }
    
    private func updateButtonImages() {
        for (_, rowView) in buttonsView.arrangedSubviews.enumerated() {
            guard let rowStackView = rowView as? UIStackView else { continue }
            for (_, subView) in rowStackView.arrangedSubviews.enumerated() {
                guard let button = subView as? UIKeyButton else { continue }
                button.updateImage()
            }
        }
    }
    
    private var lastTappedKey: Key? = nil
    private var isFirstTappedKeyShifted: Bool = false
    private var doubleTapTimer: Timer?
    
    @objc private func onTouchDown(sender: UIKeyButton) {
        let key = sender.key
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
    
    @objc private func onTouchUpInside(sender: UIKeyButton) {
        if keyInputContext.isHeld {
            keyInputContext.isHeld = false
        } else {
            sender.key.onTap(document: textDocumentProxy, context: keyInputContext)
        }
        afterTap(sender.key)
    }
    
    private func afterTap(_ key: Key) {
        let isShiftKey = key.id == shift.id
        let isCapsLocked = keyInputContext.isCapsLocked
        
        if !isCapsLocked && !isShiftKey {
            keyInputContext.isShifted = false
        }
        
        if key.id == space.id || key.id == englishSpace.id || key.id == enter.id {
            handleAutoCapitalization()
        }
        
        if key.remountOnTap {
            mountButtons()
            adjustButtonSizes()
        } else {
            updateButtonImages()
        }
    }
    
    private var lastPanTimestamp: TimeInterval?
    private var lastUpdatedPanTranslationX = CGFloat(0)
    private var backSpaceCache = ""
    private var panAmount = 0
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view as? UIKeyButton else { return }
        let key = button.key
        
        let isUtilKey = key.className == UtilKey.className
        let isBackSpace = key.id == backSpace.id || key.id == hangulBackSpace.id
        if isUtilKey && !isBackSpace { return }
        
        if gesture.state == .began {
            lastPanTimestamp = nil
            lastUpdatedPanTranslationX = CGFloat(0)
            backSpaceCache = ""
            panAmount = 0
        } else if gesture.state == .ended {
            if panAmount == 0 {
                self.onTouchUpInside(sender: button)
            }
        }
        
        let currentTime = Date().timeIntervalSince1970
        let translationX = gesture.translation(in: view).x
        var offsetMultiplier = CGFloat(30)
        
        let distance = translationX - lastUpdatedPanTranslationX
        
        if let lastTimestamp = lastPanTimestamp {
            let timeElapsed = currentTime - lastTimestamp
            let speed = abs(distance / CGFloat(timeElapsed))
            offsetMultiplier *= max(min(speed / 300, 2), 1)
        }

        let offset = Int((distance / view.bounds.width) * offsetMultiplier)
        if offset > 0 || offset < 0 {
            impactFeedbackGenerator?.impactOccurred()
            
            if isBackSpace {
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
            
            lastUpdatedPanTranslationX = translationX
            lastPanTimestamp = currentTime
            panAmount += abs(offset)
        }
    }
    
    private var holdTimer: Timer?
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let button = gesture.view as? UIKeyButton else { return }
        let key = button.key
        
        if key.id == shift.id { return }
        if key.id == changeToKorean.id { return }
        if key.id == changeToEnglish.id { return }
        if key.id == changeToSymbols.id { return }
        if key.id == enter.id { return }
        
        if gesture.state == .began {
            doubleTapTimer?.invalidate()
            
            impactFeedbackGenerator?.impactOccurred()
            key.onTap(document: textDocumentProxy, context: keyInputContext)
            
            keyInputContext.isHeld = true
            
            holdTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { _ in
                self.impactFeedbackGenerator?.impactOccurred()
                key.onTap(document: self.textDocumentProxy, context: self.keyInputContext)
            }
        } else if gesture.state == .ended {
            holdTimer?.invalidate()
            afterTap(key)
            resetDoubleTap()
            keyInputContext.isHeld = false
        }
    }
    
    func handleAutoCapitalization() {
        if !isKeySetsEqual(keyInputContext.keySet, englishKeySet) { return }
        let isEmpty = textDocumentProxy.documentContextBeforeInput?.isEmpty ?? true
        let last = textDocumentProxy.documentContextBeforeInput?.last
        let lastTwo = textDocumentProxy.documentContextBeforeInput?.suffix(2)
        let isBeginningOfAll = isEmpty || last == nil
        let isBeginningOfSentence = lastTwo == ". " || lastTwo == "? " || lastTwo == "! "
        let isBeginningOfParagraph = last == "\n"
        if  isBeginningOfAll || isBeginningOfSentence || isBeginningOfParagraph {
            keyInputContext.isShifted = true
        }
    }
}
