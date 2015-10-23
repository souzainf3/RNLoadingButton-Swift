//
//  RNLoadingButton.swift
//  RNLoadingButton
//
//  Created by Romilson Nunes on 06/06/14.
//  Copyright (c) 2014 Romilson Nunes. All rights reserved.
//

import UIKit
public enum RNActivityIndicatorAlignment: Int {
    case Left
    case Center
    case Right
    
    static func Random() ->RNActivityIndicatorAlignment {
        let max = UInt32(RNActivityIndicatorAlignment.Right.rawValue)
        let randomValue = Int(arc4random_uniform(max + 1))
        return RNActivityIndicatorAlignment(rawValue: randomValue)!
    }
}


public class RNLoadingButton: UIButton {
    
    /** Loading */
    public var loading:Bool = false {
        didSet {
            configureControlState(currentControlState());
        }
    }

    public var hideImageWhenLoading:Bool = true {
        didSet {
            configureControlState(currentControlState());
        }
    }
    public var hideTextWhenLoading:Bool = true {
        didSet {
            configureControlState(currentControlState());
        }
    }
    
    public var activityIndicatorEdgeInsets:UIEdgeInsets = UIEdgeInsetsZero
    
    /** Loading Alingment */
    public var activityIndicatorAlignment:RNActivityIndicatorAlignment = RNActivityIndicatorAlignment.Center {
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

    
    // MARK: - Initializers
    
    deinit {
        self.removeObserver(forKeyPath: "self.state")
        self.removeObserver(forKeyPath: "self.selected")
        self.removeObserver(forKeyPath: "self.highlighted")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        self.setupActivityIndicator()
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupActivityIndicator()
        
        // Images - Icons
        if (super.imageForState(UIControlState.Normal) != nil) {
            self.storeValue(super.imageForState(UIControlState.Normal), onDic: imagens, state: UIControlState.Normal)
        }
        if (super.imageForState(UIControlState.Highlighted) != nil) {
            self.storeValue(super.imageForState(UIControlState.Highlighted), onDic: imagens, state: UIControlState.Highlighted)
        }
        if (super.imageForState(UIControlState.Disabled) != nil) {
            self.storeValue(super.imageForState(UIControlState.Disabled), onDic: imagens, state: UIControlState.Disabled)
        }
        if (super.imageForState(UIControlState.Selected) != nil) {
            self.storeValue(super.imageForState(UIControlState.Selected), onDic: imagens, state: UIControlState.Selected)
        }
        
        // Title - Texts
        if let titleNormal = super.titleForState(.Normal) {
            self.storeValue(titleNormal, onDic: texts, state: .Normal)
        }
        if let titleHighlighted = super.titleForState(.Highlighted) {
            self.storeValue(titleHighlighted, onDic: texts, state: .Highlighted)
        }
        if let titleDisabled = super.titleForState(.Disabled) {
            self.storeValue(titleDisabled, onDic: texts, state: .Disabled)
        }
        if let titleSelected = super.titleForState(.Selected) {
            self.storeValue(titleSelected, onDic: texts, state: .Selected)
        }
        
    }
    
    private func commonInit() {
        
        self.adjustsImageWhenHighlighted = true
        
        /** Title for States */
        self.texts.setValue(super.titleForState(UIControlState.Normal), forKey: "\(UIControlState.Normal.rawValue)")
        self.texts.setValue(super.titleForState(UIControlState.Highlighted), forKey: "\(UIControlState.Highlighted.rawValue)")
        self.texts.setValue(super.titleForState(UIControlState.Disabled), forKey: "\(UIControlState.Disabled.rawValue)")
        self.texts.setValue(super.titleForState(UIControlState.Selected), forKey: "\(UIControlState.Selected.rawValue)")
        
        /** Images for States */
        self.imagens.setValue(super.imageForState(UIControlState.Normal), forKey: "\(UIControlState.Normal.rawValue)")
        self.imagens.setValue(super.imageForState(UIControlState.Highlighted), forKey: "\(UIControlState.Highlighted.rawValue)")
        self.imagens.setValue(super.imageForState(UIControlState.Disabled), forKey: "\(UIControlState.Disabled.rawValue)")
        self.imagens.setValue(super.imageForState(UIControlState.Selected), forKey: "\(UIControlState.Selected.rawValue)")
        
        /** Indicator Styles for States */
        let s:NSNumber = NSNumber(integer: defaultActivityStyle.rawValue)
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Normal.rawValue)")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Highlighted.rawValue)")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Disabled.rawValue)")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.Selected.rawValue)")
        
        self.addObserver(forKeyPath: "self.state")
        self.addObserver(forKeyPath: "self.selected")
        self.addObserver(forKeyPath: "self.highlighted")
    }
    
    
    // MARK: - Relayout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let style = self.activityIndicatorStyleForState(self.currentControlState())
        self.activityIndicatorView.activityIndicatorViewStyle = style
        self.activityIndicatorView.frame = self.frameForActivityIndicator()
        self.bringSubviewToFront(self.activityIndicatorView)
    }
    
    // MARK: - Public Methods
    
    public func setActivityIndicatorStyle( style:UIActivityIndicatorViewStyle, state:UIControlState) {
        let s:NSNumber = NSNumber(integer: style.rawValue);
        setControlState( s, dic: indicatorStyles, state: state)
        self.setNeedsLayout()
    }
    
    // Activity Indicator Alignment
    public func setActivityIndicatorAlignment(alignment: RNActivityIndicatorAlignment) {
        activityIndicatorAlignment = alignment;
        self.setNeedsLayout();
    }
    
    public func activityIndicatorStyleForState(state: UIControlState) -> UIActivityIndicatorViewStyle {
        var style:UIActivityIndicatorViewStyle  = defaultActivityStyle
        if let styleObj: AnyObject = self.getValueForControlState(self.indicatorStyles, state: state)
        {
            // https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/Enumerations.html
            style = UIActivityIndicatorViewStyle(rawValue: (styleObj as! NSNumber).integerValue)!
        }
        return style
    }
    
    
    // MARK: - Targets/Actions
    
    func activityIndicatorTapped(sender:AnyObject) {
        self.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    // MARK: - Internal Methods
    
    func setupActivityIndicator() {
        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.startAnimating()
        self.addSubview(self.activityIndicatorView)
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("activityIndicatorTapped:"))
        self.activityIndicatorView.addGestureRecognizer(tap)
    }
    
    func currentControlState() -> UIControlState {
        var controlState = UIControlState.Normal.rawValue
        if self.selected {
            controlState += UIControlState.Selected.rawValue
        }
        if self.highlighted {
            controlState += UIControlState.Highlighted.rawValue
        }
        if !self.enabled {
            controlState += UIControlState.Disabled.rawValue
        }
        return UIControlState(rawValue: controlState)
    }
    
    func setControlState(value:AnyObject ,dic:NSMutableDictionary, state:UIControlState) {
        dic["\(state.rawValue)"] = value
        configureControlState(currentControlState())
    }
    
    func setImage(image:UIImage, state:UIControlState) {
        setControlState(image, dic: self.imagens, state: state)
    }
    

    // MARK: - Override Setters & Getters
   
    override public func setTitle(title: String!, forState state: UIControlState) {
        self.storeValue(title, onDic: self.texts, state: state)
        if super.titleForState(state) != title {
            super.setTitle(title, forState: state)
        }
        self.setNeedsLayout()
    }
    
    override public func titleForState(state: UIControlState) -> String?  {
        return self.getValueForControlState(self.texts, state: state) as? String
    }
    
    override public func setImage(image: UIImage!, forState state: UIControlState) {
        self.storeValue(image, onDic: self.imagens, state: state)
        if super.imageForState(state) != image {
            super.setImage(image, forState: state)
        }
        self.setNeedsLayout()
    }
    
    override public func imageForState(state: UIControlState) -> UIImage? {
        return self.getValueForControlState(self.imagens, state: state) as? UIImage
    }
    
    
    // MARK: -  Private Methods
    
    private func addObserver(forKeyPath keyPath:String) {
        self.addObserver(self, forKeyPath:keyPath, options: ([NSKeyValueObservingOptions.Initial, NSKeyValueObservingOptions.New]), context: nil)
    }
    
    private func removeObserver(forKeyPath keyPath: String!) {
        self.removeObserver(self, forKeyPath: keyPath)
    }
    
    private func getValueForControlState(dic:NSMutableDictionary!, state:UIControlState) -> AnyObject? {
        let value:AnyObject? =  dic.valueForKey("\(state.rawValue)");//  dic["\(state)"];
        if (value != nil) {
            return value;
        }
        //        value = dic["\(UIControlState.Selected.rawValue)"];
        //        if ( (state & UIControlState.Selected) && value) {
        //            return value;
        //        }
        //
        //        value = dic["\(UIControlState.Highlighted.rawValue)"];
        //
        //        if ( (state & UIControlState.Selected) && value != nil) {
        //            return value;
        //        }
        
        return dic["\(UIControlState.Normal.rawValue)"];
    }
    
    
    private func configureControlState(state:UIControlState) {
        if self.loading {
            self.activityIndicatorView.startAnimating();
            if self.hideImageWhenLoading {
                
                var imgTmp:UIImage? = nil
                
                if let img = self.imageForState(UIControlState.Normal) {
                    imgTmp = self.clearImage(img.size, scale: img.scale)
                }
                
                super.setImage(imgTmp, forState: UIControlState.Normal)
                super.setImage(imgTmp, forState: UIControlState.Selected)
                
                super.setImage(imgTmp, forState: state)
                super.imageView?.image = imgTmp
                
            }
            else {
                super.setImage( self.imageForState(state), forState: state)
            }
            
            if (self.hideTextWhenLoading) {
                super.setTitle(nil, forState: state)
                super.titleLabel?.text = nil
            }
            else {
                super.setTitle( self.titleForState(state) , forState: state)
                super.titleLabel?.text = self.titleForState(state)
            }
        }
        else {
            self.activityIndicatorView.stopAnimating();
            super.setImage(self.imageForState(state), forState: state)
            super.imageView?.image = self.imageForState(state)
            super.setTitle(self.titleForState(state), forState: state)
            super.titleLabel?.text = self.titleForState(state)
        }
        
        self.setNeedsLayout()
    }
    
    private func frameForActivityIndicator() -> CGRect {
        
        var frame:CGRect = CGRectZero;
        frame.size = self.activityIndicatorView.frame.size;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
        
        switch self.activityIndicatorAlignment {
            
        case RNActivityIndicatorAlignment.Left:
            // top,  left bottom right
            frame.origin.x += self.activityIndicatorEdgeInsets.left;
            frame.origin.y += self.activityIndicatorEdgeInsets.top;
        
        case RNActivityIndicatorAlignment.Center:
            frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
       
        case RNActivityIndicatorAlignment.Right:
            var lengthOccupied:CFloat = 0;
            var x:CFloat = 0;
            let imageView:UIImageView = self.imageView!;
            let titleLabel:UILabel = self.titleLabel!;
            
            //let xa = CGFloat(UInt(arc4random_uniform(UInt32(UInt(imageView.frame.size.width) * 5))))// - self.gameView.bounds.size.width * 2
            
            if (imageView.image != nil && titleLabel.text != nil){
                lengthOccupied = Float( imageView.frame.size.width + titleLabel.frame.size.width );
                
                
                if (imageView.frame.origin.x > titleLabel.frame.origin.x){
                    lengthOccupied += Float( imageView.frame.origin.x )
                }
                else {
                    lengthOccupied += Float( titleLabel.frame.origin.x )
                }
            }
            else if (imageView.image != nil){
                lengthOccupied = Float( imageView.frame.size.width + imageView.frame.origin.x )
            }
            else if (titleLabel.text != nil){
                lengthOccupied = Float( titleLabel.frame.size.width + imageView.frame.origin.x )
            }
            
            x =  Float(lengthOccupied) + Float( self.activityIndicatorEdgeInsets.left )
            if ( Float(x) + Float(frame.size.width) > Float(self.frame.size.width) ){
                x = Float(self.frame.size.width) - Float(frame.size.width + self.activityIndicatorEdgeInsets.right);
            }
            else if ( Float(x + Float(frame.size.width) ) > Float(self.frame.size.width - self.activityIndicatorEdgeInsets.right)){
                x = Float(self.frame.size.width) - ( Float(frame.size.width) + Float(self.activityIndicatorEdgeInsets.right) );
            }

            frame.origin.x = CGFloat(x);
        }
        
        return frame;
    }
    
    
    // UIImage clear
    private func clearImage(size:CGSize, scale:CGFloat) ->UIImage {
        UIGraphicsBeginImageContext(size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
        
        UIGraphicsPopContext()
        let outputImage:UIImage  = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return  UIImage(CGImage: outputImage.CGImage!, scale: scale, orientation: UIImageOrientation.Up)
    }
    
    
    /** Store values */
    /** Value in Dictionary on ControlState */
    private func storeValue(value:AnyObject?, onDic:NSMutableDictionary!, state:UIControlState) {
        if let _value: AnyObject = value  {
            onDic.setValue(_value, forKey: "\(state.rawValue)")
        }
        else {
            onDic.removeObjectForKey("\(state.rawValue)")
        }
        self.configureControlState(self.currentControlState())
    }
    
    
    // MARK: - KVO - Key-value Observer
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        configureControlState(currentControlState());
    }
    
}

