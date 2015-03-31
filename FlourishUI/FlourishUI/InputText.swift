import UIKit

@IBDesignable
public class InputText: UITextField
{
  @IBInspectable public var padding: CGSize = CGSize(width: 8, height: 5)
  @IBInspectable public var borderRadius = CGFloat(5)
  @IBInspectable public var borderColor = UIColor.lightGrayColor().CGColor
  @IBInspectable public var borderWidth = CGFloat(1)
  @IBInspectable public var icon = UIImage()
  
  override public func layoutSubviews()
  {
    super.layoutSubviews()
    
    layer.cornerRadius = borderRadius
    layer.borderColor = borderColor
    layer.borderWidth = borderWidth
  }
  
  override public func textRectForBounds(bounds: CGRect) -> CGRect
  {
    let rect = super.textRectForBounds(bounds)
    
    let newRect = CGRect(
      x: rect.origin.x + padding.width,
      y: rect.origin.y + padding.height,
      width: rect.size.width - (2 * padding.width),
      height: rect.size.height - (2 * padding.height)
    )
    
    return newRect
  }
  
  override public func editingRectForBounds(bounds: CGRect) -> CGRect {
    return textRectForBounds(bounds)
  }
}