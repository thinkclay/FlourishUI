import UIKit
import QuartzCore

@IBDesignable
open class Button: UIButton
{
  
  @IBInspectable open var ripplePercent: Float = 1 {
    didSet {
      updateUI()
    }
  }
  
  @IBInspectable open var rippleOverBounds: Bool = false
  
  @IBInspectable open var buttonCornerRadius: Float = 0 {
    didSet {
      layer.cornerRadius = CGFloat(buttonCornerRadius)
    }
  }
  
  @IBInspectable var shadowRippleRadius: Float = 1
  
  fileprivate let rippleForegroundView = UIView()
  fileprivate let rippleBackgroundView = UIView()
  fileprivate var tempShadowRadius: CGFloat = 0
  fileprivate var tempShadowOpacity: Float = 0
  
  fileprivate var rippleMask: CAShapeLayer? {
    get {
      if rippleOverBounds
      {
        return nil
      }
      else
      {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        return maskLayer
      }
    }
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  override public init(frame: CGRect)
  {
    super.init(frame: frame)
    setup()
  }
  
  fileprivate func setup()
  {
    updateUI()
    
    rippleOverBounds = false
    
    rippleBackgroundView.backgroundColor = backgroundColor
    rippleBackgroundView.frame = bounds
    layer.addSublayer(rippleBackgroundView.layer)
    rippleBackgroundView.layer.addSublayer(rippleForegroundView.layer)
    rippleBackgroundView.alpha = 0
    
    layer.shadowRadius = 0
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
  }
  
  fileprivate func updateUI()
  {
    let size: CGFloat = bounds.width * CGFloat(ripplePercent)
    let x: CGFloat = (bounds.width/2) - (size/2)
    let y: CGFloat = (bounds.height/2) - (size/2)
    let corner: CGFloat = size/2
    
    if let backgroundColor = backgroundColor
    {
      rippleForegroundView.backgroundColor = UIColor.adjustValue(backgroundColor, percentage: 1.1)
    }
    rippleForegroundView.frame = CGRect(x: x, y: y, width: size, height: size)
    rippleForegroundView.layer.cornerRadius = corner
  }
  
  override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
  {
    rippleForegroundView.center = touch.location(in: self)
    
    UIView.animate(withDuration: 0.1, animations: { self.rippleBackgroundView.alpha = 1 }, completion: nil)
    
    rippleForegroundView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        self.rippleForegroundView.transform = CGAffineTransform.identity
      },
      completion: nil
    )
    
    tempShadowRadius = layer.shadowRadius
    tempShadowOpacity = layer.shadowOpacity
    
    let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
    shadowAnim.toValue = shadowRippleRadius
    
    let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
    opacityAnim.toValue = 1
    
    let groupAnim = CAAnimationGroup()
    groupAnim.duration = 0.7
    groupAnim.fillMode = kCAFillModeForwards
    groupAnim.isRemovedOnCompletion = false
    groupAnim.animations = [shadowAnim, opacityAnim]
    
    layer.add(groupAnim, forKey:"shadow")
    
    return super.beginTracking(touch, with: event)
  }
  
  override open func endTracking(_ touch: UITouch?, with event: UIEvent?)
  {
    super.endTracking(touch, with: event)
    
    UIView.animate(
      withDuration: 0.1,
      animations: {
        self.rippleBackgroundView.alpha = 1
      },
      completion: {
        success in
        
        UIView.animate(withDuration: 0.6 , animations: { self.rippleBackgroundView.alpha = 0 })
      }
    )
    
    UIView.animate(
      withDuration: 0.7,
      delay: 0,
      options: [.curveEaseOut, .beginFromCurrentState],
      animations: {
        self.rippleForegroundView.transform = CGAffineTransform.identity
        
        let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
        shadowAnim.toValue = self.tempShadowRadius
        
        let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
        opacityAnim.toValue = self.tempShadowOpacity
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = 0.7
        groupAnim.fillMode = kCAFillModeForwards
        groupAnim.isRemovedOnCompletion = false
        groupAnim.animations = [shadowAnim, opacityAnim]
        
        self.layer.add(groupAnim, forKey:"shadowBack")
      },
      completion: nil
    )
  }
  
  override open func layoutSubviews()
  {
    super.layoutSubviews()
    
    let oldCenter = rippleForegroundView.center
    
    updateUI()
    
    rippleForegroundView.center = oldCenter
    rippleBackgroundView.layer.frame = bounds
    rippleBackgroundView.layer.mask = rippleMask
  }
  
}
