import UIKit

class ViewController: UIViewController
{
  let body = "This is a modal example with some pretty funky rad text in it!! You better not make fun of me, scro"

  @IBAction func showModalExamples(sender: UIButton)
  {
    switch sender.tag
    {
      case 1 :
        Modal(title: sender.titleLabel?.text, body: body, status: .Success).show()
      
      case 2 :
        var settings = Modal.Settings()
        settings.backgroundColor = .whiteColor()
        settings.shadowType = .Hover
        settings.shadowRadius = CGFloat(5)
        settings.shadowOffset = CGSize(width: 0, height: 0)
        settings.shadowOpacity = 0.1
        settings.overlayBlurStyle = .ExtraLight

        Modal(title: sender.titleLabel?.text, body: body, status: .Warning, settings: settings).show()
      
      case 3 :
        var settings = Modal.Settings()
        settings.borderRadius = 0
        settings.shadowType = .Curl
        settings.shadowOffset = CGSize(width: 0, height: -3)
        
        Modal(title: sender.titleLabel?.text, body: body, status: .Error, settings: settings).show()

      case 4 :
        var settings = Modal.Settings()
        settings.overlayBlurStyle = .Dark
        settings.backgroundColor = UIColor(red: 200/255, green: 203/255, blue: 177/255, alpha: 0.5)
        settings.bodyColor = .whiteColor()
        Modal(title: sender.titleLabel?.text, body: body, status: .Notice, settings: settings).show()

      case 5 :
        var settings = Modal.Settings()
        settings.overlayColor = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 0.25)
        settings.backgroundColor = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 0.25)
        settings.borderColor = .whiteColor()
        settings.titleColor = .whiteColor()
        settings.bodyColor = .blueColor()
        Modal(title: sender.titleLabel?.text, body: body, status: .Info, settings: settings).show()
      
      default :
        Modal(title: sender.titleLabel?.text, body: body, status: .Info).show()

    }
  }

}