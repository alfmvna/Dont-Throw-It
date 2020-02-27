//
//  ViewController.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 08/02/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var masukButon: UIButton!
    
    @IBOutlet weak var daftarButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
    
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(masukButon)
        
        Utilities.styleFilledButton(daftarButton)
    }
    

}

