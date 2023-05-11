//
//  UIView+Rounded.swift
//  MobintTestApp
//
//  Created by Eugene Kudritsky on 10.05.23.
//

import UIKit

extension UIImageView {

    func makeRounded() {

        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
