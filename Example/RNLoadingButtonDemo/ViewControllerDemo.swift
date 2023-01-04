//
//  ViewControllerDemo.swift
//  RNButtomWithLoading
//
//  Created by Romilson Nunes on 06/08/14.
//  Copyright (c) 2014 Romilson. All rights reserved.
//

import UIKit

class ViewControllerDemo: UIViewController {
    
    @IBOutlet private(set) var button1: LoadingButton!
    @IBOutlet private(set) var button2: LoadingButton!
    
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Buttons From Nib
        // Configure State
        let disabledColor = UIColor(white: 0.673, alpha: 1.0)
        
        button1.hideTextWhenLoading = false
        button1.isLoading = false
        button1.activityIndicatorAlignment = .right
        button1.activityIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 10)
        button1.setTitleColor(disabledColor, for: .disabled)
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.white.cgColor
        button1.layer.cornerRadius = 10
        
        // create the attributed string
        let attributedString = NSMutableAttributedString(
            string: "connecting",
            attributes: [
                NSAttributedString.Key.foregroundColor : disabledColor,
            ]
        )
        button1.setAttributedTitle(attributedString, for: .disabled)
        
        button2.hideTextWhenLoading = false
        button2.isLoading = false
        button2.activityIndicatorAlignment = .left
        button2.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        button2.activityIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.white.cgColor
        button2.layer.cornerRadius = 10
        
        button2.setTitle("Loading", for: UIControl.State.disabled)
    }
    
    private func randomAttributes(button: LoadingButton) {
        
        buttonTapAction(button)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // your function here
            self.randomAttributes(button: button)
        }
    }
    
    
    // MARK: - Actions

    @IBAction private func buttonTapAction(_ button: LoadingButton) {
        button.isLoading = !button.isLoading
        button.activityIndicatorAlignment = .center
        button.hideImageWhenLoading = true
        
    }
    
    @IBAction private func doTap(_ sender: LoadingButton) {
        
        sender.isEnabled = false
        sender.isLoading = true;
        
        if sender.tag == 3 {
            sender.hideImageWhenLoading = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            sender.isEnabled = true
            sender.isLoading = false
            
            if sender.tag == 3 {
                sender.isSelected = !sender.isSelected
            }
        }
    }
}
