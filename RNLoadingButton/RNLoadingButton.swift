//
//  RNLoadingButton.swift
//  RNLoadingButton
//
//  Created by Romilson Nunes on 06/06/14.
//  Copyright (c) 2014 Romilson Nunes. All rights reserved.
//
import UIKit
@objc public enum RNActivityIndicatorAlignment: Int {
    case left
    case center
    case right
    
    static func Random() ->RNActivityIndicatorAlignment {
        let max = UInt32(RNActivityIndicatorAlignment.right.rawValue)
        let randomValue = Int(arc4random_uniform(max + 1))
        return RNActivityIndicatorAlignment(rawValue: randomValue)!
    }
}


@IBDesignable
open class RNLoadingButton: UIButton {
    
    // Loading state
    @IBInspectable
    open var isLoading: Bool = false {
        didSet {            
            #if !TARGET_INTERFACE_BUILDER
                configureControl(for: currentControlState())
            #else
                self.setNeedsDisplay()
            #endif
        }
    }
    
    /// Hide image when loading is visible.
    @IBInspectable open var hideImageWhenLoading: Bool = true {
        didSet {
            configureControl(for: currentControlState())
        }
    }
    
    /// Hide text when loading is visible.
    @IBInspectable open var hideTextWhenLoading: Bool = true {
        didSet {
            configureControl(for: currentControlState())
        }
    }
    
    /// Edge Insets to set activity indicator frame. Default is .zero
    open var activityIndicatorEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero
    
    /// Activity Indicator Alingment. Default is '.center'
    @IBInspectable open var activityIndicatorAlignment: RNActivityIndicatorAlignment = .center {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Activity Indicator style. Default is '.gray'
    open var activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color to activityIndicatorView. Default is 'nil'
    @IBInspectable open var activityIndicatorColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }

    
    // Internal properties
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    typealias ControlStateDictionary = [UInt: Any]
    
    fileprivate var imagens = ControlStateDictionary()
    fileprivate var titles = ControlStateDictionary()
    fileprivate var attributedTitles = ControlStateDictionary()
    
    
    // MARK: - Initializers
    
    #if !TARGET_INTERFACE_BUILDER

    deinit {
        self.removeObservers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupActivityIndicator()
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        setupActivityIndicator()
        
        let states: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
        
        /// Store default values
        _ = states.map({
            
            // Images - Icons
            if let imageForState = super.image(for: $0) {
                self.store(imageForState, in: &self.imagens, for: $0)
            }
            
            // Title - Texts
            if let titleForState = super.title(for: $0) {
                self.store(titleForState, in: &self.titles, for: $0)
            }
            
            // Attributed Title - Texts
            if let attributedTitle = super.attributedTitle(for: $0) {
                self.store(attributedTitle, in: &self.attributedTitles, for: $0)
            }
            
        })
        
        configureControl(for: currentControlState())
    }
    
