//
//  RNLoadingButton.swift
//  RNLoadingButton
//
//  Created by Romilson Nunes on 06/06/14.
//  Copyright (c) 2014 Romilson Nunes. All rights reserved.
//

import UIKit
public enum RNActivityIndicatorAlignment: Int {
    case left
    case center
    case right
    
    static func Random() ->RNActivityIndicatorAlignment {
        let max = UInt32(RNActivityIndicatorAlignment.right.rawValue)
        let randomValue = Int(arc4random_uniform(max + 1))
        return RNActivityIndicatorAlignment(rawValue: randomValue)!
    }
}


public class RNLoadingButton: UIButton {
    
    /** Loading */
    public var isLoading: Bool = false {
        didSet {
            configureControl(state: currentControlState());
        }
    }

    public var hideImageWhenLoading: Bool = true {
        didSet {
            configureControl(state: currentControlState());
        }
    }
    public var hideTextWhenLoading: Bool = true {
        didSet {
            configureControl(state: currentControlState());
        }
    }
    
    public var activityIndicatorEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    /** Loading Alingment */
    public var activityIndicatorAlignment = RNActivityIndicatorAlignment.center {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    // Internal properties
    let imagens = NSMutableDictionary()
    let texts = NSMutableDictionary()
    let indicatorStyles = NSMutableDictionary()
    
    // Static
    let defaultActivityStyle = UIActivityIndicatorViewStyle.gray

    
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
        if (super.image(for: UIControlState.normal) != nil) {
            self.store(value: super.image(for: UIControlState.normal), onDic: imagens, state: UIControlState.normal)
        }
        if (super.image(for: UIControlState.highlighted) != nil) {
            self.store(value: super.image(for: UIControlState.highlighted), onDic: imagens, state: UIControlState.highlighted)
        }
        if (super.image(for: UIControlState.disabled) != nil) {
            self.store(value: super.image(for: UIControlState.disabled), onDic: imagens, state: UIControlState.disabled)
        }
        if (super.image(for: UIControlState.selected) != nil) {
            self.store(value: super.image(for: UIControlState.selected), onDic: imagens, state: UIControlState.selected)
        }
        
        // Title - Texts
        if let titleNormal = super.title(for: .normal) {
            self.store(value:titleNormal as AnyObject?, onDic: texts, state: .normal)
        }
        if let titleHighlighted = super.title(for: .highlighted) {
            self.store(value: titleHighlighted as AnyObject?, onDic: texts, state: .highlighted)
        }
        if let titleDisabled = super.title(for: .disabled) {
            self.store(value: titleDisabled as AnyObject?, onDic: texts, state: .disabled)
        }
        if let titleSelected = super.title(for: .selected) {
            self.store(value: titleSelected as AnyObject?, onDic: texts, state: .selected)
        }
        
    }
    
