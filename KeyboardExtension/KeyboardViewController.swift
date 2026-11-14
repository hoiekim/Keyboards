//
//  KeyboardViewController.swift
//  KeyboardExtension
//
//  Created by Hoie Kim on 8/30/24.
//

import UIKit
import AudioToolbox

class KeyboardViewController: UIInputViewController {
    let keyInputContext = KeyInputContext()
    var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    let viewPadding = CGFloat(3)
    let rowHeight = CGFloat(45)
    /// Keyboards at least this wide are split in half and pushed to the
    /// sides, leaving the hard-to-reach center empty (iPad, landscape iPhone).
    let splitWidthThreshold = CGFloat(600)
    /// Width of a one-span key in the split layout.
    let splitKeyWidth = CGFloat(50)
    /// Minimum empty space between the two halves of the split layout.
    let minSplitGap = CGFloat(50)
    /// Minimum downward travel to hide the keyboard with a swipe.
    let dismissSwipeDistance = CGFloat(40)
    /// Minimum upward travel on the symbols key to open the number pad.
    let numbersSwipeDistance = CGFloat(20)
    var buttonsView = UIStackView()
    private var lastLayoutWidth = CGFloat(0)
    /// Number of span columns rendered on each side of the split layout.
    private var splitColumns = 0

    override func updateViewConstraints() {
        super.updateViewConstraints()
        adjustButtonSizes()
        adjustViewHeight()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        impactFeedbackGenerator = hasFullAccess ? UIImpactFeedbackGenerator(style: .light) : nil
        impactFeedbackGenerator?.prepare()
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = darkBackground
        } else {
            view.backgroundColor = lightBackground
        }
        keyInputContext.isSplit = shouldSplit()
        mountButtons()
        mountDismissGesture()
    }
    
    private func shouldSplit() -> Bool {
        let width = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width
        return width >= splitWidthThreshold
    }
    
    private func provideFeedback() {
        if let generator = impactFeedbackGenerator {
            generator.impactOccurred()
        } else {
            AudioServicesPlaySystemSound(1104) // Keyboard click sound
        }
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
        adjustButtonSizes()
        adjustViewHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let portrait = isPortrait()
        let split = shouldSplit()
        if keyInputContext.isPortrait != portrait || keyInputContext.isSplit != split {
            keyInputContext.isPortrait = portrait
            keyInputContext.isSplit = split
            remount()
        } else if lastLayoutWidth != safeAreaWidth() {
            // Also catches safe area inset changes, which often arrive after
            // the first layout pass without the view width changing.
            if split && getSplitColumns() != splitColumns {
                remount()
            } else {
                adjustButtonSizes()
            }
        }
        lastLayoutWidth = safeAreaWidth()
    }
    
    private func safeAreaWidth() -> CGFloat {
        return view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right
    }
    
    private func remount() {
        mountButtons()
        adjustButtonSizes()
        adjustViewHeight()
    }
    
    private func getMaxNumberOfSpans() -> Int {
        let keySet = keyInputContext.getKeySet()
        return keySet.map { $0.reduce(0) { $0 + $1.span } }.max() ?? 0
    }
    
    /// How many span columns fit on each side of the split layout. Each side
    /// shows the full key set when the screen is wide enough; otherwise each
    /// side is truncated on its center-facing edge (never below half).
    private func getSplitColumns() -> Int {
        let maxNumberOfSpans = getMaxNumberOfSpans()
        let half = (maxNumberOfSpans + 1) / 2
        let availableWidth = safeAreaWidth() - (2 * viewPadding) - minSplitGap
        let fitting = Int(max(0, floor(availableWidth / 2 / splitKeyWidth)))
        return min(maxNumberOfSpans, max(half, fitting))
    }
    
    /// Returns the keys covering span columns `from ..< to` of a row. A
    /// utility key cut by the range (e.g. space) is shortened; any other cut
    /// key is replaced by an empty placeholder to keep the columns aligned.
    private func sliceRow(_ row: [Key], from: Int, to: Int) -> [Key] {
        var keys: [Key] = []
        var start = 0
        for key in row {
            let end = start + key.span
            let overlap = min(end, to) - max(start, from)
            if overlap == key.span {
                keys.append(key)
            } else if overlap > 0 {
                if let utilKey = key as? UtilKey {
                    keys.append(utilKey.withSpan(overlap))
                } else {
                    keys.append(blank.withSpan(overlap))
                }
            }
            start = end
        }
        return keys
    }
    
    private func mountButtons() {
        buttonsView.removeFromSuperview()
        buttonsView = UIStackView()
        buttonsView.axis = .vertical
        buttonsView.distribution = .fillEqually
        buttonsView.spacing = 0
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        let keySet = keyInputContext.getKeySet()
        let maxNumberOfSpans = getMaxNumberOfSpans()
        splitColumns = getSplitColumns()
        
        for row in keySet {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 0
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            if keyInputContext.isSplit {
                let left = sliceRow(row, from: 0, to: splitColumns)
                let right = sliceRow(
                    row,
                    from: maxNumberOfSpans - splitColumns,
                    to: maxNumberOfSpans
                )
                for key in left {
                    rowStackView.addArrangedSubview(createButton(withKey: key))
                }
                // Empty view that takes up all the remaining space in the center
                let spacer = UIView()
                spacer.translatesAutoresizingMaskIntoConstraints = false
                spacer.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
                spacer.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
                rowStackView.addArrangedSubview(spacer)
                for key in right {
                    rowStackView.addArrangedSubview(createButton(withKey: key))
                }
            } else {
                for key in row {
                    rowStackView.addArrangedSubview(createButton(withKey: key))
                }
            }
            
            let constraint = rowStackView
                .heightAnchor
                .constraint(equalToConstant: rowHeight)
            constraint.isActive = true
            
            buttonsView.addArrangedSubview(rowStackView)
        }
        
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: viewPadding
            ),
            buttonsView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -viewPadding
            ),
            buttonsView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -viewPadding
            )
        ])
    }
    
    private func createButton(withKey key: Key) -> UIButton {
        let button = UIKeyButton(
            key: key,
            globalContext: keyInputContext,
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
        
        if isLayoutSwitcher(key) {
            // Long-pressing a layout switcher opens the system keyboard list.
            // The list follows the touch, so the button must keep receiving
            // touch events after the long press is recognized.
            longPressRecognizer.cancelsTouchesInView = false
            button.addTarget(
                self,
                action: #selector(onSwitcherTouchEvent(_:event:)),
                for: .allTouchEvents
            )
        }
        
        return button
    }
    
    private let layoutSwitcherIds: Set<String> = [
        changeToSymbols.id,
        changeToEnglish.id,
        changeToKorean.id,
        changeToNumbers.id,
        changeToSymbolsFromNumbers.id,
        changeToLastLetters.id,
    ]
    
    private func isLayoutSwitcher(_ key: Key) -> Bool {
        return layoutSwitcherIds.contains(key.id)
    }
    
    /// The most recent touch event on a layout switcher key.
    private var lastSwitcherEvent: UIEvent?
    /// The switcher key currently showing the system keyboard list, if any.
    private var inputModeListButton: UIKeyButton?
    
    @objc private func onSwitcherTouchEvent(_ sender: UIKeyButton, event: UIEvent) {
        lastSwitcherEvent = event
        if inputModeListButton === sender {
            handleInputModeList(from: sender, with: event)
        }
    }
    
    private func adjustButtonSizes() {
        let keySet = keyInputContext.getKeySet()
        let maxNumberOfSpans = keySet.map { $0.reduce(0) { $0 + $1.span } }.max()!
        let isSplit = keyInputContext.isSplit
        // Clamped so an early call before the view has a width doesn't
        // produce negative width constraints.
        let availableWidth = max(0, safeAreaWidth() - (2 * viewPadding))
        var oneSpanSize = availableWidth / CGFloat(maxNumberOfSpans)
        if isSplit { oneSpanSize = splitKeyWidth }
        for (_, rowView) in buttonsView.arrangedSubviews.enumerated() {
            guard let rowStackView = rowView as? UIStackView else { continue }
            let buttonViews = rowStackView.arrangedSubviews
            for (i, buttonView) in buttonViews.enumerated() {
                guard let button = buttonView as? UIKeyButton else { continue }
                button.removeConstraints(button.constraints)
                button.mountImage()
                // In the split layout the spacer fills the remaining width, so
                // every key gets a fixed width. Otherwise the last key fills it.
                if !isSplit && i == (buttonViews.count - 1) { continue }
                let keyWidth = oneSpanSize * CGFloat(button.key.span)
                let widthConstraint = button.widthAnchor.constraint(equalToConstant: keyWidth)
                widthConstraint.priority = .defaultHigh
                widthConstraint.isActive = true
            }
        }
    }
    
    private func adjustViewHeight() {
        let rows = keyInputContext.getKeySet()
        let viewHeight = CGFloat(rows.count) * rowHeight + (2 * viewPadding)
        let heightConstraints = view.constraints.filter { $0.firstAttribute == .height }
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
    
    @objc private func onTouchDown(sender: UIKeyButton) {
        inputModeListButton = nil
        let contextSnapshot = keyInputContext.copy()
        contextSnapshot.tapHistory.clear()
        let tapHistoryElement = TapHistoryElement(
            timestamp: Date().timeIntervalSince1970,
            key: sender.key,
            context: contextSnapshot
        )
        keyInputContext.tapHistory.enqueue(tapHistoryElement)
        sender.setLocalContext(keyInputContext.copy())
        
        let isShiftKey = sender.key.id == shift.id
        let isShifted = keyInputContext.isShifted
        let isCapsLocked = keyInputContext.isCapsLocked
        
        if !isCapsLocked && !isShiftKey && isShifted {
            keyInputContext.isShifted = false
        }
    }
    
    @objc private func onTouchUpInside(sender: UIKeyButton) {
        // The touch was used for the system keyboard list, not a tap
        if inputModeListButton === sender { return }
        sender.onTap(document: textDocumentProxy)
        if !keyInputContext.isLongHold {
            afterTap(sender)
        }
    }
    
    private func afterTap(_ button: UIKeyButton) {
        let key = button.key
        
        let spaceKeys = [longSpace, shortSpace, tinySpace, longEnglishSpace, shortEnglishSpace]
        let isSpaceKey = spaceKeys.first { s in s.id == key.id } != nil
        let isEnterKey = key.id == enter.id
        
        if isSpaceKey || isEnterKey { handleAutoCapitalization() }
        
        if key.remountOnTap {
            remount()
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
        let translation = gesture.translation(in: view)
        
        // Swiping down from the center top edge hides the keyboard
        if gesture.state == .began {
            let location = gesture.location(in: view)
            let startLocation = CGPoint(
                x: location.x - translation.x,
                y: location.y - translation.y
            )
            isDismissCandidate = isInDismissZone(startLocation)
            didDismiss = false
        }
        if isDismissCandidate {
            if didDismiss { return }
            if isDismissSwipe(translation) {
                didDismiss = true
                provideFeedback()
                dismissKeyboard()
                return
            }
        }
        
        // Tapping the symbols key opens the symbols layout. Swiping up from
        // it opens the number pad instead.
        if key.id == changeToSymbols.id {
            if gesture.state == .ended {
                let isSwipeUp = -translation.y > numbersSwipeDistance
                    && abs(translation.y) > abs(translation.x)
                if isSwipeUp {
                    provideFeedback()
                    keyInputContext.setKeySet(KeySetName.NUMBERS)
                    remount()
                } else if button.bounds.contains(gesture.location(in: button)) {
                    onTouchUpInside(sender: button)
                }
            }
            return
        }
        
        let isUtilKey = key.className == UtilKey.className
        let isBackSpace = key.id == backSpace.id || key.id == hangulBackSpace.id
        if isUtilKey && !isBackSpace {
            // A slightly moved tap on a utility key still counts as a tap
            let isInside = button.bounds.contains(gesture.location(in: button))
            let moved = gesture.translation(in: view)
            let isSmallMove = hypot(moved.x, moved.y) < 20
            if gesture.state == .ended && isInside && isSmallMove {
                onTouchUpInside(sender: button)
            }
            return
        }
        
        if gesture.state == .began {
            lastPanTimestamp = nil
            lastUpdatedPanTranslationX = CGFloat(0)
            backSpaceCache = ""
            panAmount = 0
        } else if gesture.state == .ended {
            if panAmount == 0 {
                onTouchUpInside(sender: button)
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
            provideFeedback()
            
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
    
    private var isDismissCandidate = false
    private var didDismiss = false
    
    /// The area where a swipe down to hide the keyboard may start:
    /// the upper half of the top row, around the horizontal center.
    private func isInDismissZone(_ point: CGPoint) -> Bool {
        let isNearTop = point.y <= buttonsView.frame.minY + rowHeight * 0.5
        let isCentered = abs(point.x - view.bounds.midX) <= view.bounds.width * 0.2
        return isNearTop && isCentered
    }
    
    private func isDismissSwipe(_ translation: CGPoint) -> Bool {
        return translation.y > dismissSwipeDistance
            && translation.y > abs(translation.x) * 2
    }
    
    private var dismissPanGesture: UIPanGestureRecognizer?
    
    /// Catches swipes that don't start on a key, e.g. the top padding or the
    /// empty center of the split layout. Swipes starting on keys are handled
    /// in `handlePanGesture`.
    private func mountDismissGesture() {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleDismissPan(_:))
        )
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        dismissPanGesture = gesture
    }
    
    @objc private func handleDismissPan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began { didDismiss = false }
        if didDismiss { return }
        if isDismissSwipe(gesture.translation(in: view)) {
            didDismiss = true
            provideFeedback()
            dismissKeyboard()
        }
    }
    
    private var holdTimer: Timer?
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard let button = gesture.view as? UIKeyButton else { return }
        
        let key = button.key
        
        if isLayoutSwitcher(key) {
            if gesture.state == .began, let event = lastSwitcherEvent {
                provideFeedback()
                inputModeListButton = button
                handleInputModeList(from: button, with: event)
            }
            return
        }
        
        if gesture.state == .ended {
            holdTimer?.invalidate()
            if key.id != shift.id {
                keyInputContext.isLongHold = false
                keyInputContext.isShifted = false
            }
            afterTap(button)
        }
        
        if key.id == shift.id { return }
        if key.id == enter.id { return }
        
        if gesture.state == .began {
            keyInputContext.isLongHold = true
            if keyInputContext.tapHistory.peek(-1)?.context.isShifted == true {
                keyInputContext.isShifted = true
            }
            
            provideFeedback()
            button.onTap(document: textDocumentProxy)
            
            holdTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true
            ) { _ in
                self.provideFeedback()
                button.onTap(document: self.textDocumentProxy)
            }
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
        if isBeginningOfAll || isBeginningOfSentence || isBeginningOfParagraph {
            keyInputContext.isShifted = true
        }
    }
}

extension KeyboardViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        guard gestureRecognizer === dismissPanGesture else { return true }
        if touch.view is UIKeyButton { return false }
        return isInDismissZone(touch.location(in: view))
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === dismissPanGesture,
              let pan = gestureRecognizer as? UIPanGestureRecognizer
        else { return true }
        let velocity = pan.velocity(in: view)
        return velocity.y > 0 && abs(velocity.y) > abs(velocity.x)
    }
}
