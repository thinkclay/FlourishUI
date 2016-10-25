import UIKit

class ToggleButton: UIView
{
  
  var active: Bool = false
  
  override init(frame: CGRect)
  {
    super.init(frame: frame)
    
    backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect)
  {
    var buttonFill: UIColor
    var buttonStroke: UIColor
    var innerShadow: UIColor
    
    if active
    {
      buttonFill = UIColor(hex: "#6B60AB")
      buttonStroke = UIColor(hex: "#8579CE")
      innerShadow = UIColor(rgba: [255, 255, 255, 0.5])
    }
    else
    {
      buttonFill = UIColor(hex: "#4D428E")
      buttonStroke = UIColor(hex: "#5C509D")
      innerShadow = UIColor(rgba: [255, 255, 255, 0.14])
    }
    
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
  }
}

class ToggleSlide: UIView
{
  
  var active: Bool = false
  
  override init(frame: CGRect)
  {
    super.init(frame: frame)

    backgroundColor = .clear
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect)
  {
    var slideFill: UIColor
    var slideStroke: UIColor
    
    if active
    {
      slideFill = UIColor(hex: "#514398")
      slideStroke = UIColor(hex: "#5B4CA9")
    }
    else
    {
      slideFill = UIColor(hex: "#382B76")
      slideStroke = UIColor(hex: "#4B3E8D")
    }
    
    let background = UIBezierPath(roundedRect: CGRect(x: 1, y: 7, width: 48, height: 10), cornerRadius: 10)
    background.lineWidth = 1
    slideFill.setFill()
    background.fill()
    slideStroke.setStroke()
    background.stroke()
  }
}

open class ToggleSwitch: UIView
{
  var active: Bool = false
  var button = ToggleButton(frame: CGRect(x: 0, y: 1, width: 24, height: 24))
  var slide = ToggleSlide(frame: CGRect(x: 4, y: 0, width: 60, height: 20))

  override public init(frame: CGRect)
  {
    super.init(frame: frame)
    
    backgroundColor = .clear
    
    addSubview(slide)
    addSubview(button)
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleHandler)))
    addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(toggleHandler)))
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func toggleHandler()
  {
    active = !active
    
    button.active = !active
    slide.active = !active
    
    button.setNeedsDisplay()
    slide.setNeedsDisplay()
    
    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: .curveEaseInOut,
      animations: {
        self.button.frame.origin.x = self.active ? 0 : 35
      },
      completion: {
        _ in
      }
    )
  }
  
}
