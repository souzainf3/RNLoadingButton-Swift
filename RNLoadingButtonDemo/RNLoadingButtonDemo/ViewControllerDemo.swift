//
//  ViewControllerDemo.swift
//  RNButtomWithLoading
//
//  Created by Romilson Nunes on 06/08/14.
//  Copyright (c) 2014 Romilson. All rights reserved.
//

import UIKit

class ViewControllerDemo: UIViewController {
    
    @IBOutlet var btn1:RNLoadingButton!
    @IBOutlet var btn2:RNLoadingButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Buttons From Nib
        // Configure State
        let disabledColor = UIColor(white: 0.673, alpha: 1.0)
        
        btn1.hideTextWhenLoading = false
        btn1.isLoading = false
        btn1.activityIndicatorAlignment = RNActivityIndicatorAlignment.right
        btn1.activityIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 10)
        btn1.setTitleColor(disabledColor, for: .disabled)
        
        // create the attributed string
        let attributedString = NSMutableAttributedString(
            string: "connecting",
            attributes: [
                NSAttributedString.Key.foregroundColor : disabledColor,
            ]
        )
        btn1.setAttributedTitle(attributedString, for: .disabled)
//        btn1.activityIndicatorColor = .blue
        
        
        btn2.hideTextWhenLoading = false
        btn2.isLoading = false
        btn2.activityIndicatorAlignment = RNActivityIndicatorAlignment.left
        btn2.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        btn2.activityIndicatorEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        btn2.setTitle("Loading", for: UIControl.State.disabled)

    }

    
    func randomAttributes(button:RNLoadingButton) {
        
        buttonTapAction(button)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // your function here
            self.randomAttributes(button: button)
        }
    }
    
    @IBAction func buttonTapAction(_ button:RNLoadingButton) {
        
        button.isLoading = !button.isLoading
        button.activityIndicatorAlignment = RNActivityIndicatorAlignment.center
        button.hideImageWhenLoading = true
        
    }
    
    
    @IBAction func doTap(_ sender: RNLoadingButton) {
        
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
