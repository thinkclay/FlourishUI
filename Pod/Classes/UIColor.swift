import UIKit

public extension UIColor
{
  convenience init(hex: String)
  {
    var red:   CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue:  CGFloat = 0.0
    let alpha: CGFloat = 1.0
    
    if hex.hasPrefix("#")
    {
      let index   = hex.characters.index(hex.startIndex, offsetBy: 1)
      let hex     = hex.substring(from: index)
      let scanner = Scanner(string: hex)
      var hexValue: CUnsignedLongLong = 0
      
      if scanner.scanHexInt64(&hexValue)
      {
        red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
        green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
        blue  = CGFloat(hexValue & 0x0000FF) / 255.0
      }
      else
      {
        print("scan hex error, your string should be a hex string of 7 chars. ie: #ebb100")
      }
    }
    else
    {
      print("invalid rgb string, missing '#' as prefix", terminator: "")
    }
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  convenience init(rgba: [CGFloat])
  {
    self.init(red: rgba[0]/255.0, green: rgba[1]/255.0, blue: rgba[2]/255.0, alpha: rgba[3])
  }
  
  class func adjustValue(_ color: UIColor, percentage: CGFloat = 1.5) -> UIColor
  {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    
    return UIColor(hue: h, saturation: s, brightness: (b * percentage), alpha: a)
  }
}
