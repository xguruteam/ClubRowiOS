//
//  UIButton+Extension.swift
//  ClubRow
//
//  Created by Guru on 7/10/19.
//  Copyright © 2019 CREATORSNEVERDIE. All rights reserved.
//

import UIKit

typealias UIButtonAction = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonAction
    init(_ closure: @escaping UIButtonAction) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonAction? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addAction(_ action: @escaping UIButtonAction) {
        targetClosure = action
        addTarget(self, action: #selector(closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}
