//
//  KeyboardViewController.swift
//  Hoie Keyboard
//
//  Created by Hoie Kim on 8/3/24.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    
    let keyInputContext = KeyInputContext(
        isShift: false,
        isCapsLock: false,
        isDoubleTap: false
    )
    
    var keySet = englishKeySet

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNextKeyboardButton()
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 5
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonHeight: CGFloat = 40
        let buttonSpacing: CGFloat = 5

        for row in keySet {
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
            rowStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: minimumRowHeight).isActive = true
        }
        
        view.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
    
    @objc func keyTapped(sender: UIButton) {
        if let key = sender.key {
            key.onTap(textDocumentProxy, keyInputContext)
        }
    }
    
    private func createButton(withKey key: Key) -> UIButton {
        let title = key.title
        let button = UIButton(type: .system)
        button.key = key
        button.backgroundColor = UIColor.lightGray
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(keyTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    override func viewWillLayoutSubviews() {
        self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
        super.viewWillLayoutSubviews()
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }
    
    private func setupNextKeyboardButton() {
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(
            NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"),
            for: []
        )
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(
            self,
            action: #selector(handleInputModeList(from:with:)),
            for: .allTouchEvents
        )
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton
            .leftAnchor
            .constraint(equalTo: self.view.leftAnchor)
            .isActive = true
        self.nextKeyboardButton
            .bottomAnchor
            .constraint(equalTo: self.view.bottomAnchor)
            .isActive = true
    }

}
