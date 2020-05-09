//
//  ViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import JGProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var masukButton: UIButton!
    @IBOutlet weak var daftarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                let myTabbar = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.myTabbar) as! UITabBarController
                self.view.window?.rootViewController = myTabbar
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

extension ViewController{
    func showSimpleHUD() {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        #if os(tvOS)
        hud.textLabel.text = "Simple example on tvOS in Swift"
        #else
        hud.textLabel.text = "Simple example in Swift"
        #endif
        hud.detailTextLabel.text = "See JGProgressHUD-Tests for more examples"
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.show(in: self.view)
    }
    
    func showHUDWithTransform() {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 10.0, right: 0.0)
        
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
            UIView.animate(withDuration: 0.3) {
                hud.indicatorView = nil
                hud.textLabel.font = UIFont.systemFont(ofSize: 30.0)
                hud.textLabel.text = "Done"
                hud.position = .center
            }
        }
        
        hud.dismiss(afterDelay: 4.0)
    }
    
    func showLoadingHUD() {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        if arc4random_uniform(2) == 0 {
            hud.indicatorView = JGProgressHUDPieIndicatorView()
        }
        else {
            hud.indicatorView = JGProgressHUDRingIndicatorView()
        }
        hud.detailTextLabel.text = "0% Complete"
        hud.textLabel.text = "Downloading"
        hud.show(in: self.view)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) {
            self.incrementHUD(hud, progress: 0)
        }
    }
    
    func incrementHUD(_ hud: JGProgressHUD, progress previousProgress: Int) {
        let progress = previousProgress + 1
        hud.progress = Float(progress)/100.0
        hud.detailTextLabel.text = "\(progress)% Complete"
        
        if progress == 100 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                UIView.animate(withDuration: 0.1, animations: {
                    hud.textLabel.text = "Success"
                    hud.detailTextLabel.text = nil
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                })
                
                hud.dismiss(afterDelay: 1.0)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.showHUDWithTransform()
                }
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(20)) {
                self.incrementHUD(hud, progress: progress)
            }
        }
    }
}

