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
    
    private func mountButtons() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 5
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            mainStackView.addArrangedSubview(rowStackView)
            
            let minimumRowHeight: CGFloat = 50.0
            let constraint = rowStackView
                .heightAnchor
                .constraint(greaterThanOrEqualToConstant: minimumRowHeight)
            constraint.isActive = true
        }
        
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
    
    private func createButton(withKey key: Key) -> UIButton {
        let button = UIButton(type: .system)
        button.key = key
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(keyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc func keyTapped(sender: UIButton) {
        handleDoubleTap()
        sender.key?.onTap(textDocumentProxy, keyInputContext)
    }
    
    private var isFirstTap = false
    private var doubleTapTimer: Timer?
    
    func handleDoubleTap() {
        if isFirstTap {
            keyInputContext.isDoubleTap = true
            doubleTapTimer?.invalidate()
            doubleTapTimer = nil
            isFirstTap = false
        } else {
            isFirstTap = true
            keyInputContext.isDoubleTap = false
            doubleTapTimer = Timer.scheduledTimer(
                timeInterval: 0.3,
                target: self,
                selector: #selector(resetDoubleTap),
                userInfo: nil,
                repeats: false
            )
        }
    }

    @objc private func resetDoubleTap() {
        isFirstTap = false
        keyInputContext.isDoubleTap = false
    }
}
