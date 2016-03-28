import UIKit

public class Modal: UIViewController
{
  private var _settings: Settings = Settings() {
    didSet {
      _height = _settings.height
      _bodyHeight = _settings.bodyHeight
    }
  }
  
  private var _overlay = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
  private var dialog = UIView()
  private var titleLabel = UILabel()
  private var bodyLabel = UITextView()
  private var dismissButton = ModalButton(frame: CGRect())
  private var status: Status = .Notice
  private var durationTimer: NSTimer!
  private var _bodyHeight: CGFloat = 90
  private var _height: CGFloat = 178

  var width: CGFloat {
    var width = (view.frame.width - 2 * _settings.padding)
    
    if _settings.equalAspectRatio
    {
      width = width > _height ? _height : width
    }
    
    return width <= _settings.maxWidth ? width : _settings.maxWidth
  }
  
  public enum Status
  {
    case Success, Error, Notice, Warning, Info
  }
  
  public enum Action
  {
    case None, Selector, Closure
  }
  
  public enum Shadow
  {
    case Normal, Curl, Hover
  }
  
  public struct Settings
  {
    public var backgroundColor: UIColor
    public var borderColor: UIColor
    public var equalAspectRatio: Bool
    public var borderRadius: CGFloat
    public var borderWidth: CGFloat
    public var height: CGFloat
    public var maxWidth: CGFloat
    public var titleHeight: CGFloat
    public var bodyHeight: CGFloat
    public var margin: CGFloat
    public var padding: CGFloat
    public var buttonHeight: CGFloat
    public var buttonCornerRadius: Float
    public var dismissText: String
    
    // Shadows
    public var shadowType: Shadow
    public var shadowColor: UIColor
    public var shadowOffset: CGSize
    public var shadowOpacity: Float
    public var shadowRadius: CGFloat
    
    // Overlay
    public var overlayColor: UIColor
    public var overlayBlurStyle: UIBlurEffectStyle
    
    // Colors
    public var titleColor: UIColor
    public var bodyColor: UIColor
    
    public init()
    {
      backgroundColor = .whiteColor()
      borderColor = .lightGrayColor()
      equalAspectRatio = false
      borderRadius = 5
      borderWidth = 0.5
      height = 178
      maxWidth = 300
      titleHeight = 40
      bodyHeight = 90
      margin = 20
      padding = 20
      buttonHeight = 40
      buttonCornerRadius = 3
      dismissText = "Close"
      shadowType = .Normal
      shadowColor = .blackColor()
      shadowOffset = CGSize(width: 0, height: 2)
      shadowOpacity = 0.2
      shadowRadius = 1
      overlayColor = .clearColor()
      overlayBlurStyle = .Light
      titleColor = .darkGrayColor()
      bodyColor = .grayColor()
    }
  }
  
