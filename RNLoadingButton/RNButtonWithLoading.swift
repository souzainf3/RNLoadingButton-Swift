//
//  RNLoadingButton.swift
//  RNLoadingButton
//
//  Created by Romilson Nunes on 06/06/14.
//  Copyright (c) 2014 Romilson Nunes. All rights reserved.
//

import UIKit
public enum RNActivityIndicatorAligment: Int {
    case Left
    case Center
    case Right
    
    static func Random() ->RNActivityIndicatorAligment {
        let max = UInt32(RNActivityIndicatorAligment.Right.toRaw())
        let randomValue = Int(arc4random_uniform(max + 1))
        return RNActivityIndicatorAligment.fromRaw(randomValue)!
    }
}


class RNButtonWithLoading: UIButton {
    
    // Public Properties
    
    /** Loading */
    public var loading:Bool = false
    
    public var activityIndicatorEdgeInsets:UIEdgeInsets = UIEdgeInsetsZero
    public var hideImageWhenLoading:Bool = true
    public var hideTextWhenLoading:Bool = true
    
    /** Loading Alingment */
    public var activityIndicatorAligment:RNActivityIndicatorAligment = RNActivityIndicatorAligment.Center {
    didSet {
        self.setNeedsLayout()
    }
    }
    
    public let activityIndicatorView:UIActivityIndicatorView! = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)

    
    // Internal properties
    let imagens:NSMutableDictionary! = NSMutableDictionary()
    let texts:NSMutableDictionary! = NSMutableDictionary()
    let indicatorStyles : NSMutableDictionary! = NSMutableDictionary()
    
    // Static
    let defaultActivityStyle = UIActivityIndicatorViewStyle.Gray
    

    func setActivityIndicatorStyle( style:UIActivityIndicatorViewStyle, state:UIControlState) {
        var s:NSNumber = NSNumber.numberWithInteger(style.toRaw())
        setControlState( s, dic: indicatorStyles, state: state)
        self.setNeedsLayout()
    }

    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.setupActivityIndicator()
        commonInit()
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupActivityIndicator()
        
        // Images - Icons
        if super.imageForState(UIControlState.Normal) {
            self.storeValue(super.imageForState(UIControlState.Normal), onDic: imagens, state: UIControlState.Normal)
        }
        if super.imageForState(UIControlState.Highlighted) {
            self.storeValue(super.imageForState(UIControlState.Highlighted), onDic: imagens, state: UIControlState.Highlighted)
        }
        if super.imageForState(UIControlState.Disabled) {
            self.storeValue(super.imageForState(UIControlState.Disabled), onDic: imagens, state: UIControlState.Disabled)
        }
        if super.imageForState(UIControlState.Selected) {
            self.storeValue(super.imageForState(UIControlState.Selected), onDic: imagens, state: UIControlState.Selected)
        }
        
        
        
        // Title - Texts
        if super.titleForState(UIControlState.Normal) {
            self.storeValue(super.titleForState(UIControlState.Normal), onDic: texts, state: UIControlState.Normal)
        }
        if super.titleForState(UIControlState.Highlighted) {
            self.storeValue(super.titleForState(UIControlState.Highlighted), onDic: texts, state: UIControlState.Highlighted)
        }
        if super.titleForState(UIControlState.Disabled) {
            self.storeValue(super.titleForState(UIControlState.Disabled), onDic: texts, state: UIControlState.Disabled)
        }
        if super.titleForState(UIControlState.Selected) {
            self.storeValue(super.titleForState(UIControlState.Selected), onDic: texts, state: UIControlState.Selected)
        }

    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        var style=self.activityIndicatorStyleForState(self.currentControlState())
        self.activityIndicatorView.activityIndicatorViewStyle = style
        self.activityIndicatorView.frame = self.frameForActivityIndicator()
        self.bringSubviewToFront(self.activityIndicatorView)
    }
    
    
    deinit {
        self.removeObserver(forKeyPath: "hideImageWhenLoading")
        self.removeObserver(forKeyPath: "hideTextWhenLoading")
        self.removeObserver(forKeyPath: "loading")
        self.removeObserver(forKeyPath: "self.state")
        self.removeObserver(forKeyPath: "self.selected")
        self.removeObserver(forKeyPath: "self.highlighted")
    }
 
    
    //############################
    //      Setup e init        //
    
    func setupActivityIndicator() {
        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.startAnimating()
        self.addSubview(self.activityIndicatorView)
        
        var tap = UITapGestureRecognizer(target: self, action: Selector("activityIndicatorTapped:"))
        self.activityIndicatorView.addGestureRecognizer(tap)
    }
    
    func commonInit() {
        
        self.adjustsImageWhenHighlighted = true
        
        /** Title for States */
        self.texts.setValue(super.titleForState(UIControlState.Normal), forKey: "\(UIControlState.Normal.toRaw())")
        self.texts.setValue(super.titleForState(UIControlState.Highlighted), forKey: "\(UIControlState.Highlighted.toRaw())")
        self.texts.setValue(super.titleForState(UIControlState.Disabled), forKey: "\(UIControlState.Disabled.toRaw())")
        self.texts.setValue(super.titleForState(UIControlState.Selected), forKey: "\(UIControlState.Selected.toRaw())")

        /** Images for States */
        self.imagens.setValue(super.imageForState(UIControlState.Normal), forKey: "\(UIControlState.Normal.toRaw())")
        self.imagens.setValue(super.imageForState(UIControlState.Highlighted), forKey: "\(UIControlState.Highlighted.toRaw())")
        self.imagens.setValue(super.imageForState(UIControlState.Disabled), forKey: "\(UIControlState.Disabled.toRaw())")
        self.imagens.setValue(super.imageForState(UIControlState.Selected), forKey: "\(UIControlState.Selected.toRaw())")
        
        /** Indicator Styles for States */
        var s:NSNumber = NSNumber.numberWithInteger(defaultActivityStyle.toRaw())
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Normal.toRaw())")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Highlighted.toRaw())")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Disabled.toRaw())")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Selected.toRaw())")
        
        self.addObserver(forKeyPath: "hideImageWhenLoading")
        self.addObserver(forKeyPath: "hideTextWhenLoading")
        self.addObserver(forKeyPath: "loading")
        self.addObserver(forKeyPath: "self.state")
        self.addObserver(forKeyPath: "self.selected")
        self.addObserver(forKeyPath: "self.highlighted")
        
    }
    
    func activityIndicatorTapped(sender:AnyObject) {
        self.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    
    func currentControlState() -> UIControlState {
        var controlState = UIControlState.Normal.toRaw()
        if self.selected {
            controlState += UIControlState.Selected.toRaw()
        }
        if self.highlighted {
            controlState += UIControlState.Highlighted.toRaw()
        }
        if !self.enabled {
            controlState += UIControlState.Disabled.toRaw()
        }
        return UIControlState.fromRaw(controlState)!
    }

    func setControlState(value:AnyObject ,dic:NSMutableDictionary, state:UIControlState) {
        dic["\(state.toRaw())"] = value
        configureControlState(currentControlState())
    }
    
    func setImage(image:UIImage, state:UIControlState) {
        setControlState(image, dic: self.imagens, state: state)
    }
    
    // Activity Indicator Aligment
    func setActivityIndicatorAligment(alignment: RNActivityIndicatorAligment) {
        activityIndicatorAligment = alignment;
        self.setNeedsLayout();
    }
    
    func activityIndicatorStyleForState(state: UIControlState) ->UIActivityIndicatorViewStyle {
        
        var style:UIActivityIndicatorViewStyle  = defaultActivityStyle
        if let styleObj: AnyObject = self.getValueForControlState(self.indicatorStyles, state: state) {
            // https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/Enumerations.html
            style = UIActivityIndicatorViewStyle.fromRaw((styleObj as NSNumber).integerValue)!
        }
        return style
    }
    
    
    
    //##############################
    //       Setters & Getters
    override func setTitle(title: String!, forState state: UIControlState) {
        println(self.texts)
        self.storeValue(title, onDic: self.texts, state: state)
        if super.titleForState(state) != title {
            super.setTitle(title, forState: state)
        }
        self.setNeedsLayout()
    }

    
    override func titleForState(state: UIControlState) -> String?  {
        println(self.getValueForControlState(self.texts, state: state) as? String)
        return self.getValueForControlState(self.texts, state: state) as? String
    }

    override func setImage(image: UIImage!, forState state: UIControlState) {
        self.storeValue(image, onDic: self.imagens, state: state)
        if super.imageForState(state) != image {
            super.setImage(image, forState: state)
        }
        self.setNeedsLayout()
    }

    override func imageForState(state: UIControlState) -> UIImage? {
        return self.getValueForControlState(self.imagens, state: state) as? UIImage
    }
    

    
    
    
    //##############################
    //      Helper
    func addObserver(forKeyPath keyPath:NSString!) {
        self.addObserver(self, forKeyPath:keyPath, options: (NSKeyValueObservingOptions.Initial|NSKeyValueObservingOptions.New), context: nil)
    }
    
    func removeObserver(forKeyPath keyPath: String!) {
        self.removeObserver(self, forKeyPath: keyPath)
    }
    
    func getValueForControlState(dic:NSMutableDictionary!, state:UIControlState) -> AnyObject? {
        var value:AnyObject? =  dic.valueForKey("\(state.toRaw())");//  dic["\(state)"];
        if value {
            return value;
        }
        value = dic["\(UIControlState.Selected.toRaw())"];
        if ( (state & UIControlState.Selected) && value) {
            return value;
        }
        
        value = dic["\(UIControlState.Highlighted.toRaw())"];
        if ( (state & UIControlState.Selected) && value) {
            return value;
        }
        
        return dic["\(UIControlState.Normal.toRaw())"];
    }

    
    func configureControlState(state:UIControlState) {
        if self.loading {
            self.activityIndicatorView.startAnimating();
            if self.hideImageWhenLoading {
                
                var imgTmp:UIImage? = nil
                
                if let img = self.imageForState(UIControlState.Normal) {
                    // float scale = [[UIScreen mainScreen] scale];
                    // img.scale
                    imgTmp = self.clearImage(img.size, scale: 1)
                }
                
                super.setImage(imgTmp, forState: UIControlState.Normal)
                super.setImage(imgTmp, forState: UIControlState.Selected)
                
                super.setImage(imgTmp, forState: state)
                super.imageView.image = imgTmp
                
            }
            else {
                super.setImage( self.imageForState(state), forState: state)
            }
            
            if (self.hideTextWhenLoading) {
                super.setTitle(nil, forState: state)
                super.titleLabel.text = nil
            }
            else {
                super.setTitle( self.titleForState(state) , forState: state)
                super.titleLabel.text = self.titleForState(state)
            }
        }
        else {
            self.activityIndicatorView.stopAnimating();
            super.setImage(self.imageForState(state), forState: state)
            super.imageView.image = self.imageForState(state)
            super.setTitle(self.titleForState(state), forState: state)
            super.titleLabel.text = self.titleForState(state)
        }
        
        self.setNeedsLayout()
    }
    
    
    func frameForActivityIndicator() -> CGRect {
        
        var frame:CGRect = CGRectZero;
        frame.size = self.activityIndicatorView.frame.size;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
        
        switch self.activityIndicatorAligment {
            
        case RNActivityIndicatorAligment.Left:
            // top,  left bottom right
            frame.origin.x += self.activityIndicatorEdgeInsets.left;
            frame.origin.y += self.activityIndicatorEdgeInsets.top;
        case RNActivityIndicatorAligment.Center:
            frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
        case RNActivityIndicatorAligment.Right:
            var lengthOccupied:CFloat = 0;
            var x:CFloat = 0;
            var imageView:UIImageView = self.imageView;
            var titleLabel:UILabel = self.titleLabel;
            
            let xa = CGFloat(UInt(arc4random_uniform(UInt32(UInt(imageView.frame.size.width) * 5))))// - self.gameView.bounds.size.width * 2
            
            
            if (imageView != nil && titleLabel != nil){
                lengthOccupied = Float( imageView.frame.size.width + titleLabel.frame.size.width );
                
                
                if (imageView.frame.origin.x > titleLabel.frame.origin.x){
                    lengthOccupied += Float( imageView.frame.origin.x )
                }
                else {
                    lengthOccupied += Float( titleLabel.frame.origin.x )
                }
            }
            else if (imageView != nil){
                lengthOccupied = Float( imageView.frame.size.width + imageView.frame.origin.x )
            }
            else if (titleLabel != nil){
                lengthOccupied = Float( titleLabel.frame.size.width + imageView.frame.origin.x )
            }
            
            x =  Float(lengthOccupied) + Float( self.activityIndicatorEdgeInsets.left )
            if ( Float(x) + Float(frame.size.width) > Float(self.frame.size.width) ){
                x = Float(self.frame.size.width) - Float(frame.size.width + self.activityIndicatorEdgeInsets.right);
            }
            else if ( Float(x + Float(frame.size.width) ) > Float(self.frame.size.width - self.activityIndicatorEdgeInsets.right)){
                x = Float(self.frame.size.width) - ( Float(frame.size.width) + Float(self.activityIndicatorEdgeInsets.right) );
            }
            frame.origin.x = CGFloat( x );
        default:
            break
        }
        
        return frame;
    }
    
    
    // UIImage clear
    func clearImage(size:CGSize, scale:CGFloat) ->UIImage {
        UIGraphicsBeginImageContext(size)
        var context:CGContextRef = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(context)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
        
        UIGraphicsPopContext()
        var outputImage:UIImage  = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return  UIImage(CGImage: outputImage.CGImage, scale: scale, orientation: UIImageOrientation.Up)
    }
    
    
    /** Store values */
    /** Value in Dictionary on ControlState*/
    func storeValue(value:AnyObject?, onDic:NSMutableDictionary!, state:UIControlState) {
        if let _value: AnyObject = value  {
            onDic.setValue(_value, forKey: "\(state.toRaw())")
        }
        else {
            onDic.removeObjectForKey("\(state.toRaw())")
        }
        self.configureControlState(self.currentControlState())
    }
    
    
    /** KVO - Key-value Observer */
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>)  {
        
        println("KeyPath: \(keyPath)")
        configureControlState(currentControlState());
        
    }
    
}

