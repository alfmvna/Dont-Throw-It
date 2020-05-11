//
//  AlertService.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 19/04/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import UIKit

class AlertService {
    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
    }

}
