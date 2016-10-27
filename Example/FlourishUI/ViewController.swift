//
//  ViewController.swift
//  FlourishUI
//
//  Created by Clay McIlrath on 01/22/2016.
//  Copyright (c) 2016 Clay McIlrath. All rights reserved.
//

import UIKit
import FlourishUI

class ViewController: UIViewController
{
  let body = "This is a modal example with some pretty funky rad text in it!! You better not make fun of me, scro"
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    
    // 
    // Toggle switch with callback
    //
    let toggle1 = ToggleSwitch()
    toggle1.frame = CGRect(x: 20, y: view.frame.height - 50, width: view.frame.width - 40, height: 24)
    toggle1.active = true
    toggle1.toggleCallback = {
      Modal(title: "Don't toggle me bro!", body: "This was triggered by the toggle callback", status: .success).show()
    }
    toggle1.label.setTitle("Callback", for: .normal)
    view.addSubview(toggle1)
    
    
//
// Customizing toggle switches
//
let greenColor = UIColor(hex: "#3D8C8E")

let toggle2 = ToggleSwitch()
toggle2.frame = CGRect(x: 20, y: view.frame.height - 100, width: view.frame.width - 40, height: 24)
toggle2.label.setTitle("Custom styled toggle", for: .normal)
toggle2.active = true

// Customize the label associated with the toggle switch
toggle2.label.frame.size.width = 200
toggle2.label.titleLabel?.textColor = .black

// Customize the background which the toggle button slides across
toggle2.slide.activeBackgroundColor = greenColor.adjustValue(percentage: 1.4)
toggle2.slide.activeBorderColor = greenColor.adjustValue(percentage: 1.0)
toggle2.slide.disabledBackgroundColor = UIColor(hex: "#99896F")
toggle2.slide.disabledBorderColor = UIColor(hex: "#99896F").adjustValue(percentage: 0.5)

// Customize the round toggle button
toggle2.button.activeBackgroundColor = greenColor.adjustValue(percentage: 1.3)
toggle2.button.activeBorderColor = greenColor.adjustValue(percentage: 1.1)
toggle2.button.disabledBackgroundColor = UIColor(rgba: [153, 137, 111, 0.8])
toggle2.button.disabledBorderColor = UIColor(rgba: [153, 137, 111, 0.8]).adjustValue(percentage: 0.5)

view.addSubview(toggle2)
  }
  
  @IBAction func showModalExamples(_ sender: UIButton)
  {
    switch sender.tag
    {
      case 1 :
        Modal(title: sender.titleLabel?.text, body: body, status: .success).show()
        
      case 2 :
        var settings = Modal.Settings()
        settings.backgroundColor = .white
        settings.shadowType = .hover
        settings.shadowRadius = CGFloat(5)
        settings.shadowOffset = CGSize(width: 0, height: 0)
        settings.shadowOpacity = 0.1
        settings.overlayBlurStyle = .extraLight
        
        Modal(title: sender.titleLabel?.text, body: body, status: .warning, settings: settings).show()
        
      case 3 :
        var settings = Modal.Settings()
        settings.borderRadius = 0
        settings.shadowType = .curl
        settings.shadowOffset = CGSize(width: 0, height: -3)
        
        Modal(title: sender.titleLabel?.text, body: body, status: .error, settings: settings).show()
        
      case 4 :
        var settings = Modal.Settings()
        settings.overlayBlurStyle = .dark
        settings.backgroundColor = UIColor(red: 200/255, green: 203/255, blue: 177/255, alpha: 0.5)
        settings.bodyColor = .white
        Modal(title: sender.titleLabel?.text, body: body, status: .notice, settings: settings).show()
        
      case 5 :
        var settings = Modal.Settings()
        settings.overlayColor = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 0.25)
        settings.backgroundColor = UIColor(red: 40/255, green: 102/255, blue: 191/255, alpha: 0.25)
        settings.borderColor = .white
        settings.titleColor = .white
        settings.bodyColor = .blue
        Modal(title: sender.titleLabel?.text, body: body, status: .info, settings: settings).show()
        
      default :
        Modal(title: sender.titleLabel?.text, body: body, status: .info).show()
    }
  }
  
}
