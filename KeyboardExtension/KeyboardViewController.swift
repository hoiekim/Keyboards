//
//  KeyboardViewController.swift
//  KeyboardExtension
//
//  Created by Hoie Kim on 8/30/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    let keyInputContext = KeyInputContext()
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    let viewPadding = CGFloat(3)
    let buttonSpacing = CGFloat(0)
    var buttonsView = UIStackView()
    let rowHeight = CGFloat(45)

    override func updateViewConstraints() {
        super.updateViewConstraints()
        adjustButtonSizes()
        adjustViewHeight()
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
        
        adjustButtonSizes()
        adjustViewHeight()
        handleAutoCapitalization()
        updateButtonImages()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if keyInputContext.isPortrait != isPortrait() {
            keyInputContext.isPortrait = isPortrait()
            mountButtons()
        }
    }
    
    private func mountButtons() {
        buttonsView.removeFromSuperview()
        buttonsView = UIStackView()
        buttonsView.axis = .vertical
        buttonsView.distribution = .fillEqually
        buttonsView.spacing = buttonSpacing
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        for row in keyInputContext.getKeySet() {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = buttonSpacing
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            for key in row {
                let button = createButton(withKey: key)
                rowStackView.addArrangedSubview(button)
            }
            
            let constraint = rowStackView
                .heightAnchor
                .constraint(equalToConstant: rowHeight)
            constraint.isActive = true
            
            buttonsView.addArrangedSubview(rowStackView)
        }
        
        view.addSubview(buttonsView)
        
        let padding = buttonSpacing + viewPadding
        
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: padding
            ),
            buttonsView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -padding
            ),
            buttonsView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -padding
            )
        ])
    }
    
    private func createButton(withKey key: Key) -> UIButton {
        let button = UIKeyButton(
            key: key,
            context: keyInputContext,
            impactFeedbackGenerator: impactFeedbackGenerator
        )
        
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
        let keySet = keyInputContext.getKeySet()
        let maxNumberOfSpans = keySet.map { $0.reduce(0) { $0 + $1.span } }.max()!
        for (_, rowView) in buttonsView.arrangedSubviews.enumerated() {
            guard let rowStackView = rowView as? UIStackView else { continue }
            let buttonViews = rowStackView.arrangedSubviews
            for (i, buttonView) in buttonViews.enumerated() {
                guard let button = buttonView as? UIKeyButton else { continue }
                button.removeConstraints(button.constraints)
                if i == (buttonViews.count - 1) { continue }
                let key = button.key
                let keyWidth = calculateKeyWidth(
                    span: key.span,
                    spanTotal: maxNumberOfSpans,
                    containerSize: view.bounds.width - (2 * viewPadding),
                    spacing: buttonSpacing
                )
                let widthConstraint = button.widthAnchor.constraint(equalToConstant: keyWidth)
                widthConstraint.priority = .defaultHigh
                widthConstraint.isActive = true
            }
        }
    }
    
    private func adjustViewHeight() {
        let rows = keyInputContext.getKeySet()
        let viewHeight = CGFloat(rows.count) * (rowHeight + buttonSpacing) + buttonSpacing + (2 * viewPadding)
        let heightConstraints = view.constraints.filter({ $0.firstAttribute == .height })
        NSLayoutConstraint.deactivate(heightConstraints)
        let newHeightConstraint = view.heightAnchor.constraint(equalToConstant: viewHeight)
        newHeightConstraint.priority = .defaultHigh
        newHeightConstraint.isActive = true
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
        // handle double tap
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
        let isShifted = keyInputContext.isShifted
        let isCapsLocked = keyInputContext.isCapsLocked
        
        if !isCapsLocked && !isShiftKey && isShifted {
            keyInputContext.isShifted = false
        }
        
        if key.id == longSpace.id || key.id == longEnglishSpace.id || key.id == enter.id {
            handleAutoCapitalization()
        }
        
        if key.remountOnTap {
            mountButtons()
            adjustButtonSizes()
            adjustViewHeight()
        } else if isShifted != keyInputContext.isShifted || isShiftKey {
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
        if keyInputContext.keySetName != KeySetName.ENGLISH { return }
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
