//
//  SPKeyboardManager.swift
//  KakaStock
//
//  Created by cliff on 2020/07/27.
//  Copyright © 2020 dunamu. All rights reserved.
//

import UIKit

typealias KeyboardHandler = (PanModalPresentationController, (Bool) -> ())

@objcMembers class KeyboardObserver: NSObject {
    
    static let shared: KeyboardObserver = {
        let observer = KeyboardObserver()
        observer.startObserving()
        return observer
    }()
    
    // MARK: - Public Properties
    
    // MARK: - Public Properties (for obj-c)
    
    var keyboardShownValue: Bool?
    
    var keyboardSizeValue: CGFloat?
    
    var keyboardHandler: [KeyboardHandler] = []
    
    // MARK: - Private Properties
    // MARK: - Init
    
    override init() {
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public
    
    func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(notification: Notification) {
        
        if let keyboardFrameValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.keyboardSizeValue = keyboardFrameValue.cgRectValue.height
        } else {
            self.keyboardSizeValue = .zero
        }
        
        self.keyboardShownValue = true
        keyboardHandler.forEach{
            $0.1(true)
        }
    }
    
    @objc func hideKeyboard(notification: Notification) {
        self.keyboardSizeValue = .zero
        self.keyboardShownValue = false
        
        keyboardHandler.forEach{
            $0.1(false)
        }
    }
    
}
