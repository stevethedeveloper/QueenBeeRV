//
//  UIViewController+Ext.swift
//  QueenBeeRV
//
//  Created by Stephen Walton on 7/28/23.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenLosesFocus() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view?.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
}
