//
//  UIView+Nib.swift
//  SwiftEntryKit_Example
//
//  Created by Luccas on 4/25/18.
//  Copyright (c) 2018 Luccas. All rights reserved.
//

import UIKit

extension UIView {

    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(type(of: self).className, owner: self, options: nil)?.first as? T else {
            return nil
        }
        addSubview(contentView)
        contentView.fillSuperview()
        return contentView
    }
}
