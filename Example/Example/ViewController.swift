//
//  ViewController.swift
//  MMNavigationController
//
//  Created by Mango on 2016/11/10.
//  Copyright © 2016年 MangoMade. All rights reserved.
//

import UIKit

import MMNavigationController

class BaseViewController: UIViewController {
    
    let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        
        
        view.addSubview(nextButton)
        nextButton.setTitle("To next page", for: UIControlState())
        nextButton.sizeToFit()
        nextButton.center = Screen.center
        nextButton.addTarget(self, action: #selector(reponseToNext(_:)), for: .touchUpInside)
        
    }
    
    func reponseToNext(_ sender: UIButton) {
        
    }
    
}

class NormalViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Normal"
    }
    
    override func reponseToNext(_ sender: UIButton) {
        navigationController?.pushViewController(RandomColorViewController(), animated: true)
    }
    
}

class RandomColorViewController: BaseViewController {
    
    var delegate: TestDelegate? = TestDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        title = "Random Color"
        
        mm.navigationBarBackgroundColor = UIColor.random
        mm.popGestrueEnableWidth  = 150
        mm.navigationBarTitleColor = UIColor.white
        mm.gestureDelegate = delegate
        
        let gestureEnableLabel = UILabel()
        gestureEnableLabel.numberOfLines = 0
        gestureEnableLabel.textAlignment = .center
        gestureEnableLabel.text = "pop手势\n\n灰色区域内\n\n有效"
        gestureEnableLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        gestureEnableLabel.frame = CGRect(x: 0, y: 0, width: mm.popGestrueEnableWidth, height: view.bounds.height)
        view.addSubview(gestureEnableLabel)
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 100, width: Screen.width, height: 100)
        scrollView.backgroundColor = .gray
        scrollView.contentSize = CGSize(width: Screen.width * 2, height: 100)
        view.addSubview(scrollView)

    }
    
    override func reponseToNext(_ sender: UIButton) {
        navigationController?.pushViewController(HiddenBarViewController(), animated: true)
    }
    
}

class TestDelegate: NSObject {
    
}

extension TestDelegate: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class HiddenBarViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mm.navigationBarHidden = true
        
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 100, width: Screen.width, height: 100)
        scrollView.backgroundColor = .gray
        scrollView.contentSize = CGSize(width: Screen.width * 2, height: 100)
        view.addSubview(scrollView)
    }
    
    override func reponseToNext(_ sender: UIButton) {
        navigationController?.pushViewController(NormalViewController(), animated: true)
    }
}

extension UIColor {
    
    static var random: UIColor {
        let randR = CGFloat(arc4random_uniform(255)) / 255.0
        let randG = CGFloat(arc4random_uniform(255)) / 255.0
        let randB = CGFloat(arc4random_uniform(255)) / 255.0
        return UIColor(red: randR, green: randG, blue: randB, alpha: 1)
    }
    
}

extension UIImage {
    
    static func imageWithColor(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
