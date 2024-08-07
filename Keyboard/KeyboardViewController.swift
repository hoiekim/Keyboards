//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Hoie Kim on 8/3/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    let keyInputContext = KeyInputContext(
        isShift: false,
        isCapsLock: false,
        isDoubleTap: false,
        keySet: englishKeySet
    )

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNextKeyboardButton()
        mountButtons()
    }
    
    override func viewWillLayoutSubviews() {
        nextKeyboardButton.isHidden = !needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    private func setupNextKeyboardButton() {
        nextKeyboardButton = UIButton(type: .system)
        
        nextKeyboardButton.setTitle(
            NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"),
            for: []
        )
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextKeyboardButton.addTarget(
            self,
            action: #selector(handleInputModeList(from:with:)),
            for: .allTouchEvents
        )
        
        view.addSubview(nextKeyboardButton)
        
        nextKeyboardButton
            .leftAnchor
            .constraint(equalTo: view.leftAnchor)
            .isActive = true
        nextKeyboardButton
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
    }
    
    var buttonsView = UIStackView()
    
    private func mountButtons() {
        buttonsView.removeFromSuperview()
        buttonsView = UIStackView()
        buttonsView.axis = .vertical
        buttonsView.distribution = .fillEqually
        buttonsView.spacing = 5
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonSpacing: CGFloat = 5

        for row in keyInputContext.keySet {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = buttonSpacing
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            for key in row {
                let button = createButton(withKey: key)
                rowStackView.addArrangedSubview(button)
            }
            
            let minimumRowHeight: CGFloat = 50.0
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
        let button = UIButton(type: .system)
        button.key = key
        
        if keyInputContext.isShifted || keyInputContext.isCapsLocked {
            button.setTitle(key.title.uppercased(), for: .normal)
        } else {
            button.setTitle(key.title.lowercased(), for: .normal)
        }
        
        button.backgroundColor = UIColor.darkGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(keyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc func keyTapped(sender: UIButton) {
        let key = sender.key!
        handleDoubleTap(key: key)
        let isShiftKey = key.isShift
        key.onTap(uiKeyInput: textDocumentProxy, context: keyInputContext)
        if !keyInputContext.isCapsLocked && !isShiftKey {
            keyInputContext.isShifted = false
            shift.setTitle(newTitle: TITLE_SHIFT_DEFAULT)
        }
        mountButtons()
    }
    
    private var firstTappedKey: Key?
    private var doubleTapTimer: Timer?
    
    func handleDoubleTap(key: Key) {
        if firstTappedKey?.id == key.id {
            keyInputContext.isDoubleTapped = true
            doubleTapTimer?.invalidate()
        } else {
            firstTappedKey = key
            keyInputContext.isDoubleTapped = false
        }
        doubleTapTimer = Timer.scheduledTimer(
            timeInterval: 0.3,
            target: self,
            selector: #selector(resetDoubleTap),
            userInfo: nil,
            repeats: false
        )
    }

    @objc private func resetDoubleTap() {
        firstTappedKey = nil
        keyInputContext.isDoubleTapped = false
    }
}