    private func commonInit() {
        
        self.adjustsImageWhenHighlighted = true
        
        /** Title for States */
        self.texts.setValue(super.title(for: .normal), forKey: "\(UIControlState.normal.rawValue)")
        self.texts.setValue(super.title(for: .highlighted), forKey: "\(UIControlState.highlighted.rawValue)")
        self.texts.setValue(super.title(for: .disabled), forKey: "\(UIControlState.disabled.rawValue)")
        self.texts.setValue(super.title(for: .selected), forKey: "\(UIControlState.selected.rawValue)")
        
        /** Images for States */
        self.imagens.setValue(super.image(for: .normal), forKey: "\(UIControlState.normal.rawValue)")
        self.imagens.setValue(super.image(for: .highlighted), forKey: "\(UIControlState.highlighted.rawValue)")
        self.imagens.setValue(super.image(for: .disabled), forKey: "\(UIControlState.disabled.rawValue)")
        self.imagens.setValue(super.image(for: .selected), forKey: "\(UIControlState.selected.rawValue)")
        
        /** Indicator Styles for States */
        let s = NSNumber(value: defaultActivityStyle.rawValue)
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.normal.rawValue)")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.highlighted.rawValue)")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.disabled.rawValue)")
        self.indicatorStyles.setValue(s, forKey: "\(UIControlState.selected.rawValue)")
        
        self.addObserver(forKeyPath: "self.state")
        self.addObserver(forKeyPath: "self.selected")
        self.addObserver(forKeyPath: "self.highlighted")
    }
    
    
    // MARK: - Relayout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let style = self.activityIndicatorStyle(for: self.currentControlState())
        self.activityIndicatorView.activityIndicatorViewStyle = style
        self.activityIndicatorView.frame = self.frameForActivityIndicator()
        self.bringSubview(toFront: self.activityIndicatorView)
    }
    
    // MARK: - Public Methods
    
    public func setActivityIndicatorStyle(_ style:UIActivityIndicatorViewStyle, for state:UIControlState) {
        let s:NSNumber = NSNumber(value: style.rawValue);
        setControlState(s, dic: indicatorStyles, state: state)
        self.setNeedsLayout()
    }
    
    // Activity Indicator Alignment
    public func setActivityIndicatorAlignment(_ alignment: RNActivityIndicatorAlignment) {
        activityIndicatorAlignment = alignment;
        self.setNeedsLayout();
    }
    
    public func activityIndicatorStyle(for state: UIControlState) -> UIActivityIndicatorViewStyle {
        var style:UIActivityIndicatorViewStyle  = defaultActivityStyle
        if let styleObj: AnyObject = self.getValueForControlState(dic: self.indicatorStyles, state: state)
        {
            // https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/Enumerations.html
            style = UIActivityIndicatorViewStyle(rawValue: (styleObj as! NSNumber).intValue)!
        }
        return style
    }
    
    
    // MARK: - Targets/Actions
    
    func activityIndicatorTapped(sender:AnyObject) {
        self.sendActions(for: UIControlEvents.touchUpInside)
    }
    
    
    // MARK: - Internal Methods
    
    func setupActivityIndicator() {
        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.startAnimating()
        self.addSubview(self.activityIndicatorView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RNLoadingButton.activityIndicatorTapped(sender:)))
        self.activityIndicatorView.addGestureRecognizer(tap)
    }
    
    func currentControlState() -> UIControlState {
        var controlState = UIControlState.normal.rawValue
        if self.isSelected {
            controlState += UIControlState.selected.rawValue
        }
        if self.isHighlighted {
            controlState += UIControlState.highlighted.rawValue
        }
        if !self.isEnabled {
            controlState += UIControlState.disabled.rawValue
        }
        return UIControlState(rawValue: controlState)
    }
    
    func setControlState(_ value: AnyObject, dic:NSMutableDictionary, state:UIControlState) {
        dic["\(state.rawValue)"] = value
        configureControl(state: currentControlState())
    }
    
    func setImage(_ image:UIImage, state:UIControlState) {
        setControlState(image, dic: self.imagens, state: state)
    }
    

    // MARK: - Override Setters & Getters
   
    override public func setTitle(_ title: String!, for state: UIControlState) {
        self.store(value: title as AnyObject?, onDic: self.texts, state: state)
        if super.title(for: state) != title {
            super.setTitle(title, for: state)
        }
        self.setNeedsLayout()
    }
    
    override public func title(for state: UIControlState) -> String?  {
        return self.getValueForControlState(dic: self.texts, state: state) as? String
    }
    
    override public func setImage(_ image: UIImage!, for state: UIControlState) {
        self.store(value: image, onDic: self.imagens, state: state)
        if super.image(for: state) != image {
            super.setImage(image, for: state)
        }
        self.setNeedsLayout()
    }
    
    override public func image(for state: UIControlState) -> UIImage? {
        return self.getValueForControlState(dic: self.imagens, state: state) as? UIImage
    }
    
    
    // MARK: -  Private Methods
    
    private func addObserver(forKeyPath keyPath:String) {
        self.addObserver(self, forKeyPath:keyPath, options: ([NSKeyValueObservingOptions.initial, NSKeyValueObservingOptions.new]), context: nil)
    }
    
    private func removeObserver(forKeyPath keyPath: String!) {
        self.removeObserver(self, forKeyPath: keyPath)
    }
    
    private func getValueForControlState(dic: NSMutableDictionary!, state:UIControlState) -> AnyObject? {

        if let value =  dic.value(forKey: "\(state.rawValue)") as AnyObject? {
            return value
        }

        return dic.value(forKey: "\(UIControlState.normal.rawValue)") as AnyObject? // dic["\(UIControlState.normal.rawValue)"];
    }
    
    
    private func configureControl(state: UIControlState) {
        if self.isLoading {
            self.activityIndicatorView.startAnimating();
           
            if self.hideImageWhenLoading {
                
                var imgTmp:UIImage? = nil
                if let img = self.image(for: UIControlState.normal) {
                    imgTmp = self.clearImage(size: img.size, scale: img.scale)
                }
                
                super.setImage(imgTmp, for: UIControlState.normal)
                super.setImage(imgTmp, for: UIControlState.selected)
                
                super.setImage(imgTmp, for: state)
                super.imageView?.image = imgTmp
                
            } else {
                super.setImage( self.image(for: state), for: state)
            }
            
            if (self.hideTextWhenLoading) {
                super.setTitle(nil, for: state)
                super.titleLabel?.text = nil
            } else {
                super.setTitle( self.title(for: state) , for: state)
                super.titleLabel?.text = self.title(for: state)
            }
            
        } else {
            self.activityIndicatorView.stopAnimating();
            super.setImage(self.image(for: state), for: state)
            super.imageView?.image = self.image(for: state)
            super.setTitle(self.title(for: state), for: state)
            super.titleLabel?.text = self.title(for: state)
        }
        
        self.setNeedsLayout()
    }
    
    private func frameForActivityIndicator() -> CGRect {
        
        var frame:CGRect = CGRect.zero;
        frame.size = self.activityIndicatorView.frame.size;
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2;
        
        switch self.activityIndicatorAlignment {
            
        case .left:
            // top,  left bottom right
            frame.origin.x += self.activityIndicatorEdgeInsets.left;
            frame.origin.y += self.activityIndicatorEdgeInsets.top;
        
        case .center:
            frame.origin.x = (self.frame.size.width - frame.size.width) / 2;
       
        case .right:
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
            } else {
                // default to placing the indicator at 3/4 the buttons length, making sure it doesn't touch the button content
                let contentRightEdge = (lengthOccupied / 2) + (Float(frame.width) / 2)
                let threeFourthsButtonWidth = 3 * (Float(frame.width) / 4)
                x = max(contentRightEdge, threeFourthsButtonWidth)
            }

            frame.origin.x = CGFloat(x)
        }
        
        return frame;
    }
    
    
    // UIImage clear
    private func clearImage(size: CGSize, scale: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        UIGraphicsPopContext()
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        UIGraphicsEndImageContext()
        
        return  UIImage(cgImage: outputImage.cgImage!, scale: scale, orientation: UIImageOrientation.up)
    }
    
    /** Store values */
    /** Value in Dictionary on ControlState */
    private func store(value:AnyObject?, onDic:NSMutableDictionary!, state:UIControlState) {
        if let _value: AnyObject = value  {
            onDic.setValue(_value, forKey: "\(state.rawValue)")
        }
        else {
            onDic.removeObject(forKey: "\(state.rawValue)")
        }
        self.configureControl(state: self.currentControlState())
    }
    
    
    // MARK: - KVO - Key-value Observer
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        configureControl(state: currentControlState());
    }
    
    
}