  public struct Color
  {
    static var success = UIColor(red: 34/255, green: 181/255, blue: 115/255, alpha: 1)
    static var error = UIColor(red: 193/255, green: 39/255, blue: 45/255, alpha: 1)
    static var notice = UIColor(red: 200/255, green: 203/255, blue: 177/255, alpha: 1)
    static var warning = UIColor(red: 235/255, green: 177/255, blue: 0/255, alpha: 1)
    static var info = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 1)
  }
  
  public struct Font
  {
    static var header = UIFont(name: "Avenir-Medium", size: 18.0)!
    static var text = UIFont(name: "Avenir", size: 14.0)!
    static var button = UIFont(name: "Avenir-Roman", size: 14.0)!
  }
  
  class ModalButton: Button
  {
    var actionType = Action.None
    var target: AnyObject!
    var selector: Selector!
    var action:( () -> Void )!
  }
  
  required public init?(coder aDecoder: NSCoder)
  {
    fatalError("NSCoding not supported")
  }
  
  public init(title: String?, body: String?, status: Status, settings: Settings = Settings())
  {
    super.init(nibName: nil, bundle: nil)
    
    self.titleLabel.text = title
    self.bodyLabel.text = body
    self.status = status
    self._settings = settings
    self._overlay = UIVisualEffectView(effect: UIBlurEffect(style: _settings.overlayBlurStyle))
    
    // Set up main view
    view.frame = UIScreen.mainScreen().bounds
    view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    view.backgroundColor = _settings.overlayColor
    view.addSubview(_overlay)
    
    // Overlay
    _overlay.frame = view.frame
    _overlay.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    _overlay.addSubview(dialog)
    
    // Dialog
    dialog.backgroundColor = _settings.backgroundColor
    dialog.layer.borderColor = _settings.borderColor.CGColor
    dialog.layer.cornerRadius = _settings.borderRadius
    dialog.layer.masksToBounds = false
    dialog.layer.borderWidth = _settings.borderWidth
    
    // Title
    titleLabel.textColor = _settings.titleColor
    titleLabel.numberOfLines = 1
    titleLabel.textAlignment = .Center
    titleLabel.font = Font.header
    titleLabel.frame = CGRect(x: _settings.padding, y: _settings.padding, width: width - 2 * _settings.padding, height: _settings.titleHeight)
    dialog.addSubview(titleLabel)
    
    // Body
    bodyLabel.backgroundColor = UIColor.clearColor()
    bodyLabel.textColor = _settings.bodyColor
    bodyLabel.editable = false
    bodyLabel.textAlignment = .Center
    bodyLabel.textContainerInset = UIEdgeInsetsZero
    bodyLabel.textContainer.lineFragmentPadding = 0;
    bodyLabel.font = Font.text
    dialog.addSubview(bodyLabel)
    
    // Button
    dismissButton.setTitle(_settings.dismissText, forState: .Normal)
    dismissButton.titleLabel?.font = Font.button
    dismissButton.actionType = Action.Selector
    dismissButton.target = self
    dismissButton.selector = #selector(self.hide)
    dismissButton.addTarget(self, action: #selector(self.buttonTapped(_:)), forControlEvents: .TouchUpInside)
    dialog.addSubview(dismissButton)
  }
  
  
  override public func viewWillLayoutSubviews()
  {
    super.viewWillLayoutSubviews()
    
    var size = UIScreen.mainScreen().bounds.size
    
    if (UIDevice.currentDevice().systemVersion as NSString).floatValue < 8.0
    {
      // iOS versions before 7.0 did not switch the width and height on device roration
      if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
      {
        size = CGSize(width: size.height, height: size.width)
      }
    }
    
    // Set background frame
    view.frame.size = size
    _overlay.frame.size = size
    
    // Set frames
    addShadow(dialog, shadow: _settings.shadowType)
    dialog.frame.size = CGSize(width: width, height: _height)
    dialog.center.x = view.center.x
    dialog.center.y = view.center.y
    
    let x = _settings.padding
    let y = _settings.padding + _settings.titleHeight
    let w = width - (2 * _settings.padding)
    
    bodyLabel.frame = CGRect(x: x, y: y, width: w, height: _bodyHeight)
    dismissButton.frame = CGRect(x: x, y: y + _bodyHeight + _settings.padding, width: w, height: _settings.buttonHeight)
    dismissButton.backgroundColor = metaForStatus(status).color
    dismissButton.layer.masksToBounds = true
  }
  
  func buttonTapped(btn: ModalButton)
  {
    switch btn.actionType
    {
      case .Closure :
        btn.action()
      case .Selector :
        let ctrl = UIControl()
        ctrl.sendAction(btn.selector, to:btn.target, forEvent:nil)
      default :
        print("Unknow action type for button")
    }

    hide()
  }
  
  public func show(duration: NSTimeInterval = 0) -> Modal
  {
    view.alpha = 0
    dialog.frame.origin.y = -view.frame.height
    
    if let rv = UIApplication.sharedApplication().keyWindow?.subviews.first
    {
      rv.addSubview(view)
      view.frame = rv.bounds
      _overlay.frame = rv.bounds
          
      // Subtitle: adjusts to text view size
      let r = bodyLabel.text.boundingRectWithSize(CGSize(width: width - 2 * _settings.padding, height: 90),
        options: .UsesLineFragmentOrigin,
        attributes: [NSFontAttributeName: Font.text],
        context: nil)
      
      let textHeight = ceil(r.size.height)
      
      if textHeight < _bodyHeight
      {
        _height -= (_bodyHeight - textHeight)
        _bodyHeight = textHeight
      }
      
      _height += _settings.buttonHeight + _settings.padding
      
      if duration > 0
      {
        durationTimer?.invalidate()
        durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
      }
      
      // Animate the dialog
      UIView.animateWithDuration(0.2,
        animations: {
          self.dialog.center.y = rv.center.y + 15
          self.view.alpha = 1
        },
        completion: { finished in
          UIView.animateWithDuration(0.2, animations: { self.dialog.center = rv.center })
        }
      )
    }
    
    return self
  }
  
  public func hide()
  {
    UIView.animateWithDuration(0.2,
      animations: {
        self.view.alpha = 0
      },
      completion: { finished in
        self.view.removeFromSuperview()
      }
    )
  }
  
  public func addShadow(view: UIView, shadow: Shadow)
  {
    view.layer.shadowColor = _settings.shadowColor.CGColor
    view.layer.shadowOffset = _settings.shadowOffset
    view.layer.shadowOpacity = _settings.shadowOpacity
    view.layer.shadowRadius = _settings.shadowRadius
    
    switch shadow
    {
      case .Normal :
        addDropShadow(view)
      case .Curl :
        addCurlShadow(view)
      case .Hover :
        addHoverShadow(view)
    }
  }
  
  private func metaForStatus(status: Status) -> (text: String, color: UIColor)
  {
    switch status
    {
      case .Success :
        return ("Success", Color.success)

      case .Error :
        return ("Error", Color.error)
       
      case .Notice :
        return ("Notice", Color.notice)
        
      case .Warning :
        return ("Warning", Color.warning)
        
      case .Info :
        return ("Info", Color.info)
    }
  }
  
  private func addDropShadow(view: UIView) {}
  
  private func addCurlShadow(view: UIView)
  {
    let size = view.bounds.size
    let width = size.width
    let height = size.height
    let depth = CGFloat(11.0)
    let lessDepth = 0.8 * depth
    let curvyness = CGFloat(5)
    let radius = CGFloat(1)
    
    let path = UIBezierPath()
    
    // top left
    path.moveToPoint(CGPoint(x: radius, y: height))
    
    // top right
    path.addLineToPoint(CGPoint(x: width - 2 * radius, y: height))
    
    // bottom right + a little extra
    path.addLineToPoint(CGPoint(x: width - 2 * radius, y: height + depth))
    
    // path to bottom left via curve
    path.addCurveToPoint(CGPoint(x: radius, y: height + depth),
      controlPoint1: CGPoint(x: width - curvyness, y: height + lessDepth - curvyness),
      controlPoint2: CGPoint(x: curvyness, y: height + lessDepth - curvyness))
    
    view.layer.shadowPath = path.CGPath
  }
  
  private func addHoverShadow(view: UIView)
  {
    let ovalRect = CGRect(x: 10, y: _height + 15, width: width - 20, height: 15)
    let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
    
    view.layer.shadowPath = path.CGPath
  }
}
