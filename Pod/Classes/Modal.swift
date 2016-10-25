import UIKit

open class Modal: UIViewController
{

  fileprivate var _settings: Settings = Settings() {
    didSet {
      _height = _settings.height
      _bodyHeight = _settings.bodyHeight
    }
  }
  
  fileprivate var _overlay = UIVisualEffectView(effect: UIBlurEffect(style: .light))
  fileprivate var dialog = UIView()
  fileprivate var titleLabel = UILabel()
  fileprivate var bodyLabel = UITextView()
  fileprivate var dismissButton = ModalButton(frame: CGRect())
  fileprivate var status: Status = .notice
  fileprivate var durationTimer: Timer!
  fileprivate var _bodyHeight: CGFloat = 90
  fileprivate var _height: CGFloat = 178
  
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
    case success, error, notice, warning, info
  }
  
  public enum Action
  {
    case none, selector, closure
  }
  
  public enum Shadow
  {
    case normal, curl, hover
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
      backgroundColor = UIColor.white
      borderColor = UIColor.lightGray
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
      shadowType = .normal
      shadowColor = UIColor.black
      shadowOffset = CGSize(width: 0, height: 2)
      shadowOpacity = 0.2
      shadowRadius = 1
      overlayColor = UIColor.clear
      overlayBlurStyle = .light
      titleColor = UIColor.darkGray
      bodyColor = UIColor.gray
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
    var actionType = Action.none
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
    view.frame = UIScreen.main.bounds
    view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
    view.backgroundColor = _settings.overlayColor
    view.addSubview(_overlay)
    
    // Overlay
    _overlay.frame = view.frame
    _overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    _overlay.addSubview(dialog)
    
    // Dialog
    dialog.backgroundColor = _settings.backgroundColor
    dialog.layer.borderColor = _settings.borderColor.cgColor
    dialog.layer.cornerRadius = _settings.borderRadius
    dialog.layer.masksToBounds = false
    dialog.layer.borderWidth = _settings.borderWidth
    
    // Title
    titleLabel.textColor = _settings.titleColor
    titleLabel.numberOfLines = 1
    titleLabel.textAlignment = .center
    titleLabel.font = Font.header
    titleLabel.frame = CGRect(x: _settings.padding, y: _settings.padding, width: width - 2 * _settings.padding, height: _settings.titleHeight)
    dialog.addSubview(titleLabel)
    
    // Body
    bodyLabel.backgroundColor = UIColor.clear
    bodyLabel.textColor = _settings.bodyColor
    bodyLabel.isEditable = false
    bodyLabel.textAlignment = .center
    bodyLabel.textContainerInset = UIEdgeInsets.zero
    bodyLabel.textContainer.lineFragmentPadding = 0;
    bodyLabel.font = Font.text
    dialog.addSubview(bodyLabel)
    
    // Button
    dismissButton.setTitle(_settings.dismissText, for: UIControlState())
    dismissButton.titleLabel?.font = Font.button
    dismissButton.actionType = Action.selector
    dismissButton.target = self
    dismissButton.selector = #selector(self.hide)
    dismissButton.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
    dialog.addSubview(dismissButton)
  }
  
  
  override open func viewWillLayoutSubviews()
  {
    super.viewWillLayoutSubviews()
    
    var size = UIScreen.main.bounds.size
    
    if (UIDevice.current.systemVersion as NSString).floatValue < 8.0
    {
      // iOS versions before 7.0 did not switch the width and height on device roration
      if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
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
  
  func buttonTapped(_ btn: ModalButton)
  {
    switch btn.actionType
    {
      case .closure :
        btn.action()
      case .selector :
        let ctrl = UIControl()
        ctrl.sendAction(btn.selector, to:btn.target, for:nil)
      default :
        print("Unknow action type for button")
    }
    
    hide()
  }
  
  open func show(_ duration: TimeInterval = 0)
  {
    view.alpha = 0
    dialog.frame.origin.y = -view.frame.height
    
    if let rv = UIApplication.shared.keyWindow?.subviews.first
    {
      rv.addSubview(view)
      view.frame = rv.bounds
      _overlay.frame = rv.bounds
      
      // Subtitle: adjusts to text view size
      let r = bodyLabel.text.boundingRect(
        with: CGSize(width: width - 2 * _settings.padding, height: 90),
        options: .usesLineFragmentOrigin,
        attributes: [NSFontAttributeName: Font.text],
        context: nil
      )
      
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
        durationTimer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
      }
      
      // Animate the dialog
      UIView.animate(
        withDuration: 0.2,
        animations: {
          self.dialog.center.y = rv.center.y + 15
          self.view.alpha = 1
        },
        completion: {
          finished in

          UIView.animate(withDuration: 0.2, animations: { self.dialog.center = rv.center })
        }
      )
    }
  }
  
  open func hide()
  {
    UIView.animate(
      withDuration: 0.2,
      animations: {
        self.view.alpha = 0
      },
      completion: {
        finished in
        
        self.view.removeFromSuperview()
      }
    )
  }
  
  open func addShadow(_ view: UIView, shadow: Shadow)
  {
    view.layer.shadowColor = _settings.shadowColor.cgColor
    view.layer.shadowOffset = _settings.shadowOffset
    view.layer.shadowOpacity = _settings.shadowOpacity
    view.layer.shadowRadius = _settings.shadowRadius
    
    switch shadow
    {
      case .normal :
        addDropShadow(view)
      case .curl :
        addCurlShadow(view)
      case .hover :
        addHoverShadow(view)
    }
  }
  
  fileprivate func metaForStatus(_ status: Status) -> (text: String, color: UIColor)
  {
    switch status
    {
      case .success :
        return ("Success", Color.success)
        
      case .error :
        return ("Error", Color.error)
        
      case .notice :
        return ("Notice", Color.notice)
        
      case .warning :
        return ("Warning", Color.warning)
        
      case .info :
        return ("Info", Color.info)
    }
  }
  
  fileprivate func addDropShadow(_ view: UIView) {}
  
  fileprivate func addCurlShadow(_ view: UIView)
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
    path.move(to: CGPoint(x: radius, y: height))
    
    // top right
    path.addLine(to: CGPoint(x: width - 2 * radius, y: height))
    
    // bottom right + a little extra
    path.addLine(to: CGPoint(x: width - 2 * radius, y: height + depth))
    
    // path to bottom left via curve
    path.addCurve(
      to: CGPoint(x: radius, y: height + depth),
      controlPoint1: CGPoint(x: width - curvyness, y: height + lessDepth - curvyness),
      controlPoint2: CGPoint(x: curvyness, y: height + lessDepth - curvyness)
    )
    
    view.layer.shadowPath = path.cgPath
  }
  
  fileprivate func addHoverShadow(_ view: UIView)
  {
    let ovalRect = CGRect(x: 10, y: _height + 15, width: width - 20, height: 15)
    let path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
    
    view.layer.shadowPath = path.cgPath
  }
  
}