    #endif

    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        #if !TARGET_INTERFACE_BUILDER
            // this code will run in the app itself
        #else
            // this code will execute only in IB
            self.setupActivityIndicator()
            commonInit()
        #endif
    }
    
    
    // MARK: - Initializers Helpers
    
    fileprivate func commonInit() {
        self.adjustsImageWhenHighlighted = true
        self.storeDefaultValues()
        #if !TARGET_INTERFACE_BUILDER
            self.addObservers()
        #endif
    }
    
    fileprivate func storeDefaultValues() {
        let states: [UIControlState] = [.normal, .highlighted, .disabled, .selected]
        _ = states.map({
            // Images for State
            self.imagens[$0.rawValue] = super.image(for: $0)
            
            // Title for States
            self.titles[$0.rawValue] = super.title(for: $0)
            
            /// Attributed Title for States
            self.attributedTitles[$0.rawValue] = super.attributedTitle(for: $0)
        })
    }
    
    // MARK: - Relayout
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.activityIndicatorView.activityIndicatorViewStyle = self.activityIndicatorViewStyle
        self.activityIndicatorView.color = self.activityIndicatorColor
        self.activityIndicatorView.frame = self.frameForActivityIndicator()
        self.bringSubview(toFront: self.activityIndicatorView)
    }

    
    // MARK: - Internal Methods
    
    fileprivate func setupActivityIndicator() {
        self.activityIndicatorView.hidesWhenStopped = true
        self.activityIndicatorView.startAnimating()
        self.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.isUserInteractionEnabled = false
    }
    
    fileprivate  func currentControlState() -> UIControlState {
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
    
    fileprivate func setControlState(_ value: AnyObject, dic: inout ControlStateDictionary, state: UIControlState) {
        dic[state.rawValue] = value
        configureControl(for: currentControlState())
    }
    
    fileprivate func setImage(_ image:UIImage, state:UIControlState) {
        setControlState(image, dic: &self.imagens, state: state)
    }
    
    
    // MARK: - Override Setters & Getters
    
    override open func setTitle(_ title: String?, for state: UIControlState) {
        self.store(title, in: &self.titles, for: state)
        if super.title(for: state) != title {
            super.setTitle(title, for: state)
        }
        self.setNeedsLayout()
    }
    
    open override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState) {
        self.store(title, in: &self.attributedTitles, for: state)
        if super.attributedTitle(for: state) != title {
            super.setAttributedTitle(title, for: state)
        }
        self.setNeedsLayout()
    }
    
    override open func setImage(_ image: UIImage?, for state: UIControlState) {
        self.store(image, in: &self.imagens, for: state)
        if super.image(for: state) != image {
            super.setImage(image, for: state)
        }
        self.setNeedsLayout()
    }
    
    override open func title(for state: UIControlState) -> String?  {
        return getValueFrom(type: String.self, on: self.titles, for: state)
    }
    
    open override func attributedTitle(for state: UIControlState) -> NSAttributedString? {
        return getValueFrom(type: NSAttributedString.self, on: self.attributedTitles, for: state)
    }
    
    override open func image(for state: UIControlState) -> UIImage? {
        return getValueFrom(type: UIImage.self, on: self.imagens, for: state)
    }
    
    
    // MARK: -  Private Methods
    
    fileprivate func configureControl(for state: UIControlState) {
        if self.isLoading {
            self.activityIndicatorView.startAnimating()
            
            if self.hideImageWhenLoading {
                
                var imgTmp:UIImage? = nil
                if let img = self.image(for: UIControlState.normal) {
                    imgTmp = UIImage.clearImage(size: img.size, scale: img.scale)
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
                super.setAttributedTitle(nil, for: state)
                super.titleLabel?.text = nil
            } else {
                super.setTitle( self.title(for: state) , for: state)
                super.titleLabel?.text = self.title(for: state)
                super.setAttributedTitle(self.attributedTitle(for: state), for: state)
            }
            
        } else {
            self.activityIndicatorView.stopAnimating()
            super.setImage(self.image(for: state), for: state)
            super.imageView?.image = self.image(for: state)
            super.setTitle(self.title(for: state), for: state)
            super.titleLabel?.text = self.title(for: state)
            super.setAttributedTitle(self.attributedTitle(for: state), for: state)
        }
        
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    fileprivate func frameForActivityIndicator() -> CGRect {
        
        var frame:CGRect = CGRect.zero
        frame.size = self.activityIndicatorView.frame.size
        frame.origin.y = (self.frame.size.height - frame.size.height) / 2
        
        switch self.activityIndicatorAlignment {
            
        case .left:
            // top,  left bottom right
            frame.origin.x += self.activityIndicatorEdgeInsets.left
            frame.origin.y += self.activityIndicatorEdgeInsets.top
            
        case .center:
            frame.origin.x = (self.frame.size.width - frame.size.width) / 2
            
        case .right:
            var lengthOccupied:CFloat = 0
            var x:CFloat = 0
            let imageView:UIImageView = self.imageView!
            let titleLabel:UILabel = self.titleLabel!
            
            //let xa = CGFloat(UInt(arc4random_uniform(UInt32(UInt(imageView.frame.size.width) * 5))))// - self.gameView.bounds.size.width * 2
            
            if (imageView.image != nil && titleLabel.text != nil) {
                lengthOccupied = Float( imageView.frame.size.width + titleLabel.frame.size.width )
                
                if (imageView.frame.origin.x > titleLabel.frame.origin.x) {
                    lengthOccupied += Float( imageView.frame.origin.x )
                }
                else {
                    lengthOccupied += Float( titleLabel.frame.origin.x )
                }
            }
            else if (imageView.image != nil) {
                lengthOccupied = Float( imageView.frame.size.width + imageView.frame.origin.x )
            }
            else if (titleLabel.text != nil) {
                lengthOccupied = Float( titleLabel.frame.size.width + imageView.frame.origin.x )
            } else if (attributedTitle(for: currentControlState()) != nil){
                let attributedString = attributedTitle(for: currentControlState())
                lengthOccupied = Float(attributedString!.size().width)
            }
            
            x =  Float(lengthOccupied) + Float( self.activityIndicatorEdgeInsets.left )
            if ( Float(x) + Float(frame.size.width) > Float(self.frame.size.width) ) {
                x = Float(self.frame.size.width) - Float(frame.size.width + self.activityIndicatorEdgeInsets.right)
            }
            else if ( Float(x + Float(frame.size.width) ) > Float(self.frame.size.width - self.activityIndicatorEdgeInsets.right)) {
                x = Float(self.frame.size.width) - ( Float(frame.size.width) + Float(self.activityIndicatorEdgeInsets.right) )
            } else {
                // default to placing the indicator at 3/4 the buttons length, making sure it doesn't touch the button content
                let contentRightEdge = (lengthOccupied / 2) + (Float(self.frame.width) / 2)
                let threeFourthsButtonWidth = 3 * (Float(self.frame.width) / 4)
                x = max(contentRightEdge, threeFourthsButtonWidth)
            }
            
            frame.origin.x = CGFloat(x)
        }
        
        return frame
    }
    
    // MARK: -  Store and recorver values
    /** Value in Dictionary for control State */
    
    fileprivate func getValueFrom<T>(type: T.Type, on dic: ControlStateDictionary, for state: UIControlState) -> T? {
        if let value =  dic[state.rawValue] as? T {
            return value
        }
        return dic[UIControlState.normal.rawValue] as? T
    }
    
    fileprivate func store<T>(_ value: T?, in dic: inout ControlStateDictionary, for state: UIControlState) {
        if let _value = value as AnyObject?  {
            dic[state.rawValue] = _value
        }
        else {
            dic.removeValue(forKey: state.rawValue)
        }
    }
    
    
    // MARK: - KVO - Key-value Observer
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        configureControl(for: currentControlState())
    }
    
}

// MARK: - Observer

fileprivate extension RNLoadingButton {
    
    fileprivate func addObservers() {
        self.addObserver(forKeyPath: "self.state")
        self.addObserver(forKeyPath: "self.selected")
        self.addObserver(forKeyPath: "self.highlighted")
    }
    
    fileprivate func removeObservers() {
        self.removeObserver(forKeyPath: "self.state")
        self.removeObserver(forKeyPath: "self.selected")
        self.removeObserver(forKeyPath: "self.highlighted")
    }
    
    fileprivate func addObserver(forKeyPath keyPath:String) {
        self.addObserver(self, forKeyPath:keyPath, options: ([NSKeyValueObservingOptions.initial, NSKeyValueObservingOptions.new]), context: nil)
    }
    
    fileprivate func removeObserver(forKeyPath keyPath: String!) {
        self.removeObserver(self, forKeyPath: keyPath)
    }
}


// MARK: - UIImage

fileprivate extension UIImage {
    
    /// UIImage clear
    static func clearImage(size: CGSize, scale: CGFloat) -> UIImage {
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
}
