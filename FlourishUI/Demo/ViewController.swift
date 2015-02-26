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
        Modal.Overlay.blurStyle = .ExtraLight
        Modal.Dialog.shadowType = .Hover
        Modal.Dialog.shadowRadius = CGFloat(5)
        Modal.Dialog.shadowOffset = CGSize(width: 0, height: 0)
        Modal.Dialog.shadowOpacity = 0.1
        Modal(title: sender.titleLabel?.text, body: body, status: .Warning).show()
      
      case 3 :
        Modal.Overlay.blurStyle = .Light
        Modal.Dialog.borderRadius = 0
        Modal.Dialog.shadowType = .Curl
        Modal.Dialog.shadowOffset = CGSize(width: 0, height: -3)
        Modal(title: sender.titleLabel?.text, body: body, status: .Error).show()
      
      case 4 :
        Modal.Overlay.blurStyle = .Dark
        Modal.Overlay.backgroundColor = UIColor(red: 200/255, green: 203/255, blue: 177/255, alpha: 0.5)
        Modal(title: sender.titleLabel?.text, body: body, status: .Notice).show()
      
      case 5 :
        Modal.Overlay.blurStyle = .Light
        Modal.Overlay.backgroundColor = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 0.25)
        Modal.Dialog.backgroundColor = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 0.25)
        Modal.Dialog.borderColor = UIColor.whiteColor()
        Modal.Color.title = UIColor.whiteColor()
        Modal.Color.body = UIColor.whiteColor()
        Modal(title: sender.titleLabel?.text, body: body, status: .Info).show()
      
      default :
        Modal(title: sender.titleLabel?.text, body: body, status: .Info).show()

    }
  }

}