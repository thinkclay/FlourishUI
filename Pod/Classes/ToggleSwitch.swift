import UIKit

public class ToggleButton: UIView
{
  
  var active: Bool = false
  
  public var activeBackgroundColor = UIColor(hex: "#6B60AB") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var activeBorderColor = UIColor(hex: "#8579CE") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var activeInnerShadowColor = UIColor(rgba: [255, 255, 255, 0.5]) {
    didSet {
      setNeedsDisplay()
    }
  }
  public var disabledBackgroundColor = UIColor(hex: "#4D428E") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var disabledBorderColor = UIColor(hex: "#5C509D") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var disabledInnerShadowColor = UIColor(rgba: [255, 255, 255, 0.14]) {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect)
  {
    super.init(frame: frame)
    
    backgroundColor = .clear
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func draw(_ rect: CGRect)
  {
    let buttonFill = active ? activeBackgroundColor : disabledBackgroundColor
    let buttonStroke = active ? activeBorderColor : disabledBorderColor
    let innerShadow = active ? activeInnerShadowColor : disabledInnerShadowColor
    let x: CGFloat = active ? 35 : 0
    let context = UIGraphicsGetCurrentContext()!
    
    // Oval with drop shadow
    let ovalPath = UIBezierPath(ovalIn: CGRect(x: 2, y: 1, width: 20, height: 20))
    context.saveGState()
    context.setShadow(offset: CGSize(width: 0.1, height: -0.1), blur: 2, color: UIColor.black.cgColor)
    buttonFill.setFill()
    ovalPath.fill()
    
    // Inner shadow
    context.saveGState()
    context.clip(to: ovalPath.bounds)
    context.setShadow(offset: CGSize.zero, blur: 0)
    context.setAlpha(innerShadow.cgColor.alpha)
    context.beginTransparencyLayer(auxiliaryInfo: nil)
    context.setShadow(offset: CGSize(width: 0.1, height: 1), blur: 3, color: UIColor.white.cgColor)
    context.setBlendMode(.sourceOut)
    context.beginTransparencyLayer(auxiliaryInfo: nil)
    
    let ovalOpaqueShadow = innerShadow.withAlphaComponent(1)
    ovalOpaqueShadow.setFill()
    ovalPath.fill()
    
    context.endTransparencyLayer()
    context.endTransparencyLayer()
    context.restoreGState()
    context.restoreGState()
    
    buttonStroke.setStroke()
    ovalPath.lineWidth = 1
    ovalPath.stroke()
    
    frame.origin.x = x
  }
}

public class ToggleSlide: UIView
{
  
  var active: Bool = false
  
  public var activeBackgroundColor = UIColor(hex: "#514398") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var activeBorderColor = UIColor(hex: "#5B4CA9") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var disabledBackgroundColor = UIColor(hex: "#382B76") {
    didSet {
      setNeedsDisplay()
    }
  }
  public var disabledBorderColor = UIColor(hex: "#4B3E8D") {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override init(frame: CGRect)
  {
    super.init(frame: frame)
    
    backgroundColor = .clear
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func draw(_ rect: CGRect)
  {
    let slideFill = active ? activeBackgroundColor : disabledBackgroundColor
    let slideStroke = active ? activeBorderColor : disabledBorderColor
    let background = UIBezierPath(roundedRect: CGRect(x: 1, y: 7, width: 48, height: 10), cornerRadius: 10)
    background.lineWidth = 1
    slideFill.setFill()
    background.fill()
    slideStroke.setStroke()
    background.stroke()
  }
}

public class ToggleLabel: UIButton
{
  override init(frame: CGRect)
  {
    super.init(frame: frame)
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
}

open class ToggleSwitch: UIView
{
  public var active: Bool = false {
    didSet {
      button.active = active
      slide.active = active
      button.setNeedsDisplay()
      slide.setNeedsDisplay()
    }
  }
  public var button = ToggleButton(frame: CGRect(x: 0, y: 1, width: 24, height: 24))
  public var slide = ToggleSlide(frame: CGRect(x: 4, y: 0, width: 60, height: 20))
  public var label = ToggleLabel(frame: CGRect(x: 70, y: 0, width: 100, height: 22))
  public var toggleCallback: (() -> ())?
  
  override public init(frame: CGRect)
  {
    super.init(frame: frame)
    
    backgroundColor = .clear
    
    toggleCallback = { print("toggle init") }
    
    button.active = active
    slide.active = active
    
    addSubview(slide)
    addSubview(button)
    addSubview(label)
    
    label.addTarget(self, action: #selector(toggleHandler), for: .touchUpInside)
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHandler)))
    addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(toggleHandler)))
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func toggleHandler()
  {
    UIView.animate(
      withDuration: 0.15,
      delay: 0.0,
      options: .curveEaseIn,
      animations: {
        self.button.frame.origin.x = self.active ? 0 : 35
    },
      completion: {
        _ in
        self.active = !self.active
        self.toggleCallback!()
    }
    )
  }
  
}
