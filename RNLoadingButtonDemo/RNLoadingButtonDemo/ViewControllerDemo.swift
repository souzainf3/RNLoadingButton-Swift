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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Buttons From Nib
        // Configure State
        btn1.hideTextWhenLoading = false
        btn1.loading = false
        btn1.activityIndicatorAlignment = RNActivityIndicatorAlignment.Right
        btn1.activityIndicatorEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 10)
        btn1.setTitleColor(UIColor(white: 0.673, alpha: 1.0), forState: UIControlState.Disabled)
        btn1.setTitle("connecting           ", forState: UIControlState.Disabled)
        
        
        btn2.hideTextWhenLoading = false
        btn2.loading = false
        btn2.activityIndicatorAlignment = RNActivityIndicatorAlignment.Left
        btn2.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.Gray, state: UIControlState.Disabled)
        btn2.activityIndicatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        btn2.setTitle("Loading", forState: UIControlState.Disabled)

    }

    
    func randomAttributes(button:RNLoadingButton) {
        
        buttonTapAction(button)
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            // your function here
            self.randomAttributes(button)
            })
    }
    
    @IBAction func buttonTapAction(button:RNLoadingButton) {
        
        button.loading = !button.loading
        button.activityIndicatorAlignment = RNActivityIndicatorAlignment.Center
        button.hideImageWhenLoading = true
        
    }
    
    
    @IBAction func doTap(sender:RNLoadingButton) {
        
        sender.enabled = false
        sender.loading = true;
        
        if sender.tag == 3 {
            sender.hideImageWhenLoading = true
        }
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(3.5 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
            sender.enabled = true
            sender.loading = false
            
            if sender.tag == 3 {
                sender.selected = !sender.selected
            }
        })
    }


}
