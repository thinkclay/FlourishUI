import UIKit

@IBDesignable
open class InputText: UITextField
{

  @IBInspectable open var padding: CGSize = CGSize(width: 8, height: 5)
  @IBInspectable open var borderRadius = CGFloat(5)
  @IBInspectable open var borderColor = UIColor.lightGray.cgColor
  @IBInspectable open var borderWidth = CGFloat(1)
  @IBInspectable open var icon = UIImage()
  
  override open func layoutSubviews()
  {
    super.layoutSubviews()
    
    layer.cornerRadius = borderRadius
    layer.borderColor = borderColor
    layer.borderWidth = borderWidth
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect
  {
    let rect = super.textRect(forBounds: bounds)
    
    let newRect = CGRect(
      x: rect.origin.x + padding.width,
      y: rect.origin.y + padding.height,
      width: rect.size.width - (2 * padding.width),
      height: rect.size.height - (2 * padding.height)
    )
    
    return newRect
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }
  
}
