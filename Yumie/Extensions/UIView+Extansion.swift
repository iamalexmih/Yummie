//
//  UIView+Extansion.swift
//  Yumie
//
//  Created by Алексей Попроцкий on 04.09.2022.
//

import UIKit



extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
