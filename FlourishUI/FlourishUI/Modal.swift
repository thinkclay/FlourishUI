import UIKit

public class Modal: UIViewController
{
  private var overlay = UIVisualEffectView(effect: UIBlurEffect(style: Overlay.blurStyle))
  private var dialog = UIView()
  private var titleLabel = UILabel()
  private var bodyLabel = UITextView()
  private var dismissButton = ModalButton(frame: CGRect())
  private var status: Status = .Notice
  private var durationTimer: NSTimer!
  private var bodyHeight = Dialog.bodyHeight
  private var height = Dialog.height

  var width: CGFloat {
    var width = (view.frame.width - 2 * Dialog.padding)
    
    if Dialog.equalAspectRatio
    {
      width = width > height ? height : width
    }
    
    return width <= Dialog.maxWidth ? width : Dialog.maxWidth
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
  
  public struct Dialog
  {
    static var backgroundColor = UIColor.whiteColor()
    static var borderColor = UIColor.lightGrayColor()
    static var equalAspectRatio = false
    static var borderRadius: CGFloat = 5
    static var borderWidth: CGFloat = 0.5
    static var height: CGFloat = 178
    static var maxWidth: CGFloat = 300
    static var titleHeight: CGFloat = 40
    static var bodyHeight: CGFloat = 90
    static var margin: CGFloat = 20
    static var padding: CGFloat = 20
    static var buttonHeight: CGFloat = 40
    static var buttonCornerRadius: Float = 3
    static var dismissText = "Close"
    
    // Shadows
    static var shadowType: Shadow = .Normal
    static var shadowColor: UIColor = UIColor.blackColor()
    static var shadowOffset: CGSize = CGSize(width: 0, height: 2)
    static var shadowOpacity: Float = 0.2
    static var shadowRadius: CGFloat = 1
  }
  
  public struct Overlay
  {
    static var backgroundColor: UIColor = UIColor.clearColor()
    static var blurStyle: UIBlurEffectStyle = .Light
  }
  
  public struct Color
  {
    static var title = UIColor.darkGrayColor()
    static var body = UIColor.grayColor()
    
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
  
  required public init(coder aDecoder: NSCoder)
  {
    fatalError("NSCoding not supported")
  }
  
  override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
  {
    super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
  
    // Set up main view
    view.frame = UIScreen.mainScreen().bounds
    view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    view.backgroundColor = Overlay.backgroundColor
    view.addSubview(overlay)
    
    // Overlay
    overlay.frame = view.frame
    overlay.autoresizingMask = .FlexibleHeight | .FlexibleWidth
    overlay.addSubview(dialog)
    
    // Dialog
    dialog.backgroundColor = Dialog.backgroundColor
    dialog.layer.borderColor = Dialog.borderColor.CGColor
    dialog.layer.cornerRadius = Dialog.borderRadius
    dialog.layer.masksToBounds = false
    dialog.layer.borderWidth = Dialog.borderWidth
    
    // Title
    titleLabel.textColor = Color.title
    titleLabel.numberOfLines = 1
    titleLabel.textAlignment = .Center
    titleLabel.font = Font.header
    titleLabel.frame = CGRect(x: Dialog.padding, y: Dialog.padding, width: width - 2 * Dialog.padding, height: Dialog.titleHeight)
    dialog.addSubview(titleLabel)
    
    // Body
    bodyLabel.backgroundColor = UIColor.clearColor()
    bodyLabel.textColor = Color.body
    bodyLabel.editable = false
    bodyLabel.textAlignment = .Center
    bodyLabel.textContainerInset = UIEdgeInsetsZero
    bodyLabel.textContainer.lineFragmentPadding = 0;
    bodyLabel.font = Font.text
    dialog.addSubview(bodyLabel)
    
    // Button
    dismissButton.setTitle(Dialog.dismissText, forState: .Normal)
    dismissButton.titleLabel?.font = Font.button
    dismissButton.actionType = Action.Selector
    dismissButton.target = self
    dismissButton.selector = Selector("hide")
    dismissButton.addTarget(self, action: Selector("buttonTapped:"), forControlEvents: .TouchUpInside)
    dialog.addSubview(dismissButton)
  }
  
  init()
  {
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience init(title: String?, body: String?, status: Status)
  {
    self.init()
    
    self.titleLabel.text = title
    self.bodyLabel.text = body
    self.status = status
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
    overlay.frame.size = size
    
    // Set frames
    addShadow(dialog, shadow: Dialog.shadowType)
    dialog.frame.size = CGSize(width: width, height: height)
    dialog.center.x = view.center.x
    dialog.center.y = view.center.y
    
    let x = Dialog.padding
    var y = Dialog.padding + Dialog.titleHeight
    let w = width - (2 * Dialog.padding)
    
    bodyLabel.frame = CGRect(x: x, y: y, width: w, height: bodyHeight)
    dismissButton.frame = CGRect(x: x, y: y + bodyHeight + Dialog.padding, width: w, height: Dialog.buttonHeight)
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
        println("Unknow action type for button")
    }

    hide()
  }
  
  public func show(duration: NSTimeInterval = 0) -> Modal
  {
    view.alpha = 0
    dialog.frame.origin.y = -view.frame.height
    
    if let rv = UIApplication.sharedApplication().keyWindow?.subviews.first as? UIView
    {
      rv.addSubview(view)
      view.frame = rv.bounds
      overlay.frame = rv.bounds
    
      // Dialog color scheme
      let statusColor = metaForStatus(status).color
      
      // Subtitle: adjusts to text view size
      let r = bodyLabel.text.boundingRectWithSize(CGSize(width: width - 2 * Dialog.padding, height: 90),
        options: .UsesLineFragmentOrigin,
        attributes: [NSFontAttributeName: Font.text],
        context: nil)
      
      let textHeight = ceil(r.size.height)
      
      if textHeight < bodyHeight
      {
        height -= (bodyHeight - textHeight)
        bodyHeight = textHeight
      }
      
      height += Dialog.buttonHeight + Dialog.padding
      
      if duration > 0
      {
        durationTimer?.invalidate()
        durationTimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("hide"), userInfo: nil, repeats: false)
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
    view.layer.shadowColor = Dialog.shadowColor.CGColor
    view.layer.shadowOffset = Dialog.shadowOffset
    view.layer.shadowOpacity = Dialog.shadowOpacity
    view.layer.shadowRadius = Dialog.shadowRadius
    
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
    
    var path = UIBezierPath()
    
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
    var ovalRect = CGRect(x: 10, y: height + 15, width: width - 20, height: 15)
    var path = UIBezierPath(roundedRect: ovalRect, cornerRadius: 10)
    
    view.layer.shadowPath = path.CGPath
  }
}
