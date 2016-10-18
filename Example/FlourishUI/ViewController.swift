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
