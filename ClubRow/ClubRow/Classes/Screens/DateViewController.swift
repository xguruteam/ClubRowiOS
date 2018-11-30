//
//  ExampleViewController.swift
//  SwiftEntryKitDemo
//
//  Created by Luccas on 6/8/18.
//  Copyright © 2018 Luccas. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {

    private let injectedView: UIView
    
    init(with view: UIView) {
        injectedView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = injectedView
    }
}
